import os
import time
from openai import OpenAI
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_JUSTIFY, TA_CENTER
from dotenv import load_dotenv

load_dotenv()
API_KEY = os.getenv("NVIDIA_API_KEY")

nim_client = None
if API_KEY:
    nim_client = OpenAI(
        base_url="https://integrate.api.nvidia.com/v1",
        api_key=API_KEY
    )

def draft_appeal_text(name: str, address: str, against: str, description: str) -> str:
    if not nim_client:
        return "Error: NVIDIA API Key is not set."

    prompt = f"""
    You are an expert Indian lawyer. Write a formal legal appeal or complaint letter.
    User Name: {name}
    User Address: {address}
    Opposing Party: {against}
    Issue Description: {description}
    
    Instructions:
    - Write it as a formal letter ready to be printed and signed.
    - Use formal spacing and structure.
    - Include placeholder dates if necessary.
    - Use professional legal terminology suitable for Indian courts or authorities.
    - Output ONLY the letter text. Do not use Markdown formatting (like ** or #) because it will be parsed as plain text in the PDF.
    """
    
    try:
        response = nim_client.chat.completions.create(
            model="meta/llama-3.1-70b-instruct",
            messages=[{"role": "user", "content": prompt}],
            max_tokens=1500,
            temperature=0.3
        )
        return response.choices[0].message.content.strip()
    except Exception as e:
        print(f"Error calling LLM: {e}")
        return f"Error drafting the document: {e}"

def create_pdf(name: str, address: str, against: str, description: str, output_path: str):
    # 1. Draft the text using AI
    text = draft_appeal_text(name, address, against, description)
    
    # 2. Setup PDF Canvas
    doc = SimpleDocTemplate(output_path, pagesize=letter,
                            rightMargin=72, leftMargin=72,
                            topMargin=72, bottomMargin=72)
    
    styles = getSampleStyleSheet()
    styles.add(ParagraphStyle(name='Justify', alignment=TA_JUSTIFY, fontName='Times-Roman', fontSize=12, leading=18))
    styles.add(ParagraphStyle(name='TitleStyle', alignment=TA_CENTER, fontName='Times-Bold', fontSize=14, leading=20))
    
    Story = []
    
    # Title
    Story.append(Paragraph("<b>LEGAL REPRESENTATION / COMPLAINT</b>", styles['TitleStyle']))
    Story.append(Spacer(1, 24))
    
    # Parse the LLM output into ReportLab paragraphs
    for line in text.split('\n'):
        line = line.strip()
        if line:
            # Escape HTML characters that ReportLab might misinterpret
            line = line.replace('<', '&lt;').replace('>', '&gt;')
            Story.append(Paragraph(line, styles['Justify']))
            Story.append(Spacer(1, 12))
            
    doc.build(Story)
