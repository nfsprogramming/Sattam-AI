import os
import json
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import Chroma
from langchain_nvidia_ai_endpoints import NVIDIAEmbeddings
from langchain_core.documents import Document
from dotenv import load_dotenv
load_dotenv()
from tqdm import tqdm

def build_langchain_db(jsonl_file, persist_directory):
    print(f"Loading extracted text from {jsonl_file}...")
    
    if not os.path.exists(jsonl_file):
        print("Extracted file not found. Run extraction first.")
        return
        
    docs = []
    # Read the JSONL and create LangChain Documents
    with open(jsonl_file, 'r', encoding='utf-8') as f:
        for line in tqdm(f, desc="Reading JSONL"):
            if not line.strip():
                continue
            record = json.loads(line)
            doc = Document(
                page_content=record['text'],
                metadata={"source": record['file'], "page": record['page']}
            )
            docs.append(doc)

    print(f"Loaded {len(docs)} pages. Chunking text...")
    
    # Langchain's advanced chunking
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=400,
        chunk_overlap=50,
        length_function=len
    )
    
    chunked_docs = text_splitter.split_documents(docs)
    print(f"Created {len(chunked_docs)} semantic chunks.")
    
    # Initialize Embedding Model
    print("Initializing NVIDIA Embeddings...")
    NVIDIA_API_KEY = os.getenv("NVIDIA_API_KEY")
    embeddings = NVIDIAEmbeddings(model="nvidia/nv-embedqa-e5-v5", api_key=NVIDIA_API_KEY)
    
    print("Indexing into ChromaDB. This will take a few minutes...")
    # Batch indexing to save memory
    batch_size = 500
    vectorstore = None
    
    for i in tqdm(range(0, len(chunked_docs), batch_size), desc="Indexing Batches"):
        batch = chunked_docs[i:i + batch_size]
        if vectorstore is None:
            vectorstore = Chroma.from_documents(
                documents=batch, 
                embedding=embeddings, 
                persist_directory=persist_directory
            )
        else:
            vectorstore.add_documents(documents=batch)
            
    print(f"LangChain Vector Database successfully created at {persist_directory}!")

if __name__ == "__main__":
    extracted_jsonl = r"e:\SATTAM AI\datasets\books_extracted.jsonl"
    chroma_db_dir = r"e:\SATTAM AI\datasets\chroma_db"
    
    os.makedirs(chroma_db_dir, exist_ok=True)
    build_langchain_db(extracted_jsonl, chroma_db_dir)
