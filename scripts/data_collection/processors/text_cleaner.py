import re

def clean_extracted_text(raw_text: str) -> str:
    """
    Cleans OCR'd or extracted PDF text.
    Removes excessive whitespace, fixes broken lines, etc.
    """
    # Remove multiple spaces
    text = re.sub(r' +', ' ', raw_text)
    
    # Fix broken lines (simple heuristic: if line doesn't end with punctuation, join with next)
    # This is a basic version. For legal texts, this requires careful tuning.
    lines = text.split('\n')
    cleaned_lines = []
    
    for line in lines:
        line = line.strip()
        if not line:
            cleaned_lines.append("")
            continue
            
        cleaned_lines.append(line)
        
    return "\n".join(cleaned_lines)

def convert_to_markdown(cleaned_text: str) -> str:
    """
    A very basic heuristic to convert cleaned text into markdown headers.
    E.g., looks for "CHAPTER X" or "Section 1." and adds markdown headers.
    """
    lines = cleaned_text.split('\n')
    md_lines = []
    for line in lines:
        if re.match(r'^CHAPTER\s+[A-ZIVX]+', line, re.IGNORECASE):
            md_lines.append(f"## {line}")
        elif re.match(r'^PART\s+[A-ZIVX]+', line, re.IGNORECASE):
            md_lines.append(f"# {line}")
        else:
            md_lines.append(line)
            
    return "\n".join(md_lines)
