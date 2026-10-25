# 20_API_SPECIFICATION.md

# ⚖️ SattamAI REST API Specification

**Version:** 1.0

**Project:** SattamAI – AI-Powered Legal Assistant for India

---

# Overview

This document defines the REST API specification for the SattamAI platform. The APIs enable communication between the Flutter mobile application, the Python backend, AI services, legal knowledge systems, and supporting platform services.

All APIs should return structured JSON responses and use consistent authentication, validation, error handling, and versioning.

---

# API Standards

## Base URL

```text id="base-url"
Development:
http://localhost:3000/api/v1

Production:
https://api.sattamai.com/api/v1
```

---

## Response Format

### Success Response

```json
{
  "success": true,
  "message": "Request completed successfully",
  "data": {}
}
```

### Error Response

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request data"
  }
}
```

---

# Authentication APIs

## Register User

**POST**

```
/auth/register
```

Request:

- Full Name
- Email
- Phone Number
- Password
- Preferred Language

Response:

- User ID
- Access Token
- Refresh Token

---

## Login

**POST**

```
/auth/login
```

Request:

- Email / Phone
- Password

Response:

- Access Token
- Refresh Token
- User Profile

---

## Logout

**POST**

```
/auth/logout
```

---

## Refresh Token

**POST**

```
/auth/refresh
```

---

## Forgot Password

**POST**

```
/auth/forgot-password
```

---

# User APIs

## Get Profile

**GET**

```
/users/profile
```

---

## Update Profile

**PUT**

```
/users/profile
```

---

## Delete Account

**DELETE**

```
/users/profile
```

---

# AI Chat APIs

## Analyze Legal Query

**POST**

```
/ai/analyze
```

Input:

- Text
- Voice
- Image
- Preferred Language

Response:

- Legal Domain
- Summary
- Rights
- Responsibilities
- Required Documents
- Recommended Department
- Suggested Actions
- Citations

---

## Continue Conversation

**POST**

```
/ai/chat
```

Maintains conversational context for follow-up questions.

---

## Translate Response

**POST**

```
/ai/translate
```

Supports translation between supported languages.

---

# Law Search APIs

## Search Laws

**GET**

```
/laws/search
```

Query parameters:

- Keyword
- Legal Domain
- State
- Language

---

## Get Law Details

**GET**

```
/laws/{lawId}
```

Returns:

- Law title
- Sections
- Summary
- Related laws
- References

---

# Case Management APIs

## Create Case

**POST**

```
/cases
```

---

## Get User Cases

**GET**

```
/cases
```

---

## Get Case Details

**GET**

```
/cases/{caseId}
```

---

## Update Case

**PUT**

```
/cases/{caseId}
```

---

## Close Case

**PATCH**

```
/cases/{caseId}/close
```

---

# Document APIs

## Generate Legal Document

**POST**

```
/documents/generate
```

Supported types:

- Complaint Letter
- Legal Notice
- Representation
- Application

---

## Download PDF

**GET**

```
/documents/{documentId}/download
```

---

## Edit Document

**PUT**

```
/documents/{documentId}
```

---

## Delete Document

**DELETE**

```
/documents/{documentId}
```

---

# File Upload APIs

## Upload Image

**POST**

```
/upload/image
```

---

## Upload Voice

**POST**

```
/upload/audio
```

---

## Upload PDF

**POST**

```
/upload/pdf
```

---

# Lawyer APIs

## Find Nearby Lawyers

**GET**

```
/lawyers/nearby
```

Parameters:

- Latitude
- Longitude
- Specialization

---

## Get Lawyer Profile

**GET**

```
/lawyers/{lawyerId}
```

---

## Book Appointment

**POST**

```
/appointments
```

---

## Cancel Appointment

**PATCH**

```
/appointments/{appointmentId}/cancel
```

---

# Government Department APIs

## Find Relevant Department

**POST**

```
/departments/recommend
```

Returns:

- Department
- Contact Information
- Required Documents
- Office Details

---

## Department Details

**GET**

```
/departments/{departmentId}
```

---

# Notification APIs

## Get Notifications

**GET**

```
/notifications
```

---

## Mark Notification as Read

**PATCH**

```
/notifications/{notificationId}
```

---

# Feedback APIs

## Submit Feedback

**POST**

```
/feedback
```

---

## View Feedback History

**GET**

```
/feedback
```

---

# Admin APIs

## Upload Legal Dataset

**POST**

```
/admin/datasets
```

---

## Update Legal Dataset

**PUT**

```
/admin/datasets/{datasetId}
```

---

## AI Analytics

**GET**

```
/admin/analytics
```

---

## User Management

**GET**

```
/admin/users
```

---

## Lawyer Management

**GET**

```
/admin/lawyers
```

---

# HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Resource Created |
| 204 | No Content |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 409 | Conflict |
| 422 | Validation Error |
| 429 | Too Many Requests |
| 500 | Internal Server Error |

---

# Authentication

Protected endpoints require:

```
Authorization: Bearer <access_token>
```

Authentication should use secure token handling with refresh token support.

---

# Rate Limiting

Recommended limits:

- Authentication APIs
- AI analysis endpoints
- File uploads
- Document generation

The exact thresholds should be configurable and monitored.

---

# API Versioning

Version format:

```
/api/v1
```

Future versions:

```
/api/v2
/api/v3
```

Older versions should be deprecated with a documented migration plan.

---

# Logging

All API requests should record:

- Request ID
- Timestamp
- Endpoint
- Response status
- Processing time
- Authenticated user (where applicable)

Sensitive information should not be logged.

---

# Security

All APIs should implement:

- HTTPS
- Authentication
- Authorization
- Input validation
- Output sanitization
- File validation
- Rate limiting
- Audit logging

---

# Future APIs

Planned additions include:

- Government API integrations
- Court case lookup
- Legal research APIs
- Offline synchronization
- AI model management
- Voice assistant APIs
- Web application APIs

---

# Conclusion

The SattamAI REST API provides a consistent and scalable interface between the mobile application, backend services, AI orchestration layer, and legal knowledge systems. Its modular design supports secure communication, future expansion, and reliable integration across all platform components.
