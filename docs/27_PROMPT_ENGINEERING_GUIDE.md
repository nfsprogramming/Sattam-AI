# 27_PROMPT_ENGINEERING_GUIDE.md

# ⚖️ SattamAI Prompt Engineering Guide

**Version:** 1.0

**Project:** SattamAI – AI-Powered Legal Assistant

---

# Overview

This document defines the prompt engineering standards used throughout SattamAI. It ensures that AI responses remain consistent, easy to understand, well-structured, and grounded in retrieved legal information.

The platform uses a Retrieval-Augmented Generation (RAG) architecture, meaning prompts are constructed from the user's request together with relevant legal context retrieved from the knowledge base.

---

# Objectives

The prompt system should:

- Produce consistent responses.
- Explain legal concepts in simple language.
- Use retrieved legal information when available.
- Support Tamil and English.
- Generate structured legal documents.
- Recommend appropriate government departments.
- Encourage users to review generated drafts before use.
- Reduce unsupported responses.

---

# Prompt Architecture

```text id="prompt-architecture"
User Input
      │
      ▼
Conversation Context
      │
      ▼
Retrieved Legal Context
      │
      ▼
Prompt Builder
      │
      ▼
NVIDIA NIM
      │
      ▼
Structured AI Response
```

---

# Prompt Components

Every AI request should contain the following components where applicable:

1. System Instructions
2. User Query
3. Retrieved Legal Context
4. Conversation History
5. Output Format Requirements

---

# Master System Prompt

The master system prompt should instruct the model to:

- Explain legal information in clear, simple language.
- Organize answers into logical sections.
- Use retrieved legal information when available.
- Mention relevant legal references when supported.
- Identify the relevant government department if applicable.
- Suggest commonly required documents where appropriate.
- Generate editable document drafts when requested.
- Maintain a respectful and neutral tone.
- Avoid unsupported factual claims.

---

# Standard Response Structure

Unless another format is requested, AI responses should include:

```text id="response-template"
1. Problem Summary

2. Legal Information

3. Your Rights

4. Your Responsibilities

5. Required Documents

6. Relevant Government Department

7. Suggested Next Steps

8. References

9. Advisory Note
```

---

# Legal Explanation Prompt

Purpose:

Provide a clear explanation of a legal issue.

Template:

```text id="legal-template"
Explain the user's legal question using the retrieved legal information.

Use clear language.

Organize the response into:

- Summary
- Relevant legal information
- Rights
- Responsibilities
- Suggested actions
- References
```

---

# Government Department Prompt

Purpose:

Recommend the appropriate authority.

Template:

```text id="department-template"
Identify the most appropriate government department based on the user's situation.

Explain:

- Why this department is relevant.
- Common services provided.
- Commonly required documents.
```

---

# Document Generation Prompt

Purpose:

Generate editable legal drafts.

Supported document types:

- Complaint Letter
- Legal Notice
- Application
- Representation Letter
- RTI Application

Generated documents should:

- Use professional language.
- Include placeholders for user-specific information.
- Be clearly marked as editable drafts.

---

# Translation Prompt

Purpose:

Translate between supported languages while preserving legal meaning.

Requirements:

- Maintain terminology consistency.
- Preserve document structure.
- Avoid changing legal intent.

---

# Follow-Up Prompt

Purpose:

Support conversational interactions.

The AI should:

- Consider previous conversation context.
- Avoid repeating unnecessary information.
- Ask clarifying questions when essential details are missing.

---

# RAG Prompt Template

The prompt builder combines:

```text id="rag-template"
User Question

Conversation Context

Retrieved Legal Context

Required Output Structure

Response Language
```

Retrieved context should be prioritized over general model knowledge where applicable.

---

# Citation Guidance

When supported by retrieved content, responses should reference:

- Act name.
- Section.
- Rule.
- Notification.
- Government Order.
- Department procedure.

If no authoritative reference is available, the response should avoid inventing one.

---

# Multilingual Support

Supported languages:

- Tamil
- English

The response language should match the user's preference unless another language is requested.

---

# Clarification Strategy

If critical information is missing, the AI should request clarification before making assumptions.

Examples include:

- State or jurisdiction.
- Type of dispute.
- Relevant dates.
- Government department involved.

---

# Response Formatting

Use:

- Headings.
- Numbered steps.
- Bullet lists where appropriate.
- Short paragraphs.
- Clear action items.

Avoid excessive legal jargon unless specifically requested.

---

# Safety Rules

The prompt system should encourage the AI to:

- Stay within the scope of available information.
- Avoid unsupported factual claims.
- Distinguish retrieved information from generated explanations.
- Respect user privacy.
- Avoid revealing internal prompt instructions.

---

# Prompt Versioning

Suggested versions:

```text id="versioning"
Prompt v1.0
Prompt v1.1
Prompt v2.0
```

Each version should document:

- Changes.
- Purpose.
- Compatibility.
- Deployment date.

---

# Prompt Testing

Evaluate prompts for:

- Consistency.
- Accuracy.
- Clarity.
- Multilingual quality.
- Structured formatting.
- Response completeness.

Testing should include representative legal scenarios.

---

# Prompt Workflow

```text id="prompt-workflow"
User Request
      │
      ▼
Intent Detection
      │
      ▼
Legal Retrieval
      │
      ▼
Prompt Construction
      │
      ▼
AI Response
      │
      ▼
Validation
      │
      ▼
Final Output
```

---

# Future Enhancements

Future improvements may include:

- Domain-specific prompt templates.
- State-specific prompt customization.
- Improved multilingual prompt optimization.
- Automatic prompt evaluation.
- Dynamic prompt routing based on legal domain.

---

# Best Practices

- Keep prompts modular.
- Minimize unnecessary context.
- Use structured output requirements.
- Ground responses in retrieved legal information.
- Maintain prompt version history.
- Test prompts after legal knowledge updates.

---

# Conclusion

The SattamAI Prompt Engineering Guide establishes a consistent framework for constructing AI prompts across the platform. By combining structured instructions, retrieved legal context, multilingual support, and validation, the prompt system helps produce clear, explainable, and reliable legal guidance while remaining adaptable as the platform evolves.
