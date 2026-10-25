from abc import ABC, abstractmethod
from typing import Dict, Any, Optional

class BaseCollector(ABC):
    """
    Abstract base class for all data collectors.
    Each specific source (API, PDF, HTML) should inherit from this class.
    """

    def __init__(self, source_name: str):
        self.source_name = source_name

    @abstractmethod
    def collect(self) -> str:
        """
        Executes the collection process and returns the raw text/content.
        """
        pass

    @abstractmethod
    def get_metadata(self) -> Dict[str, Any]:
        """
        Returns basic metadata about the collected document.
        """
        pass
