import os
import json
import numpy as np
from sentence_transformers import SentenceTransformer

def cosine_similarity(a, b):
    # a is a 1D array (query), b is a 2D array (database)
    dot_product = np.dot(b, a)
    norm_a = np.linalg.norm(a)
    norm_b = np.linalg.norm(b, axis=1)
    return dot_product / (norm_a * norm_b)

def query_database(query_text, top_k=3):
    db_dir = r"e:\SATTAM AI\datasets\numpy_db"
    
    if not os.path.exists(os.path.join(db_dir, "embeddings.npy")):
        print("Database not found. Please wait for vector_indexer.py to finish.")
        return
        
    print("Loading database...")
    embeddings = np.load(os.path.join(db_dir, "embeddings.npy"))
    with open(os.path.join(db_dir, "metadata.json"), 'r', encoding='utf-8') as f:
        metadata = json.load(f)
    with open(os.path.join(db_dir, "documents.json"), 'r', encoding='utf-8') as f:
        documents = json.load(f)
        
    print("Initializing embedding model to process your query...")
    model = SentenceTransformer('all-MiniLM-L6-v2')
    
    query_vector = model.encode(query_text)
    
    print("Searching for the most relevant legal texts...")
    similarities = cosine_similarity(query_vector, embeddings)
    
    # Get top K indices
    top_indices = np.argsort(similarities)[-top_k:][::-1]
    
    print(f"\n--- TOP {top_k} RESULTS FOR: '{query_text}' ---\n")
    for i, idx in enumerate(top_indices):
        score = similarities[idx]
        doc_text = documents[idx]
        meta = metadata[idx]
        
        print(f"RESULT {i+1} (Relevance Score: {score:.4f})")
        print(f"Source Document: {meta['file']} (Page {meta['page']})")
        print(f"Text Snippet:\n{doc_text}\n")
        print("-" * 50)

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        user_query = " ".join(sys.argv[1:])
    else:
        user_query = "What is the punishment for murder?"
        
    query_database(user_query)
