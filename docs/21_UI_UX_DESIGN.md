# 21_UI_UX_DESIGN.md

# ⚖️ SattamAI UI/UX Design Specification

**Version:** 1.0

**Project:** SattamAI – AI-Powered Legal Assistant for India

---

# Overview

This document defines the User Interface (UI) and User Experience (UX) standards for SattamAI. The application is designed to make legal information easy to understand, especially for users who may have little or no legal knowledge.

The design emphasizes simplicity, accessibility, multilingual support, and a conversational AI-first experience.

---

# Design Principles

The UI should follow these principles:

- Simplicity over complexity.
- Tamil-first with English support.
- Accessibility for all age groups.
- Minimal learning curve.
- Fast access to legal assistance.
- Consistent design language.
- Mobile-first experience.

---

# Design System

## Primary Colors

| Purpose | Color |
|----------|--------|
| Primary | Deep Blue (#1E3A8A) |
| Secondary | Emerald Green (#10B981) |
| Accent | Amber (#F59E0B) |
| Success | Green (#22C55E) |
| Warning | Orange (#F97316) |
| Error | Red (#EF4444) |
| Background | White (#FFFFFF) |
| Dark Background | #0F172A |

---

## Typography

Recommended Font:

- Inter
- Noto Sans Tamil

Font Sizes:

| Element | Size |
|----------|------|
| App Title | 30 |
| Screen Title | 24 |
| Section Heading | 20 |
| Body Text | 16 |
| Caption | 14 |
| Button Text | 16 |

---

## Spacing

Use an 8-point spacing system:

- 8 px
- 16 px
- 24 px
- 32 px
- 48 px

This ensures consistency across all screens.

---

# Navigation Structure

```text id="nav-flow"
Splash Screen
      │
      ▼
Onboarding
      │
      ▼
Login / Signup
      │
      ▼
Home
      │
 ┌────┼─────┐
 ▼    ▼     ▼
Chat Cases Profile
 │
 ▼
Analysis
 │
 ▼
Documents
 │
 ▼
Lawyers
```

---

# Screens

## 1. Splash Screen

Purpose:

- Display logo.
- Load user session.
- Initialize services.

Components:

- Logo
- App Name
- Loading Indicator

---

## 2. Onboarding

Pages:

- Welcome
- AI Legal Assistant
- Privacy
- Multilingual Support

Buttons:

- Login
- Create Account
- Skip

---

## 3. Login Screen

Components:

- Email
- Phone Number
- Password
- Login Button
- Register Button
- Forgot Password

---

## 4. Home Screen

Greeting:

> "How can I help you today?"

Input Options:

- Text
- Voice
- Image Upload
- Document Upload

Quick Categories:

- Traffic
- Cyber Crime
- Consumer
- Labour
- Property
- Family
- Banking
- Government Services

Recent Activity:

- Previous Chats
- Recent Cases
- Saved Documents

---

## 5. AI Chat Screen

Main Components:

- Chat Bubbles
- AI Typing Indicator
- Voice Button
- Attachment Button
- Send Button

AI Response Sections:

- Summary
- Legal Information
- Rights
- Responsibilities
- Required Documents
- Government Department
- Suggested Actions
- References

Actions:

- Generate Document
- Save
- Share
- Translate

---

## 6. Analysis Screen

Displays:

- Legal Domain
- Confidence Indicator
- Severity Level
- Recommended Department
- Required Documents
- Legal References

Visualization:

- Progress Bars
- Status Cards
- Timeline (if applicable)

---

## 7. Document Screen

Features:

- Editable document preview.
- Download PDF.
- Share document.
- Save draft.
- Print support.

---

## 8. Lawyer Screen

Displays:

- Nearby Lawyers
- Ratings
- Experience
- Languages
- Contact Options

Actions:

- Call
- Chat
- Book Appointment
- View Profile

---

## 9. Case Tracker

Timeline Stages:

- Created
- AI Analysis
- Document Generated
- Lawyer Assigned
- Submitted
- In Progress
- Completed

Each stage should include timestamps where available.

---

## 10. Profile Screen

Displays:

- User Information
- Language Preference
- Saved Cases
- Saved Documents
- Notification Settings
- Privacy Settings
- Help & Support
- Logout

---

# Bottom Navigation

Recommended tabs:

- Home
- Chat
- Cases
- Documents
- Profile

---

# Components

Standard reusable components:

- Buttons
- Cards
- Chat bubbles
- Text fields
- Dropdowns
- Progress bars
- Timelines
- Search bars
- Bottom sheets
- Dialogs
- Snackbars
- Loading indicators

---

# Accessibility

The application should support:

- Large touch targets.
- High-contrast mode.
- Screen readers.
- Scalable text.
- Keyboard navigation (where applicable).
- Voice interaction.

---

# Multilingual UX

Primary language:

- Tamil

Secondary language:

- English

Users should be able to switch languages from the profile settings without losing their session.

---

# Animations

Suggested animations:

- Screen transitions.
- Chat typing indicator.
- Button feedback.
- Loading skeletons.
- Success animations.
- Error animations.

Animations should be subtle and should not delay user interaction.

---

# Empty States

Examples:

- No Cases
- No Documents
- No Notifications
- No Search Results

Each empty state should provide a helpful explanation and a clear next action.

---

# Error Handling

User-friendly messages should be displayed for:

- Network errors.
- AI service unavailable.
- Invalid input.
- Upload failures.
- Authentication issues.

Avoid exposing technical details to end users.

---

# Responsive Design

The interface should adapt to:

- Small phones.
- Large phones.
- Tablets.

Layouts should maintain readability and usability across supported devices.

---

# Future UI Enhancements

Potential additions:

- Dark mode.
- Personalized dashboard.
- Voice-only interaction mode.
- Offline document viewer.
- AI quick actions.
- Home screen widgets.

---

# User Journey

```text id="journey"
Open App
    │
    ▼
Login
    │
    ▼
Describe Legal Problem
    │
    ▼
AI Analysis
    │
    ▼
View Rights & Guidance
    │
    ▼
Generate Document
    │
    ▼
Connect Lawyer (Optional)
    │
    ▼
Track Case Progress
```

---

# Conclusion

The SattamAI UI/UX design prioritizes clarity, accessibility, and ease of use. By combining a conversational AI interface with structured legal guidance, multilingual support, and intuitive navigation, the application aims to make legal information understandable and actionable for users across India.
