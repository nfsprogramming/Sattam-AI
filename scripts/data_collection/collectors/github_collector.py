import os
import requests
import json
from typing import Dict, Any
from .base_collector import BaseCollector

class GithubCollector(BaseCollector):
    """
    Downloads pre-parsed legal datasets (JSON) directly from Open-Source Github repositories.
    """

    def __init__(self, source_name: str, raw_url: str):
        super().__init__(source_name)
        self.raw_url = raw_url

    def collect(self) -> str:
        print(f"Downloading bulk JSON dataset from {self.raw_url}...")
        try:
            response = requests.get(self.raw_url, timeout=15)
            response.raise_for_status()
            
            # If the response is JSON, we'll format it nicely into Markdown for RAG
            try:
                data = response.json()
                # Simple heuristic to convert standard structured JSON into Markdown
                md_content = f"# {self.source_name}\n\n"
                
                if isinstance(data, dict):
                    for key, value in data.items():
                        md_content += f"## {key}\n{value}\n\n"
                elif isinstance(data, list):
                    for item in data:
                        if isinstance(item, dict):
                            for k, v in item.items():
                                md_content += f"**{k}**: {v}\n"
                            md_content += "\n---\n\n"
                        else:
                            md_content += f"{item}\n"
                
                return md_content
            except ValueError:
                # If it's not JSON, return as is
                return response.text
                
        except requests.exceptions.RequestException as e:
            print(f"Failed to download dataset: {e}")
            return f"Error downloading dataset: {e}"

    def get_metadata(self) -> Dict[str, Any]:
        return {
            "source": self.raw_url,
            "publisher": "Open Source Github Dataset",
            "format": "JSON/Markdown"
        }
