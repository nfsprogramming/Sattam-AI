# 05_SYSTEM_ARCHITECTURE.md

# ⚖️ SattamAI System Architecture

## Introduction

SattamAI is designed as a modular, scalable, and AI-first legal assistance platform. The architecture separates the user interface, backend services, AI engine, legal knowledge base, and supporting services to ensure maintainability, security, and future expansion.

The platform is designed to support mobile applications, AI-powered legal analysis, legal document generation, multilingual interaction, and integration with government and legal service providers.

---

# Architecture Overview

```text
                         +----------------------+
                         |   Flutter Mobile App |
                         +----------+-----------+
                                    |
                             HTTPS / REST API
                                    |
                         +----------v-----------+
                         | FastAPI Backend|
                         +----------+-----------+
                                    |
             +----------------------+----------------------+
             |                      |                      |
             |                      |                      |
    +--------v-------+     +--------v-------+     +--------v-------+
    | Authentication |     | Business Logic |     | Notification   |
    | Supabase Auth  |     | Case Handling  |     | Service         |
    +--------+-------+     +--------+-------+     +--------+-------+
             |                      |                      |
             +----------------------+----------------------+
                                    |
                         +----------v-----------+
                         | AI Orchestrator      |
                         +----------+-----------+
                                    |
      +-------------+---------------+----------------+--------------+
      |             |               |                |              |
+-----v----+  +-----v-----+  +------v------+  +------v------+ +-----v------+
|  Model   |  |           |  |             |  | STT / TTS   | |             |
+-----+----+  +-----+-----+  +------+------|  +------+------| +------+------+
      |             |               |                |               |
      +-------------+---------------+----------------+---------------+
                                    |
                         +----------v-----------+
                         | Legal Knowledge Base |
                         +----------+-----------+
                                    |
      +-------------+---------------+------------------------------+
      |             |               |              |               |
+-----v----+ +------v------+ +------v------+ +-----v------+ +------v------+
| Acts     | | Rules       | | Procedures  | | Templates  | | Case Samples|
+----------+ +-------------+ +-------------+ +------------+ +-------------+

                                    |
                         +----------v-----------+
                         | Supabase (PostgreSQL + Storage)    |
                         +----------------------+
```

---

# Major Components

## 1. Mobile Application

Technology:

- Flutter

Responsibilities:

- User Interface
- Authentication
- AI Chat
- Voice Input
- Image Upload
- Case Management
- Document Viewer
- Lawyer Search
- Notifications

---

## 2. Backend API

Technology:

- Python
- FastAPI

Responsibilities:

- API Gateway
- Authentication Validation
- Business Logic
- AI Request Routing
- Case Management
- User Management
- Document Management
- Lawyer Directory Integration

---

## 3. AI Orchestrator

The AI Orchestrator coordinates all AI-related services.

Responsibilities:

- Prompt construction
- Context management
- Retrieval requests
- Model inference
- Response validation
- Structured output formatting

---

## 4. Legal AI Model

A specialized AI model adapted for Indian legal guidance.

Primary capabilities include:

- Legal reasoning
- Legal classification
- Rights explanation
- Procedure guidance
- Document generation
- Bilingual responses

The model should remain focused on legal assistance.

---

## 5. Retrieval-Augmented Generation (RAG)

The RAG component retrieves relevant legal information before the AI generates a response.

Knowledge sources may include:

- Constitution
- Central Acts
- State Acts
- Rules
- Notifications
- Circulars
- Government procedures
- Approved document templates

This helps keep responses grounded in current legal information.

---


Purpose:

Extract text from uploaded:

- FIRs
- Notices
- Agreements
- Court documents
- Government letters

The extracted content is then analyzed by the AI.

---

## 7. Speech Services

Components:

Speech-to-Text

- Converts voice into text.

Text-to-Speech

- Reads AI responses aloud.

---

## 8. Translation Layer

Supports multilingual interaction.

Initial languages:

- Tamil
- English

Future versions may support additional Indian languages.

---

# Legal Knowledge Base

The legal knowledge base contains structured legal resources.

Example structure:

```text
Knowledge Base

Constitution

Central Acts

State Acts

Rules

Government Orders

Notifications

Circulars

Department Procedures

Court Procedures

Legal Templates

Frequently Asked Questions
```

The knowledge base should be versioned and updated as legal materials change.

---

# Database Layer

Primary Database:

PostgreSQL (via Supabase)

Collections:

Users

Cases

Documents

Lawyers

Notifications

Saved Chats

Application Logs

---

# Cloud Storage

Stores:

Uploaded images

Generated documents

PDF files

Voice recordings

Case attachments

---

# Authentication

Supabase Auth

Supported methods:

Email

Phone Number

Future expansion:

Government identity integrations where legally and technically appropriate.

---

# API Flow

User submits:

Text

Voice

Image

↓

Backend validates request

↓

AI Orchestrator prepares context

↓

RAG retrieves legal information

↓

Legal AI Model generates response

↓

Backend formats response

↓

Mobile application displays structured output

---

# AI Response Structure

Every AI response should aim to include:

Problem Summary

Applicable Legal Domain

Relevant Laws

Rights

Responsibilities

Required Documents

Government Department

Step-by-Step Guidance

Suggested Next Actions

Advisory Note

---

# Security Principles

The system should:

- Encrypt user data in transit and at rest.
- Protect uploaded legal documents.
- Restrict access to authenticated users.
- Record system logs responsibly.
- Follow applicable privacy and data protection requirements.

---

# Scalability

The architecture is designed to support:

- Additional AI models
- More legal domains
- More Indian languages
- New government services
- Increased user traffic
- Future web application support

---

# Future Expansion

Planned architecture extensions include:

- Specialized legal AI agents
- State-specific legal knowledge modules
- Offline legal resources
- Analytics dashboard
- Lawyer portal
- Government officer portal
- Administrative content management system
- Continuous legal knowledge updates

---

# Conclusion

The SattamAI architecture follows a modular and scalable design that separates the user interface, backend services, AI orchestration, and legal knowledge resources. This structure allows the platform to evolve over time while maintaining clear boundaries between components, supporting future enhancements without major architectural changes.
