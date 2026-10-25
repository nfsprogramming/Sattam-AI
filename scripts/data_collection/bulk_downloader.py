import os
import argparse
from collectors.github_collector import GithubCollector
from metadata.generator import DocumentMetadata, save_metadata

# Hardcoded raw github URLs for datasets
DATASETS = [
    {
        "name": "Constitution_of_India",
        "url": "https://raw.githubusercontent.com/Yash-Handa/The_Constitution_Of_India/master/constitution_of_india.json",
        "category": "constitution"
    },
    {
        "name": "Indian_Penal_Code",
        "url": "https://raw.githubusercontent.com/civictech-India/Indian-Law-Penal-Code-Json/master/ipc.json",
        "category": "criminal"
    }
]

def run_bulk_download(output_dir: str):
    print("Starting Bulk Download of Open Datasets...")
    
    # Ensure directories exist
    os.makedirs(os.path.join(output_dir, "constitution"), exist_ok=True)
    os.makedirs(os.path.join(output_dir, "criminal"), exist_ok=True)
    os.makedirs(os.path.join(output_dir, "metadata"), exist_ok=True)
    
    for ds in DATASETS:
        print(f"\nProcessing {ds['name']}...")
        collector = GithubCollector(source_name=ds["name"], raw_url=ds["url"])
        
        md_text = collector.collect()
        
        # Save Markdown content
        md_output_path = os.path.join(output_dir, ds["category"], f"{ds['name']}.md")
        with open(md_output_path, 'w', encoding='utf-8') as f:
            f.write(md_text)
        print(f"Content saved to {md_output_path}")
        
        # Generate & Save Metadata
        meta = DocumentMetadata(
            title=ds["name"].replace("_", " "),
            category=ds["category"].capitalize(),
            source=ds["url"],
            version="Bulk-Download-1.0"
        )
        meta_output_path = os.path.join(output_dir, "metadata", f"{ds['name']}_meta.json")
        save_metadata(meta, meta_output_path)
        
    print("\nBulk Download finished successfully!")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="SattamAI Bulk Downloader")
    parser.add_argument("--output", type=str, default="../../datasets", help="Path to datasets directory")
    args = parser.parse_args()
    
    base_dir = os.path.dirname(os.path.abspath(__file__))
    output_dir = os.path.abspath(os.path.join(base_dir, args.output))
    
    run_bulk_download(output_dir)
