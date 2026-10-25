# 19_DATABASE_SCHEMA.md

# ⚖️ SattamAI Database Schema

**Version:** 1.0

**Project:** SattamAI – AI-Powered Legal Assistant for India

---

# Overview

This document defines the PostgreSQL (via Supabase) database schema for SattamAI.

The database stores user accounts, legal cases, AI conversations, generated documents, lawyer information, notifications, analytics, and audit logs. The schema is designed for scalability, security, and efficient querying while supporting future expansion.

---

# Database Overview

**Database Name**

```text
sattamai
```

Collections:

- users
- cases
- chat_sessions
- chat_messages
- documents
- lawyers
- appointments
- departments
- legal_templates
- notifications
- feedback
- audit_logs
- ai_logs
- settings

---

# Entity Relationship

```text
User
 │
 ├── Cases
 │      │
 │      ├── Documents
 │      ├── Chat Sessions
 │      ├── AI Analysis
 │      └── Appointments
 │
 ├── Notifications
 │
 └── Feedback
```

---

# users Collection

Stores registered user information.

### Fields

| Field | Type | Description |
|--------|------|-------------|
| _id | ObjectId | Primary Key |
| fullName | String | User name |
| email | String | Email address |
| phone | String | Phone number |
| profileImage | String | Profile image URL |
| preferredLanguage | String | Tamil / English |
| state | String | User's state |
| district | String | District |
| role | String | User / Admin / Lawyer |
| createdAt | Date | Creation timestamp |
| updatedAt | Date | Last update |

Indexes:

- email
- phone
- role

---

# cases Collection

Stores legal cases created by users.

### Fields

| Field | Type |
|--------|------|
| _id | ObjectId |
| userId | ObjectId |
| title | String |
| legalDomain | String |
| status | String |
| severity | String |
| summary | String |
| aiAnalysis | Object |
| assignedLawyer | ObjectId |
| createdAt | Date |
| updatedAt | Date |

Possible status values:

- Draft
- Submitted
- Under Review
- In Progress
- Closed

Indexes:

- userId
- legalDomain
- status

---

# chat_sessions Collection

Stores AI conversation sessions.

### Fields

- sessionId
- userId
- caseId
- title
- language
- startedAt
- endedAt
- lastMessageAt

Indexes:

- userId
- caseId

---

# chat_messages Collection

Stores individual messages.

### Fields

- messageId
- sessionId
- sender
- message
- citations
- attachments
- timestamp

Sender values:

- User
- AI

---

# documents Collection

Stores generated legal documents.

### Fields

- documentId
- userId
- caseId
- documentType
- fileUrl
- version
- createdAt
- updatedAt

Document types:

- Complaint Letter
- Legal Notice
- Application
- Representation
- Affidavit Draft

---

# lawyers Collection

Stores lawyer profiles.

### Fields

- lawyerId
- fullName
- specialization
- barCouncilRegistration
- experience
- languages
- location
- rating
- phone
- email
- officeAddress
- availability

Indexes:

- specialization
- location

---

# appointments Collection

Stores appointments between users and lawyers.

### Fields

- appointmentId
- userId
- lawyerId
- caseId
- appointmentDate
- appointmentTime
- meetingType
- status

Meeting types:

- Online
- Offline

Status:

- Requested
- Confirmed
- Completed
- Cancelled

---

# departments Collection

Stores government department information.

Examples:

- Police
- Traffic Police
- Cyber Crime
- Labour Department
- Revenue Department
- Consumer Commission
- Transport Department

### Fields

- departmentId
- departmentName
- description
- jurisdiction
- contactDetails
- website
- officeLocations

---

# legal_templates Collection

Stores reusable legal document templates.

Fields:

- templateId
- templateName
- category
- language
- templateContent
- version

---

# notifications Collection

Stores notifications sent to users.

Fields:

- notificationId
- userId
- title
- message
- type
- isRead
- createdAt

Notification types:

- Case Update
- Appointment
- Reminder
- AI Alert
- System Notification

---

# feedback Collection

Stores user feedback.

Fields:

- feedbackId
- userId
- sessionId
- rating
- comments
- submittedAt

---

# audit_logs Collection

Stores security and administrative logs.

Fields:

- logId
- action
- performedBy
- timestamp
- ipAddress
- description

Examples:

- Login
- Dataset Update
- Role Change
- AI Configuration Update

---

# ai_logs Collection

Stores AI processing information for monitoring and debugging.

Fields:

- requestId
- userId
- modelVersion
- responseTime
- retrievalTime
- tokensUsed
- status
- createdAt

---

# settings Collection

Stores application configuration.

Examples:

- Supported Languages
- Feature Flags
- AI Configuration
- Notification Settings
- Maintenance Mode

---

# Relationships

```text
User
 ├── Cases
 │     ├── Documents
 │     ├── Chat Sessions
 │     ├── AI Logs
 │     └── Appointments
 │
 ├── Notifications
 ├── Feedback
 └── Profile
```

---

# Indexing Strategy

Indexes should be created for:

- User email
- Phone number
- Case status
- Legal domain
- Lawyer specialization
- Lawyer location
- Chat session ID
- Notification user ID
- Appointment date

Compound indexes may be added based on production query patterns.

---

# Data Retention

Recommended policy:

- Retain user data until account deletion or as required by applicable law.
- Preserve audit logs for operational and security purposes according to organizational policy.
- Archive inactive AI logs after a defined retention period.
- Support user requests for data export and deletion where applicable.

---

# Security Considerations

The database should implement:

- Role-based access control.
- Encryption in transit.
- Encryption at rest where supported.
- Secure backups.
- Audit logging.
- Input validation.
- Regular security reviews.

---

# Future Expansion

Future collections may include:

- Court Cases
- Legal Research
- Government Schemes
- State-Specific Laws
- AI Evaluation Results
- Knowledge Base Versions
- Analytics Dashboards

---

# Conclusion

The SattamAI PostgreSQL (via Supabase) schema provides a scalable and modular data foundation for user management, legal case tracking, AI conversations, document generation, lawyer connections, and platform administration. The schema is designed to evolve as new features and legal services are introduced while maintaining performance, security, and maintainability.
