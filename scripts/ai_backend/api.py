from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse, FileResponse
from pydantic import BaseModel
import tempfile
import uuid
from pdf_generator import create_pdf
from langchain_community.vectorstores import Chroma
from langchain_nvidia_ai_endpoints import NVIDIAEmbeddings
import os
import json
from dotenv import load_dotenv
from openai import OpenAI

# Load environment variables
load_dotenv()
NVIDIA_API_KEY = os.getenv("NVIDIA_API_KEY")

app = FastAPI(title="Sattam AI Legal Backend", version="2.0.0")

# Add CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ChatMessage(BaseModel):
    role: str
    content: str

class ChatRequest(BaseModel):
    query: str
    history: list[ChatMessage] = []
    base64_image: str | None = None

# Initialize NVIDIA NIM Client
try:
    nim_client = OpenAI(
        base_url="https://integrate.api.nvidia.com/v1",
        api_key=NVIDIA_API_KEY,
        timeout=120.0
    )
    print("NVIDIA NIM client initialized.")
except Exception as e:
    print(f"Warning: Failed to initialize NIM client: {e}")
    nim_client = None

# Load the LangChain Vector Database
db_dir = os.path.abspath(r"e:\SATTAM AI\datasets\chroma_db")
print("Loading LangChain Database...")

try:
    embeddings = NVIDIAEmbeddings(model="nvidia/nv-embedqa-e5-v5", api_key=NVIDIA_API_KEY)
    vectorstore = Chroma(persist_directory=db_dir, embedding_function=embeddings)
    print("Database loaded successfully.")
except Exception as e:
    print(f"Warning: Database not found or failed to load. Error: {e}")
    vectorstore = None


def generate_stream(query: str, history: list = None, base64_image: str = None):
    """Generator function that streams tokens from NVIDIA NIM as Server-Sent Events."""
    
    # 1. Search the vector database — use MMR for diverse, non-redundant results
    print(f"DEBUG: Searching for: {query}")
    docs = vectorstore.max_marginal_relevance_search(query, k=6, fetch_k=20)
    print(f"DEBUG: Found {len(docs)} docs")

    # 2. Build rich context
    context_text = ""
    for i, doc in enumerate(docs, 1):
        src = doc.metadata.get('source', 'Unknown')
        pg = doc.metadata.get('page', '?')
        context_text += f"--- Snippet {i} [Source: {src}, Page: {pg}] ---\n{doc.page_content}\n\n"

    system_prompt = (
        "You are Sattam AI, a precise AI lawyer specializing in Indian Law.\n\n"
        "RESPONSE FORMAT:\n"
        "1. Be extremely concise, conversational, and direct.\n"
        "2. Answer the user's question in just 1-2 short paragraphs.\n"
        "3. Only mention the most critical legal section or act if absolutely necessary. DO NOT list exhaustive bullet points.\n"
        "4. Avoid complex markdown headers.\n\n"
        "CITATION RULES:\n"
        "- NEVER mention PDF filenames or page numbers in your response.\n"
        "- Convert source filenames to proper Act names (e.g., IPC -> Indian Penal Code).\n"
        "- Never invent or guess punishments not present in the text.\n"
        "- If context is insufficient, politely say so.\n\n"
        f"LEGAL CONTEXT SNIPPETS:\n{context_text}"
    )

    # 3. Stream from NVIDIA NIM
    print("DEBUG: Streaming from NVIDIA NIM...")
    messages = [{"role": "system", "content": system_prompt}]
    if history:
        # Include last few conversational turns
        for msg in history[-6:]:
            messages.append({"role": msg.role, "content": msg.content})
            
    if base64_image:
        messages.append({
            "role": "user",
            "content": [
                {"type": "text", "text": query},
                {
                    "type": "image_url",
                    "image_url": {"url": f"data:image/jpeg;base64,{base64_image}"}
                }
            ]
        })
        target_model = "meta/llama-3.2-11b-vision-instruct"
        max_tok = 512
    else:
        messages.append({"role": "user", "content": query})
        target_model = "meta/llama-3.1-70b-instruct"
        max_tok = 1024

    try:
        stream = nim_client.chat.completions.create(
            model=target_model,
            temperature=0.2,
            top_p=0.7,
            max_tokens=max_tok,
            stream=True,  # KEY: streaming enabled
            messages=messages
        )
        for chunk in stream:
            if chunk.choices and chunk.choices[0].delta.content:
                token = chunk.choices[0].delta.content
                # Send as SSE event
                yield f"data: {json.dumps({'token': token})}\n\n"
        
        # Signal end of stream
        yield f"data: {json.dumps({'done': True})}\n\n"
        print("DEBUG: Stream complete.")

    except Exception as e:
        print(f"DEBUG: NVIDIA Error: {e}")
        yield f"data: {json.dumps({'error': str(e)})}\n\n"


