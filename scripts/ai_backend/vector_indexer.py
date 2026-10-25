import os
import json
import numpy as np
from sentence_transformers import SentenceTransformer
from tqdm import tqdm

def index_documents(jsonl_file, output_dir):
    print(f"Loading extracted text from {jsonl_file}...")
    
    docs = []
    metadata = []
    
    if not os.path.exists(jsonl_file):
        print("Extracted file not found. Please run batch_pdf_extractor.py first.")
        return
        
    # Read and chunk large texts
    # We'll do a simple character chunking to ensure embeddings don't overflow context limits
    MAX_CHUNK_CHARS = 1500
    
    with open(jsonl_file, 'r', encoding='utf-8') as f:
        for line in tqdm(f, desc="Reading and chunking JSONL"):
            if not line.strip():
                continue
            record = json.loads(line)
            text = record['text']
            
            # Simple chunking
            chunks = [text[i:i+MAX_CHUNK_CHARS] for i in range(0, len(text), MAX_CHUNK_CHARS)]
            for c_idx, chunk in enumerate(chunks):
                if len(chunk.strip()) > 50: # Ignore tiny chunks
                    docs.append(chunk)
                    metadata.append({
                        "file": record['file'],
                        "page": record['page'],
                        "chunk_idx": c_idx
                    })

    print(f"Loaded {len(docs)} document chunks.")
    
    # Initialize Embedding Model
    print("Initializing embedding model (all-MiniLM-L6-v2)...")
    model = SentenceTransformer('all-MiniLM-L6-v2')
    
    print("Generating vector embeddings... this might take several minutes.")
    # Generate embeddings in batches
    embeddings = model.encode(docs, batch_size=32, show_progress_bar=True)
    
    print(f"Embeddings shape: {embeddings.shape}")
    
    # Save the database locally
    os.makedirs(output_dir, exist_ok=True)
    
    np.save(os.path.join(output_dir, "embeddings.npy"), embeddings)
    with open(os.path.join(output_dir, "metadata.json"), 'w', encoding='utf-8') as f:
        json.dump(metadata, f, indent=2)
    with open(os.path.join(output_dir, "documents.json"), 'w', encoding='utf-8') as f:
        json.dump(docs, f, indent=2)
        
    print(f"Vector Database successfully saved to {output_dir}!")

if __name__ == "__main__":
    extracted_jsonl = r"e:\SATTAM AI\datasets\books_extracted.jsonl"
    db_dir = r"e:\SATTAM AI\datasets\numpy_db"
    
    index_documents(extracted_jsonl, db_dir)
