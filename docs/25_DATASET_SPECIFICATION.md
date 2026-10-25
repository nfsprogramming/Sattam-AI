# 25_DATASET_SPECIFICATION.md

# ⚖️ SattamAI Dataset Specification

**Version:** 1.0

**Project:** SattamAI – AI-Powered Legal Assistant for India

---

# Overview

The quality of the SattamAI Legal AI Model depends on the quality of its datasets. This document defines the structure, organization, validation rules, metadata standards, and versioning strategy for all datasets used in the project.

The datasets support two primary purposes:

- **Fine-Tuning Dataset** – Used to adapt the language model to the legal domain.
- **RAG Knowledge Base** – Used to retrieve current legal information during inference.

---

# Dataset Categories

The project contains the following dataset groups:

```text
datasets/
│
├── fine_tuning/
├── rag/
├── templates/
├── multilingual/
├── evaluation/
├── metadata/
├── processed/
├── raw/
└── archive/
```

---

# Fine-Tuning Dataset

Purpose:

Train the AI model to:

- Understand legal questions.
- Explain laws.
- Recommend departments.
- Generate legal documents.
- Respond conversationally.

Recommended format:

```text
JSONL (One JSON object per line)
```

---

# Instruction Dataset Schema

Each record should contain:

```json
{
  "id": "FT000001",
  "instruction": "Explain the user's legal rights.",
  "input": "A traffic police officer stopped me for not carrying my driving licence.",
  "context": "",
  "output": "Structured explanation...",
  "language": "English",
  "legal_domain": "Traffic Law",
  "difficulty": "Basic",
  "version": "1.0"
}
```

---

# RAG Knowledge Dataset

Purpose:

Store authoritative legal information for semantic retrieval.

Each document should include:

- Title
- Act
- Chapter
- Section
- Rule
- Content
- Keywords
- Metadata

Example:

```json
{
  "document_id": "LAW001",
  "title": "Motor Vehicles Act",
  "section": "Section 130",
  "language": "English",
  "content": "...",
  "keywords": [
    "Driving Licence",
    "Traffic Police"
  ]
}
```

---

# Metadata Standards

Every dataset entry should include metadata where applicable:

| Field | Description |
|--------|-------------|
| id | Unique identifier |
| source | Official source |
| language | Tamil / English |
| legal_domain | Legal category |
| state | Applicable jurisdiction |
| version | Dataset version |
| last_updated | Update timestamp |
| reviewer | Reviewer identifier |
| status | Draft / Approved / Archived |

---

# Legal Domains

Recommended categories:

- Constitution
- Criminal Law
- Civil Law
- Traffic Law
- Cyber Law
- Consumer Law
- Labour Law
- Family Law
- Property Law
- Banking Law
- Taxation
- Environmental Law
- Government Procedures

Additional domains can be added over time.

---

# Multilingual Dataset

Supported languages:

- Tamil
- English

Recommended structure:

```text
multilingual/
│
├── tamil/
├── english/
└── parallel/
```

Parallel datasets should align equivalent legal content across supported languages.

---

# Legal Document Templates

Templates may include:

- Complaint Letter
- Legal Notice
- Affidavit Draft
- Representation Letter
- Application
- RTI Application
- Consumer Complaint

Each template should have:

- Template ID
- Language
- Category
- Version
- Editable placeholders

---

# Evaluation Dataset

Purpose:

Measure model quality.

Suggested categories:

- Legal reasoning
- Department recommendation
- Document generation
- Retrieval quality
- Translation quality
- Multilingual understanding

Evaluation datasets should remain separate from training datasets.

---

# Raw Dataset

Stores original collected documents before processing.

```text
raw/
│
├── pdf/
├── html/
├── docx/
├── txt/
└── scanned/
```

Original files should be preserved for traceability.

---

# Processed Dataset

Contains cleaned and normalized data ready for:

- Chunking
- Embedding generation
- Fine-tuning
- Evaluation

---

# Archive

Stores older dataset versions.

Example:

```text
archive/
│
├── v1.0/
├── v1.1/
└── v2.0/
```

Archived datasets should remain immutable.

---

# Data Validation Rules

Every dataset should be checked for:

- Duplicate records.
- Missing required fields.
- Invalid metadata.
- Encoding issues.
- Broken formatting.
- Empty responses.
- Language consistency.

Validation should be automated where possible.

---

# Dataset Versioning

Suggested format:

```text
Dataset v1.0
Dataset v1.1
Dataset v2.0
```

Each release should include:

- Version number.
- Release date.
- Summary of changes.
- Data source updates.
- Quality report.

---

# Data Quality Metrics

Track metrics such as:

- Completeness.
- Accuracy.
- Consistency.
- Coverage.
- Duplicate rate.
- Validation success rate.

These metrics help maintain long-term dataset quality.

---

# Dataset Pipeline

```text
Official Sources
        │
        ▼
Collection
        │
        ▼
Cleaning
        │
        ▼
Validation
        │
        ▼
Metadata Generation
        │
        ▼
Processing
        │
        ▼
Storage
        │
        ▼
Fine-Tuning / RAG
```

---

# Security

Dataset management should include:

- Access control.
- Backup procedures.
- Version tracking.
- Change logs.
- Secure storage.
- Integrity verification.

---

# Future Expansion

Future datasets may include:

- Court judgments (subject to licensing and legal considerations).
- State-specific procedures.
- Government circulars.
- Public legal awareness material.
- Frequently updated notifications.
- Additional Indian languages.

---

# Best Practices

- Prefer authoritative and official sources.
- Keep raw data unchanged.
- Automate validation.
- Maintain complete metadata.
- Record all dataset revisions.
- Review updates before production deployment.

---

# Conclusion

The SattamAI Dataset Specification establishes a structured framework for organizing, validating, and maintaining the legal datasets that power both fine-tuning and Retrieval-Augmented Generation. A well-managed dataset strategy ensures that the platform remains accurate, maintainable, and capable of evolving alongside changes in legal information and user needs.
