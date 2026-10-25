from langchain_community.vectorstores import Chroma
from langchain_huggingface import HuggingFaceEmbeddings
import os
import time

print("Loading embeddings...")
start_init = time.time()
embeddings = HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")
db_dir = os.path.abspath(r"e:\SATTAM AI\datasets\chroma_db")
vectorstore = Chroma(persist_directory=db_dir, embedding_function=embeddings)
print(f"Init took {time.time() - start_init:.2f}s")

print("Running search 1...")
start1 = time.time()
docs = vectorstore.similarity_search("theft", k=3)
print(f"Search 1 took {time.time() - start1:.2f}s")

print("Running search 2...")
start2 = time.time()
docs = vectorstore.similarity_search("murder", k=3)
print(f"Search 2 took {time.time() - start2:.2f}s")
