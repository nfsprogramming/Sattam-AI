import os
import requests
import pdfplumber
from typing import Dict, Any, Optional
from .base_collector import BaseCollector

class PDFCollector(BaseCollector):
    """
    Downloads and extracts text from a PDF file.
    """

    def __init__(self, source_name: str, url: str):
        super().__init__(source_name)
        self.url = url
        self.local_pdf_path = f"{source_name}.pdf"

    def _download_pdf(self) -> bool:
        print(f"Downloading {self.url}...")
        try:
            response = requests.get(self.url, stream=True, timeout=10)
            response.raise_for_status()
            with open(self.local_pdf_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            print("Download complete.")
            return True
        except requests.exceptions.RequestException as e:
            print(f"Failed to download PDF: {e}")
            return False

    def collect(self) -> str:
        if not os.path.exists(self.local_pdf_path):
            success = self._download_pdf()
            if not success:
                return f"Placeholder text for {self.source_name} (Download Failed)"
        
        print("Extracting text from PDF...")
        full_text = []
        with pdfplumber.open(self.local_pdf_path) as pdf:
            for page in pdf.pages:
                text = page.extract_text()
                if text:
                    full_text.append(text)
        
        # Cleanup
        if os.path.exists(self.local_pdf_path):
            os.remove(self.local_pdf_path)
            
        return "\n\n".join(full_text)

    def get_metadata(self) -> Dict[str, Any]:
        return {
            "source": self.url,
            "publisher": self.source_name,
            "format": "PDF"
        }
