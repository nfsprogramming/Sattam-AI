from langchain_community.vectorstores import Chroma
from langchain_huggingface import HuggingFaceEmbeddings
import os

print("Loading embeddings...")
embeddings = HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")
db_dir = os.path.abspath(r"e:\SATTAM AI\datasets\chroma_db")
print("Loading vectorstore...")
vectorstore = Chroma(persist_directory=db_dir, embedding_function=embeddings)

print("Running search...")
docs = vectorstore.similarity_search("theft", k=3)
print(f"Found {len(docs)} docs")
