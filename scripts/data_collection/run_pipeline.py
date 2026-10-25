import os
import argparse
from collectors.pdf_scraper import PDFCollector
from processors.text_cleaner import clean_extracted_text, convert_to_markdown
from metadata.generator import DocumentMetadata, save_metadata

# Hardcoded URL for demonstration purposes - BNS from a public reliable source
BNS_PDF_URL = "https://www.mha.gov.in/sites/default/files/2023-12/The_Bharatiya_Nyaya_Sanhita_2023_0.pdf" 
# Note: For production, we should ensure the URL is the official Gazette notification

def run_pipeline(output_dir: str):
    print("Starting Data Collection Pipeline...")
    
    # 1. Collect
    collector = PDFCollector(source_name="BNS_2023", url=BNS_PDF_URL)
    raw_text = collector.collect()
    
    # 2. Process
    print("Cleaning and structuring text...")
    cleaned_text = clean_extracted_text(raw_text)
    markdown_text = convert_to_markdown(cleaned_text)
    
    # 3. Save Content
    md_output_path = os.path.join(output_dir, "criminal", "BNS_2023.md")
    with open(md_output_path, 'w', encoding='utf-8') as f:
        f.write(markdown_text)
    print(f"Content saved to {md_output_path}")
    
    # 4. Generate & Save Metadata
    meta = DocumentMetadata(
        title="The Bharatiya Nyaya Sanhita, 2023",
        category="Criminal",
        source=BNS_PDF_URL,
        publication_date="2023-12-25",
        effective_date="2024-07-01",
        version="1.0",
        keywords=["BNS", "Criminal Law", "Penal Code", "India"]
    )
    
    meta_output_path = os.path.join(output_dir, "metadata", "BNS_2023_meta.json")
    save_metadata(meta, meta_output_path)
    print("Pipeline finished successfully!")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="SattamAI Data Collection Pipeline")
    parser.add_argument("--output", type=str, default="../../datasets", help="Path to datasets directory")
    args = parser.parse_args()
    
    # Ensure absolute path based on script location
    base_dir = os.path.dirname(os.path.abspath(__file__))
    output_dir = os.path.abspath(os.path.join(base_dir, args.output))
    
    run_pipeline(output_dir)