@app.post("/chat/stream")
def chat_stream(request: ChatRequest):
    if vectorstore is None:
        raise HTTPException(status_code=500, detail="Database not loaded.")
    if not NVIDIA_API_KEY:
        raise HTTPException(status_code=500, detail="NVIDIA_API_KEY not set.")

    return StreamingResponse(
        generate_stream(request.query, request.history, request.base64_image),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "X-Accel-Buffering": "no",
        }
    )


@app.post("/chat")
def chat_endpoint(request: ChatRequest):
    """Non-streaming fallback endpoint."""
    if vectorstore is None:
        raise HTTPException(status_code=500, detail="Database not loaded.")
    if not NVIDIA_API_KEY:
        raise HTTPException(status_code=500, detail="NVIDIA_API_KEY not set.")

    docs = vectorstore.max_marginal_relevance_search(request.query, k=6, fetch_k=20)
    sources = []
    context_text = ""
    for i, doc in enumerate(docs, 1):
        sources.append(doc.metadata)
        src = doc.metadata.get('source', 'Unknown')
        pg = doc.metadata.get('page', '?')
        context_text += f"--- Snippet {i} [Source: {src}, Page: {pg}] ---\n{doc.page_content}\n\n"

    system_prompt = (
        "You are Sattam AI, a precise and knowledgeable AI lawyer specializing in Indian Law.\n\n"
        "INSTRUCTIONS:\n"
        "1. Answer the user's legal question using ONLY the provided legal text snippets.\n"
        "2. Extract EXACT information: section numbers, punishment durations, fine amounts, bail conditions.\n"
        "3. If a section number is mentioned in the context, ALWAYS quote it explicitly.\n"
        "4. If the exact punishment is stated, quote it verbatim.\n"
        "5. Always cite your source: document name and page number after each point.\n"
        "6. Structure your answer with bullet points for multiple punishments or conditions.\n"
        "7. Never fabricate section numbers or punishments not present in the context.\n\n"
        f"LEGAL CONTEXT SNIPPETS:\n{context_text}"
    )

    try:
        completion = nim_client.chat.completions.create(
            model="meta/llama-3.1-70b-instruct",
            temperature=0.2,
            top_p=0.7,
            max_tokens=1024,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": request.query}
            ]
        )
        return {"answer": completion.choices[0].message.content, "sources": sources}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"NVIDIA API Error: {str(e)}")


@app.get("/")
def health_check():
    return {"status": "Sattam AI Backend v2.0 Running", "streaming": True}

class DocumentRequest(BaseModel):
    name: str
    address: str
    against: str
    description: str

@app.post("/generate_document")
def generate_document_endpoint(req: DocumentRequest):
    temp_dir = tempfile.gettempdir()
    file_name = f"Legal_Document_{uuid.uuid4().hex[:6]}.pdf"
    output_path = os.path.join(temp_dir, file_name)
    
    try:
        create_pdf(
            name=req.name,
            address=req.address,
            against=req.against,
            description=req.description,
            output_path=output_path
        )
        return FileResponse(
            path=output_path, 
            filename="Legal_Document.pdf", 
            media_type="application/pdf"
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
