from dataclasses import dataclass, field, asdict
from typing import List, Optional
import json

@dataclass
class DocumentMetadata:
    title: str
    category: str
    source: str
    jurisdiction: str = "India"
    language: str = "English"
    publication_date: Optional[str] = None
    effective_date: Optional[str] = None
    version: str = "1.0"
    keywords: List[str] = field(default_factory=list)

def save_metadata(metadata: DocumentMetadata, output_path: str):
    """
    Saves the dataclass metadata object to a JSON file.
    """
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(asdict(metadata), f, indent=4)
    print(f"Metadata saved to {output_path}")
