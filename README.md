# SattamAI (சட்டம்AI)

<p align="center">
  <img src="sattam_app/assets/images/app_icon.jpeg" alt="SattamAI Logo" width="128" style="border-radius: 28px;" />
</p>

<p align="center">
  <strong>AI-Powered Indian Legal Assistant, Case Tracker & Evidence Locker</strong>
</p>

<p align="center">
  <a href="#overview">Overview</a> •
  <a href="#key-features">Key Features</a> •
  <a href="#technology-stack">Tech Stack</a> •
  <a href="#project-structure">Project Structure</a> •
  <a href="#getting-started">Getting Started</a> •
  <a href="#testing--validation">Testing</a> •
  <a href="#build--releases">Build & Releases</a> •
  <a href="#license">License</a>
</p>

---

## Overview

**SattamAI** is a cross-platform legal intelligence application designed to make Indian Law accessible, understandable, and actionable in simple language. Built with Flutter and backed by a Python FastAPI RAG (Retrieval-Augmented Generation) backend powered by NVIDIA NIM microservices, SattamAI empowers citizens to understand their legal rights, draft standard legal notices, securely preserve evidence, track court cases, and connect with verified legal professionals.

---

## Key Features

### 1. AI Legal Consultation & Chat
- Conversational legal guidance addressing everyday Indian legal questions (IPC/BNS, CrPC/BNSS, cyber offenses, family disputes, consumer rights).
- Real-time streaming responses with formatted legal citations and recommended next steps.
- Quick topic prompts for immediate situational guidance.

### 2. Comprehensive Indian Laws Directory
- Searchable offline database (`laws_database.json`) indexing key acts and sections:
  - **Criminal Law:** Bharatiya Nyaya Sanhita (BNS) & Indian Penal Code (IPC)
  - **Procedural Law:** Bharatiya Nagarik Suraksha Sanhita (BNSS) & CrPC
  - **Evidence Law:** Bharatiya Sakshya Adhiniyam (BSA)
  - **Constitutional & Civil Law:** Constitution of India, Family Law, Cyber Law, Motor Vehicles Act, Consumer Protection Act.
- Section-by-section breakdown with plain-language summaries and practical implications.

### 3. Biometric Evidence Locker
- Secure, encrypted vault for preserving incident evidence (audio recordings, photographs, documents).
- Biometric authentication (PIN/device biometrics) protecting sensitive media.
- Cloud backup and synchronization via Supabase Storage.
- In-app file viewing and external export capabilities.

### 4. Legal Document Generator
- Automated generation of standard Indian legal documents:
  - RTI (Right to Information) applications
  - Legal notices
  - Formal complaint letters
- Built-in PDF rendering and native printing preview using Flutter `pdf` and `printing` engines.

### 5. Case Tracker & Timeline Management
- Log personal court cases, next hearing dates, filing numbers, and status updates.
- Real-time notification system for hearing reminders and status milestones.

### 6. Verified Lawyer Directory
- Directory of verified legal practitioners categorized by domain (Criminal, Civil, Family, Corporate).
- Lawyer credential verification submission workflow with Bar Council ID validation.
- Direct consultation booking workflow.

### 7. Multi-Lingual Localization (i18n)
- Native language support across 6 languages:
  - Tamil (தமிழ்)
  - English
  - Hindi (हिन्दी)
  - Bengali (বাংলা)
  - Telugu (తెలుగు)
  - Marathi (मराठी)

---

## Technology Stack

### Mobile & Desktop Client (`sattam_app`)
- **Framework:** Flutter 3.47+ / Dart SDK ^3.10.7
- **Target Platforms:** Android, iOS, Windows, macOS, Linux, Web
- **State Management & Architecture:** Layered Service & Controller pattern
- **Backend & Cloud:** Supabase Flutter SDK (Auth, PostgreSQL DB, Storage, Realtime)
- **Authentication:** Supabase Auth & Google Sign-In
- **Styling:** Custom dark-first Apple-inspired glassmorphism theme (`AppTheme`)
- **Hardware Integration:** Audio recording (`record`), Camera (`camera`), Document Picking (`file_picker`, `image_picker`), File Launching (`url_launcher`, `open_filex`)

### AI Backend & RAG Pipeline (`scripts/ai_backend`)
- **Framework:** Python 3.12+, FastAPI, Uvicorn
- **LLM Engine:** NVIDIA NIM Microservices (`meta/llama-3.1-70b-instruct`)
- **Embeddings:** NVIDIA NeMo Embeddings (`nvidia/nv-embedqa-e5-v5`)
- **Vector Database:** ChromaDB vector indexer

