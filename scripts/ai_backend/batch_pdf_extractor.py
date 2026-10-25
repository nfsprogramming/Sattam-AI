import os
import pdfplumber
import json
from tqdm import tqdm
import re

def clean_text(text):
    if not text:
        return ""
    text = re.sub(r'\s+', ' ', text)
    return text.strip()

def extract_from_pdfs(books_dir, output_file):
    print(f"Extracting text from all PDFs in {books_dir}...")
    
    pdf_files = [f for f in os.listdir(books_dir) if f.endswith('.pdf')]
    print(f"Found {len(pdf_files)} PDFs.")
    
    # We will save extracted data as a JSONL (JSON Lines) to handle large datasets
    # Structure: {"file": filename, "page": page_num, "text": content}
    
    total_pages = 0
    with open(output_file, 'w', encoding='utf-8') as out_f:
        for filename in tqdm(pdf_files, desc="Processing PDFs"):
            filepath = os.path.join(books_dir, filename)
            try:
                with pdfplumber.open(filepath) as pdf:
                    for i, page in enumerate(pdf.pages):
                        text = clean_text(page.extract_text())
                        if text:
                            record = {
                                "file": filename,
                                "page": i + 1,
                                "text": text
                            }
                            out_f.write(json.dumps(record) + "\n")
                            total_pages += 1
            except Exception as e:
                print(f"\nFailed to extract {filename}: {e}")
                
    print(f"Extraction complete! Extracted {total_pages} pages of text into {output_file}")

if __name__ == "__main__":
    books_directory = r"e:\SATTAM AI\books"
    output_jsonl = r"e:\SATTAM AI\datasets\books_extracted.jsonl"
    
    os.makedirs(r"e:\SATTAM AI\datasets", exist_ok=True)
    extract_from_pdfs(books_directory, output_jsonl)
