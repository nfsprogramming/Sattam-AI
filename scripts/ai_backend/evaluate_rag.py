import os
import json
import time
from tqdm import tqdm
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import Chroma
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_core.documents import Document

def load_documents(jsonl_file):
    print(f"Loading extracted text from {jsonl_file}...")
    docs = []
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
    return docs

def build_pipeline(docs, model_name, persist_dir, chunk_size, chunk_overlap):
    print(f"\n{'='*50}")
    print(f"Building Pipeline: {model_name}")
    print(f"Chunk Size: {chunk_size}, Overlap: {chunk_overlap}")
    print(f"{'='*50}")
    
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=chunk_size,
        chunk_overlap=chunk_overlap,
        length_function=len
    )
    
    chunked_docs = text_splitter.split_documents(docs)
    print(f"Created {len(chunked_docs)} semantic chunks.")
    
    print("Initializing Embeddings (Forcing NVIDIA GPU)...")
    embeddings = HuggingFaceEmbeddings(
        model_name=model_name,
        model_kwargs={'device': 'cuda'}
    )
    
    print(f"Indexing into ChromaDB at {persist_dir}...")
    start_time = time.time()
    
    # Process in batches to save memory
    batch_size = 500
    vectorstore = None
    
    for i in tqdm(range(0, len(chunked_docs), batch_size), desc="Indexing Batches"):
        batch = chunked_docs[i:i + batch_size]
        if vectorstore is None:
            vectorstore = Chroma.from_documents(
                documents=batch, 
                embedding=embeddings, 
                persist_directory=persist_dir
            )
        else:
            vectorstore.add_documents(documents=batch)
            
    total_time = time.time() - start_time
    print(f"Pipeline {model_name} completed in {total_time:.2f} seconds!")
    return vectorstore

def evaluate_pipelines(pipelines):
    queries = [
        "What is the penalty for cyber fraud?",
        "How is consumer protection handled under the new act?",
        "What are the rights of an arrested person?",
        "Define domestic violence under family law.",
        "What are the conditions for a valid contract?"
    ]
    
    print("\n\n" + "="*50)
    print("EVALUATING PIPELINES")
    print("="*50)
    
    for query in queries:
        print(f"\nQUERY: '{query}'")
        for name, vectorstore in pipelines.items():
            results = vectorstore.similarity_search_with_score(query, k=1)
            if results:
                doc, score = results[0]
                source = doc.metadata.get('source', 'Unknown')
                print(f"  [{name}] Best Match (Score: {score:.4f}) -> {source}")

if __name__ == "__main__":
    extracted_jsonl = r"e:\SATTAM AI\datasets\books_extracted.jsonl"
    
    if not os.path.exists(extracted_jsonl):
        print(f"Could not find {extracted_jsonl}. Please extract PDFs first.")
        exit(1)
        
    docs = load_documents(extracted_jsonl)
    
    # If the user has limited RAM/VRAM, we can slice docs for a quicker test
    # Uncomment the next line to test on a smaller subset:
    # docs = docs[:1000]
    
    pipelines_config = [
        ('all-MiniLM', 'all-MiniLM-L6-v2', r"e:\SATTAM AI\datasets\chroma_db_p1", 1500, 200),
        ('multi-qa-mpnet', 'sentence-transformers/multi-qa-mpnet-base-dot-v1', r"e:\SATTAM AI\datasets\chroma_db_p2", 800, 100),
        ('bge-small-en', 'BAAI/bge-small-en-v1.5', r"e:\SATTAM AI\datasets\chroma_db_p3", 500, 50)
    ]
    
    import torch
    import gc

    for name, model_name, persist_dir, chunk_size, overlap in pipelines_config:
        vectorstore = build_pipeline(docs, model_name, persist_dir, chunk_size, overlap)
        evaluate_pipelines({name: vectorstore})
        
        # Free up VRAM for the next model!
        del vectorstore
        gc.collect()
        torch.cuda.empty_cache()
        print(f"\nCleared {name} from VRAM.\n")
