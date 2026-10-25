# 17_PROJECT_STRUCTURE.md

# ⚖️ SattamAI Project Structure

**Version:** 1.0

**Project:** SattamAI – AI-Powered Legal Assistant for India

---

# Purpose

This document defines the complete folder structure of the SattamAI project.

The architecture is designed to be modular, scalable, and maintainable. Each component is isolated so that developers can work independently on the mobile app, backend, AI services, RAG pipeline, datasets, and deployment infrastructure.

---

# High-Level Architecture

```text
SattamAI
│
├── mobile/                  # Flutter Application
├── backend/                 # Python API Server
├── ai/                      # AI Orchestrator & Agents
├── rag/                     # Retrieval-Augmented Generation
├── vector-db/               # Vector Database
├── datasets/                # Legal Dataset
├── training/                # Model Training
├── admin-panel/             # Admin Dashboard
├── docs/                    # Documentation
├── deployment/              # Cloud Deployment
├── docker/                  # Docker Files
├── scripts/                 # Utility Scripts
├── monitoring/              # Monitoring & Logging
├── tests/                   # Testing
├── shared/                  # Shared Configurations
└── README.md
```

---

# Mobile Application

```text
mobile/
│
├── android/
├── ios/
├── assets/
│   ├── images/
│   ├── icons/
│   ├── fonts/
│   ├── animations/
│   └── translations/
│
├── lib/
│   ├── app/
│   ├── core/
│   ├── config/
│   ├── models/
│   ├── services/
│   ├── repositories/
│   ├── providers/
│   ├── screens/
│   ├── widgets/
│   ├── navigation/
│   ├── utils/
│   └── main.dart
│
├── test/
└── pubspec.yaml
```

---

# Backend

```text
backend/
│
├── src/
│   ├── api/
│   ├── controllers/
│   ├── middleware/
│   ├── routes/
│   ├── services/
│   ├── models/
│   ├── repositories/
│   ├── ai/
│   ├── rag/
│   ├── auth/
│   ├── storage/
│   ├── notifications/
│   ├── websocket/
│   ├── config/
│   └── app.js
│
├── tests/
├── package.json
└── Dockerfile
```

---

# AI Module

```text
ai/
│
├── orchestrator/
├── agents/
│   ├── intent/
│   ├── legal/
│   ├── retrieval/
│   ├── documents/
│   ├── translation/
│   ├── citation/
│   ├── validation/
│   └── department/
│
├── prompts/
├── workflows/
├── memory/
├── evaluation/
└── config/
```

---

# RAG Module

```text
rag/
│
├── ingestion/
├── preprocessing/
├── chunking/
├── embeddings/
├── retrieval/
├── reranking/
├── context_builder/
├── indexing/
├── evaluation/
└── config/
```

---

# Vector Database

```text
vector-db/
│
├── collections/
├── indexes/
├── backup/
├── snapshots/
└── scripts/
```

---

# Dataset Structure

```text
datasets/
│
├── constitution/
├── criminal/
├── civil/
├── traffic/
├── cyber/
├── labour/
├── consumer/
├── family/
├── property/
├── banking/
├── police/
├── courts/
├── government/
├── notifications/
├── templates/
├── faq/
├── tamil/
└── metadata/
```

---

# Training

```text
training/
│
├── preprocessing/
├── datasets/
├── adapters/
├── evaluation/
├── checkpoints/
├── experiments/
├── inference/
├── exports/
└── configs/
```

---

# Admin Panel

```text
admin-panel/
│
├── dashboard/
├── user-management/
├── lawyer-management/
├── dataset-management/
├── notification-center/
├── analytics/
├── ai-monitor/
└── settings/
```

---

# Documentation

```text
docs/
│
├── architecture/
├── api/
├── ai/
├── datasets/
├── deployment/
├── security/
├── ui/
├── roadmap/
└── research/
```

---

# Deployment

```text
deployment/
│
├── development/
├── staging/
├── production/
├── kubernetes/
├── terraform/
└── scripts/
```

---

# Docker

```text
docker/
│
├── backend/
├── mongodb/
├── qdrant/
├── redis/
├── monitoring/
└── docker-compose.yml
```

---

# Monitoring

```text
monitoring/
│
├── grafana/
├── prometheus/
├── dashboards/
├── logs/
└── alerts/
```

---

# Testing

```text
tests/
│
├── unit/
├── integration/
├── api/
├── ai/
├── rag/
├── ui/
├── performance/
└── security/
```

---

# Shared Resources

```text
shared/
│
├── constants/
├── types/
├── schemas/
├── configs/
└── utilities/
```

---

# Development Workflow

```text
Developer
      │
      ▼
Git Repository
      │
      ▼
CI/CD Pipeline
      │
      ▼
Automated Testing
      │
      ▼
Docker Build
      │
      ▼
Staging
      │
      ▼
Production
```

---

# Coding Standards

All modules should follow:

- Modular architecture.
- Clear naming conventions.
- Comprehensive documentation.
- Unit and integration testing.
- Secure coding practices.
- Consistent error handling.
- API versioning.
- Environment-based configuration.

---

# Future Expansion

The project structure is designed to support future additions such as:

- Web application.
- Desktop application.
- AI-powered legal research tools.
- Government API integrations.
- Court case management.
- Offline AI capabilities.
- Additional Indian languages.

---

# Conclusion

The SattamAI project structure provides a scalable and organized foundation for development. By separating the mobile app, backend, AI services, RAG pipeline, datasets, training, deployment, and administration into dedicated modules, the project can grow efficiently while remaining maintainable for long-term development.
