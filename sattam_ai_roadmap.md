# SattamAI: Flutter + Specialized Indian Law AI Roadmap

This roadmap outlines the journey to transform the `SattamAI` prototype into a production **Flutter** mobile application powered by a **custom-trained/specialized AI model for Indian Law**, hosted via **NVIDIA NIM**.

## Phase 1: AI Model Strategy & NVIDIA NIM Integration (Weeks 1-3)
Since a highly specialized, accurate AI for Indian Law does not currently exist, creating this is the core differentiator of the project.

*   **Data Collection & Legal Corpus**: Gather a comprehensive dataset of Indian Penal Code (IPC/BNS), CrPC, Constitution, High Court/Supreme Court judgments, and Tamil Nadu state laws.
*   **Model Specialization**:
    *   *Option A (RAG Strategy)*: Build a Retrieval-Augmented Generation (RAG) pipeline where an open-source model references your legal database before answering.
    *   *Option B (Fine-Tuning)*: Fine-tune a powerful open-source model (like Llama 3) specifically on Indian Legal texts to understand legal nuances and bilinguality (Tamil/English).
*   **NVIDIA NIM Deployment**: Package and deploy the specialized model using NVIDIA NIM (NVIDIA Inference Microservices) for ultra-low latency and scalable API access.
*   **API Security**: Set up a lightweight backend (Node.js/Python) to securely call the NVIDIA NIM endpoints, ensuring your NIM API keys are never exposed in the mobile app.

## Phase 2: Flutter App Foundation (Weeks 3-5)
Translate the polished React prototype into a robust Flutter architecture.

*   **Initialize Flutter App**: Set up the project (`flutter create sattam_ai`) with a scalable architecture (e.g., Riverpod or BLoC).
*   **UI/UX Translation**: Recreate the custom dark-mode aesthetic, gradients, and micro-animations. Build modular widgets for the Home, Chat, SOS, and Tracker screens.
*   **Connect to AI Backend**: Wire the Flutter chat interface to the secure backend endpoint that communicates with your NVIDIA NIM model.

## Phase 3: Backend & Database Integration (Weeks 5-6)
*   **Firebase Integration**: 
    *   **Auth**: Secure Citizen and Lawyer logins.
    *   **Firestore**: Store user profiles, chat histories (`savedChats`), and case tracking data.
*   **Lawyer Verification Flow**: Implement a system for lawyers to submit their Bar Council IDs for verification.

## Phase 4: Native Device Features & Core Tools (Weeks 7-8)
*   **Document Generation**: Use the Flutter `pdf` package to generate formatted RTI applications and Legal Notices locally on the device.
*   **Compensation Logic**: Implement the compensation calculation logic in Dart services.

## Phase 5: Localization, Polish & Launch (Weeks 9-10)
*   **Localization (i18n)**: Fully implement Tamil and English using `flutter_localizations`, moving away from hardcoded strings.
*   **Testing**: Rigorous testing of the AI model to ensure it does not hallucinate false legal advice (crucial for Legal Tech).
*   **Deployment**: App Store and Google Play Store deployment.

---

> [!TIP]
> **Next Immediate Step:** We have two main avenues to start on. We can either:
> 1. Start building the **Flutter UI framework** based on the prototype.
> 2. Start laying out the **AI Strategy (Python/NIM)** to build and serve the specialized Indian Law model.
> Which would you like to tackle first?