### Data Collection & Ingestion (`scripts/data_collection`)
- Scrapers and bulk downloaders for official legislative corpora (India Code, BNS/BNSS legislative drafts).

---

## Project Structure

```text
Sattam-AI/
├── sattam_app/                 # Flutter cross-platform client
│   ├── assets/                 # Embedded legal database & branding images
│   ├── lib/
│   │   ├── l10n/               # Multi-lingual ARB translation files
│   │   ├── models/             # Law, Case, and Notification data models
│   │   ├── screens/            # UI screens (Chat, Home, Cases, Evidence, Lawyers)
│   │   ├── services/           # Supabase, Evidence, PDF, Law, and Notification services
│   │   └── theme/              # Typography, color system, and glass surfaces
│   ├── test/                   # Automated widget and unit tests
│   ├── tool/                   # Utility scripts for data preparation and seeding
│   ├── supabase/               # Database SQL schema migrations and policies
│   └── pubspec.yaml            # Flutter project manifest & dependencies
├── scripts/
│   ├── ai_backend/             # FastAPI backend with NVIDIA NIM RAG pipeline
│   │   ├── api.py              # REST & streaming chat endpoints
│   │   ├── vector_indexer.py   # ChromaDB vector indexing script
│   │   └── requirements.txt    # Python dependencies
│   └── data_collection/        # Legal corpus scrapers and text cleaners
├── docs/                       # Technical architecture, vision, and system specs
├── LICENSE                     # MIT License
└── README.md                   # Repository documentation
```

---

## Getting Started

### Prerequisites

1. **Flutter SDK:** Version 3.47.0 or higher ([Install Flutter](https://flutter.dev/docs/get-started/install)).
2. **Python:** Version 3.10 or higher.
3. **Supabase Account:** Configured project with Auth, Storage bucket (`evidence`), and Database tables.
4. **NVIDIA NIM API Key:** For legal RAG query responses ([NVIDIA Build](https://build.nvidia.com)).

### Client Setup (`sattam_app`)

1. Navigate to the app directory:
   ```bash
   cd sattam_app
   ```

2. Fetch Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run static analysis:
   ```bash
   flutter analyze
   ```

4. Launch the application (select your preferred device or emulator):
   ```bash
   # Windows Desktop
   flutter run -d windows

   # Android Device / Emulator
   flutter run -d android

   # Chrome Web
   flutter run -d chrome
   ```

### AI Backend Setup (`scripts/ai_backend`)

1. Navigate to the backend directory:
   ```bash
   cd scripts/ai_backend
   ```

2. Create and activate a Python virtual environment:
   ```bash
   python -m venv venv
   # On Windows:
   .\venv\Scripts\activate
   # On macOS/Linux:
   source venv/bin/activate
   ```

3. Install required packages:
   ```bash
   pip install -r requirements.txt
   ```

4. Configure environment variables by copying `.env.example`:
   ```bash
   cp .env.example .env
   ```
   Add your NVIDIA API key in `.env`:
   ```env
   NVIDIA_API_KEY=your_nvidia_api_key_here
   ```

5. Start the FastAPI server:
   ```bash
   uvicorn api:app --reload --host 0.0.0.0 --port 8000
   ```

---

## Testing & Validation

### Flutter Client Tests

Run automated test suite:
```bash
cd sattam_app
flutter test
```

Run static analysis check:
```bash
cd sattam_app
flutter analyze
```

---

## Build & Releases

To build production release binaries:

### Android APK (Release)
```bash
cd sattam_app
flutter build apk --release
```
The output APK is generated at:
`sattam_app/build/app/outputs/flutter-apk/app-release.apk`

### Windows Desktop (Release)
```bash
cd sattam_app
flutter build windows --release
```
The output executable is generated at:
`sattam_app/build/windows/x64/runner/Release/`

---

## Legal Disclaimer

*SattamAI is designed to provide educational legal information, procedural guidance, and organizational tools for citizens. It does not provide licensed legal representation and is not a substitute for formal legal counsel from an authorized advocate. For complex litigation, always consult a qualified legal professional.*

---

## License

This project is licensed under the [MIT License](LICENSE).
Copyright (c) 2026 Mohamed Nifras S S.
