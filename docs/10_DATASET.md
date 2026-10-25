# 10_DATASET.md

# ⚖️ SattamAI Dataset Documentation

**Version:** 1.0

**Project:** SattamAI – AI-Powered Legal Assistant for India

---

# Purpose

The SattamAI dataset forms the legal knowledge foundation of the AI system.

Unlike general-purpose language models, SattamAI focuses exclusively on Indian legal information, government procedures, and official legal resources.

The objectives of the dataset are to:

- Build a comprehensive legal knowledge base.
- Support Retrieval-Augmented Generation (RAG).
- Improve legal reasoning through domain adaptation.
- Enable multilingual legal guidance.
- Keep legal information organized and maintainable.

---

# Dataset Design Principles

The dataset should be:

- Based on official or otherwise reliable legal sources.
- Well structured and version-controlled.
- Categorized by legal domain.
- Continuously updated.
- Searchable and retrievable.
- Prepared for multilingual support.
- Reviewed for consistency and quality.

---

# Dataset Categories

## 1. Constitution

Contents:

- Constitution of India
- Constitutional Amendments
- Fundamental Rights
- Fundamental Duties
- Directive Principles of State Policy
- Schedules

---

## 2. Criminal Laws

Examples include:

- Bharatiya Nyaya Sanhita (BNS)
- Bharatiya Nagarik Suraksha Sanhita (BNSS)
- Bharatiya Sakshya Adhiniyam (BSA)

Coverage:

- Definitions
- Offences
- Punishments
- Procedures

---

## 3. Civil Laws

Examples may include:

- Contract-related legislation
- Property-related legislation
- Specific Relief legislation
- Easement-related legislation

Coverage:

- Civil rights
- Contracts
- Property
- Compensation
- Civil procedures

---

## 4. Motor Vehicle Laws

Coverage:

- Driving licences
- Registration Certificates (RC)
- Insurance requirements
- Permits
- Traffic rules
- Penalties
- Road safety

---

## 5. Cyber Laws

Coverage:

- Information Technology legislation
- Cybercrime procedures
- Online fraud reporting
- Electronic records
- Privacy-related provisions

---

## 6. Consumer Laws

Coverage:

- Consumer rights
- Product liability
- Defective goods
- Deficient services
- Complaint procedures
- Consumer dispute mechanisms

---

## 7. Labour Laws

Coverage:

- Employee rights
- Wages
- Working conditions
- Leave
- Workplace safety
- Industrial relations
- Social security provisions

---

## 8. Family Laws

Coverage:

- Marriage
- Divorce
- Maintenance
- Child custody
- Adoption
- Guardianship
- Succession (where applicable)

---

## 9. Property Laws

Coverage:

- Property registration
- Land ownership
- Sale agreements
- Lease
- Tenancy
- Encumbrance
- Revenue procedures

---

## 10. Banking and Financial Matters

Coverage:

- Banking complaints
- Digital payment disputes
- Loan-related procedures
- Financial fraud reporting
- Ombudsman information

---

## 11. Government Procedures

Examples:

- Passport
- Aadhaar-related procedures (where applicable)
- Driving licence services
- Vehicle registration
- Certificates
- Public grievance procedures

---

## 12. Police Procedures

Coverage:

- FIR
- Community Service Register (CSR), where applicable
- Complaint procedures
- Investigation overview
- Victim rights
- Cyber complaint process

---

## 13. Court Procedures

Coverage:

- Court hierarchy
- Filing process
- General procedural flow
- Appeals overview
- Basic terminology

---

## 14. Government Notifications

Include maintained collections of:

- Notifications
- Circulars
- Government Orders
- Gazette publications

These resources should be versioned and updated as they change.

---

## 15. Legal Templates

Examples:

- Complaint letters
- Applications
- Representation letters
- Legal notice templates
- Affidavit templates (where appropriate)

Templates should be clearly identified as drafts for user review.

---

## 16. Frequently Asked Questions

Examples:

- Traffic stop guidance
- Cyber fraud reporting
- Consumer complaint process
- Property registration
- Labour rights
- Family law basics

The FAQ dataset should reflect common user questions.

---

# Metadata

Each dataset entry should include metadata such as:

- Title
- Category
- Jurisdiction
- Language
- Source
- Publication date
- Effective date (if applicable)
- Version
- Last updated
- Keywords

This metadata improves retrieval quality and maintainability.

---

# Dataset Folder Structure

```text
datasets/
│
├── constitution/
├── criminal/
├── civil/
├── motor_vehicle/
├── cyber/
├── consumer/
├── labour/
├── family/
├── property/
├── banking/
├── government/
├── police/
├── courts/
├── notifications/
├── templates/
├── faq/
├── tamil/
└── metadata/
```

---

# Data Quality Standards

Every dataset should be:

- Accurate.
- Complete.
- Consistent.
- Properly categorized.
- Version controlled.
- Reviewed before release.
- Traceable to its source.

---

# Dataset Updates

The legal knowledge base should support periodic updates to reflect:

- New legislation.
- Amendments.
- Government notifications.
- Department procedures.
- Revised templates.
- Corrections and improvements.

Updates should be documented with version numbers and change logs.

---

# Role in the AI System

The dataset supports multiple components of SattamAI, including:

- Retrieval-Augmented Generation (RAG).
- Legal search.
- AI explanations.
- Document generation.
- Legal classification.
- Procedural guidance.
- Multilingual legal assistance.

---

# Future Expansion

Future dataset additions may include:

- Additional state-specific procedures.
- More multilingual legal resources.
- Expanded document templates.
- Curated educational legal content.
- Enhanced metadata for retrieval.

---

# Conclusion

The SattamAI dataset is the central knowledge resource that powers the platform. By organizing legal information into structured, maintainable, and version-controlled datasets, the project can provide clearer legal guidance, improve retrieval quality, and evolve efficiently as laws and government procedures change.
