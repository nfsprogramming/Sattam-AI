import requests
import json
import ast
import os

def download_and_format_bns():
    print("Downloading BNS 2023 data from HuggingFace...")
    base_url = "https://datasets-server.huggingface.co/rows?dataset=nandhakumarg%2FIPC_and_BNS_transformation&config=default&split=train&offset={}&length=100"
    
    bns_data = {}
    
    offset = 0
    while True:
        url = base_url.format(offset)
        res = requests.get(url)
        if res.status_code != 200:
            break
        
        data = res.json()
        rows = data.get("rows", [])
        if not rows:
            break
            
        for row in rows:
            try:
                # The response field is a stringified dictionary
                response_str = row['row']['response']
                parsed_response = ast.literal_eval(response_str)
                
                bns_section = parsed_response.get('BNS Section', '')
                bns_heading = parsed_response.get('BNS Heading', '')
                bns_desc = parsed_response.get('BNS description', '')
                
                # Some IPC sections don't have BNS mappings or are blank
                if bns_section and str(bns_section).strip() and bns_section != 'None':
                    bns_data[str(bns_section)] = {
                        "heading": bns_heading,
                        "description": bns_desc
                    }
            except Exception as e:
                continue
                
        offset += 100
        if offset >= data.get("num_rows_total", 0):
            break

    print(f"Extracted {len(bns_data)} unique sections for BNS 2023.")
    
    # Sort and format to markdown
    md_content = "# The Bharatiya Nyaya Sanhita, 2023\n\n"
    
    # Sort sections numerically if possible
    def parse_sec(sec_str):
        import re
        m = re.match(r'(\d+)', sec_str)
        return int(m.group(1)) if m else 9999
        
    sorted_sections = sorted(bns_data.items(), key=lambda x: parse_sec(x[0]))
    
    for sec_num, details in sorted_sections:
        heading = details['heading'].replace('\n', ' ')
        desc = details['description'].replace('\\n', '\n')
        
        md_content += f"## Section {sec_num}: {heading}\n\n"
        md_content += f"{desc}\n\n---\n\n"
        
    # Save to file
    output_path = os.path.join("..", "..", "datasets", "criminal", "BNS_2023.md")
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(md_content)
        
    print(f"Saved complete BNS 2023 to {output_path}")

if __name__ == "__main__":
    download_and_format_bns()
