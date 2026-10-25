# 18_SYSTEM_ARCHITECTURE.md

# ⚖️ SattamAI System Architecture

**Version:** 1.0

**Project:** SattamAI – AI-Powered Legal Assistant for India

---

# Overview

SattamAI is a full-stack, AI-powered legal assistant designed to help users understand Indian laws, identify the appropriate government departments, generate legal documents, and connect with legal professionals.

The system follows a modular, cloud-native architecture built around an AI Orchestrator, a Retrieval-Augmented Generation (RAG) pipeline, and a legal knowledge base. This design enables scalability, maintainability, and continuous updates to legal information.

---

# Architecture Goals

The architecture is designed to provide:

- High availability
- Scalability
- Security
- Modular services
- AI-powered legal reasoning
- Real-time retrieval of legal knowledge
- Multilingual support
- Cloud-native deployment

---

# High-Level System Architecture

```text id="0jv8am"
                     ┌─────────────────────┐
                     │  Flutter Mobile App │
                     └──────────┬──────────┘
                                │
                         HTTPS / WebSocket
                                │
                     ┌──────────▼──────────┐
                     │ API Gateway (Python)│
                     └──────────┬──────────┘
                                │
          ┌─────────────────────┼─────────────────────┐
          │                     │                     │
          ▼                     ▼                     ▼
   Authentication         AI Orchestrator      User Services
      (Supabase)                │              (Cases, Lawyers,
                                │               Documents)
                                ▼
                     ┌─────────────────────┐
                     │ Multi-Agent AI Layer│
                     └──────────┬──────────┘
                                │
          ┌─────────────────────┼─────────────────────┐
          ▼                     ▼                     ▼
      AI Models                │
                               ▼
                     ┌─────────────────────┐
                     │ Vector DB (Qdrant)  │
                     └──────────┬──────────┘
                                ▼
                     Legal Knowledge Base

Additional Services:
- PostgreSQL (via Supabase)
- Supabase Storage
- Google Maps
- FCM Notifications
- Admin Dashboard
```

---

# Core Components

## 1. Mobile Application

Framework:

- Flutter

Responsibilities:

- User authentication.
- Voice, text, and image input.
- AI chat interface.
- Document downloads.
- Case tracking.
- Lawyer search.
- Notifications.
- User profile management.

---

## 2. API Gateway

Technology:

- Python
- FastAPI

Responsibilities:

- Route incoming requests.
- Authenticate users.
- Validate requests.
- Communicate with AI services.
- Manage business logic.
- Return structured responses.

---

## 3. AI Orchestrator

The AI Orchestrator coordinates all AI-related tasks.

Responsibilities:

- Select appropriate AI agents.
- Manage conversation flow.
- Build prompts.
- Collect retrieved legal information.
- Assemble the final response.

---

## 4. Multi-Agent AI Layer

Specialized agents include:

- Intent Detection Agent
- Legal Classification Agent
- Retrieval Agent
- Legal Reasoning Agent
- Government Department Agent
- Required Documents Agent
- Document Generation Agent
- Translation Agent
- Citation Agent
- Validation Agent

This modular approach improves reliability and maintainability.

---

## 5. NVIDIA NIM Integration

NVIDIA NIM provides inference for the foundation language model.

Responsibilities:

- Natural language understanding.
- Legal explanation.
- Multilingual conversation.
- Draft generation.
- Structured response generation.

The AI Orchestrator interacts with NVIDIA NIM after enriching prompts with retrieved legal context.

---

## 6. RAG Pipeline

The Retrieval-Augmented Generation pipeline:

- Processes user queries.
- Generates embeddings.
- Searches the vector database.
- Retrieves relevant legal materials.
- Builds contextual information for the language model.

---

## 7. Vector Database

Technology:

- Qdrant

Stores:

- Legal document embeddings.
- Metadata.
- Semantic indexes.

Supports fast and accurate semantic search.

---

## 8. Legal Knowledge Base

Contains organized legal information, including:

- Constitution
- Criminal laws
- Civil laws
- Traffic laws
- Cyber laws
- Consumer laws
- Labour laws
- Government procedures
- Notifications
- Legal templates

The knowledge base is version-controlled and updated regularly.

---

## 9. Primary Database

Technology:

- PostgreSQL (via Supabase)

Stores:

- Users
- Cases
- Chat history
- Documents
- Lawyers
- Notifications
- Audit logs

---

## 10. Authentication

Technology:

- Supabase Auth

Supported methods:

- Email
- Phone number

Future support:

- Google Sign-In
- Apple Sign-In

---

## 11. File Storage

Technology:

- Supabase Storage

Stores:

- Uploaded images
- Voice recordings
- Generated PDFs
- Supporting documents

---



- Extract text from uploaded documents.

Speech-to-Text:

- Convert voice input into text.

Text-to-Speech:

- Read AI responses aloud.

---

## 13. Maps Integration

Technology:

- Google Maps Platform

Features:

- Nearby lawyers.
- Police stations.
- Courts.
- Government offices.
- Legal aid centres.

---

## 14. Notification Service

Technology:

- Supabase Realtime / FCM

Notification types:

- Case updates.
- Appointment reminders.
- Document reminders.
- System alerts.

---

## 15. Admin Dashboard

Functions:

- Manage legal datasets.
- Monitor AI performance.
- Review user feedback.
- Manage lawyers.
- Track analytics.
- Publish knowledge base updates.

---

# Request Lifecycle

```text id="1f3s9n"
User
 │
 ▼
Flutter App
 │
 ▼
API Gateway
 │
 ▼
Authentication
 │
 ▼
AI Orchestrator
 │
 ▼
Legal Retrieval (RAG)
 │
 ▼
Qdrant Vector Database
 │
 ▼
Relevant Legal Context
 │
 ▼
NVIDIA NIM AI Model
 │
 ▼
Response Validation
 │
 ▼
Structured Legal Response
 │
 ▼
Flutter Application
```

---

# Security Architecture

Security measures include:

- HTTPS encryption.
- Secure authentication.
- JWT-based API authorization.
- Input validation.
- File upload validation.
- Access control.
- Audit logging.
- Encrypted storage where appropriate.

---

# Scalability

The architecture supports:

- Horizontal backend scaling.
- Independent AI services.
- Distributed vector databases.
- Microservice expansion.
- Large legal datasets.
- Millions of users.

---

# Reliability

Reliability is improved through:

- Modular components.
- Service isolation.
- Logging and monitoring.
- Graceful error handling.
- Automated backups.
- Version-controlled legal knowledge.

---

# Future Enhancements

Planned architectural improvements include:

- Self-hosted legal AI model.
- Hybrid cloud deployment.
- Offline legal assistance.
- State-specific legal modules.
- Government API integrations.
- Desktop and web applications.
- Advanced legal analytics.

---

# Conclusion

The SattamAI System Architecture combines Flutter, Python, NVIDIA NIM, Retrieval-Augmented Generation, Qdrant, PostgreSQL (via Supabase), Supabase, and cloud-native services into a unified platform for AI-assisted legal guidance. Its modular design ensures that the system remains scalable, secure, maintainable, and adaptable as legal knowledge, AI capabilities, and user requirements continue to evolve.
