---
guideline_id: SEC-001
name: Security Guidelines
version: "1.0"
last_updated: "2025-01-29"
enforcement: blocking
applies_to: both
categories:
  - authentication
  - authorization
  - data-protection
  - injection-prevention
  - logging
priority: critical
owner: security-team
---

# Security Guidelines

**Purpose:** Ensure all specifications and implementations meet enterprise security requirements based on industry best practices and OWASP guidelines.

---

## 1. Authentication Requirements

### SEC-AUTH-01: Secure Password Handling

**Requirement:** All passwords MUST be hashed using bcrypt (cost >= 10) or Argon2. Plaintext passwords MUST never be stored or logged.

**Applies To:** implementation

**Severity:** critical

**ARC Verification:**
- ARC_SEC_AUTH_01a: Verify password storage uses bcrypt with cost >= 10 OR Argon2
- ARC_SEC_AUTH_01b: Verify plaintext passwords are never logged or stored in databases
- ARC_SEC_AUTH_01c: Verify password comparison uses constant-time comparison function

**Compliant Example:**
```typescript
import bcrypt from 'bcrypt';

async function hashPassword(password: string): Promise<string> {
  const saltRounds = 12; // cost factor >= 10
  return bcrypt.hash(password, saltRounds);
}

async function verifyPassword(password: string, hash: string): Promise<boolean> {
  return bcrypt.compare(password, hash); // constant-time comparison
}
```

**Non-Compliant Example:**
```typescript
// VIOLATION: Storing plaintext password
db.users.insert({ password: userPassword });

// VIOLATION: Using weak hashing algorithm
const hash = crypto.createHash('md5').update(password).digest('hex');

// VIOLATION: Non-constant-time comparison
if (storedPassword === inputPassword) { /* ... */ }
```

**Remediation:** Replace plaintext storage or weak hashing with bcrypt. Use library's built-in compare function for constant-time comparison.

---

### SEC-AUTH-02: Session Management

**Requirement:** Sessions MUST have secure cookie settings and configurable expiry. Session tokens MUST be regenerated after authentication.

**Applies To:** both

**Severity:** high

**ARC Verification:**
- ARC_SEC_AUTH_02a: Verify session cookies have HttpOnly flag set to true
- ARC_SEC_AUTH_02b: Verify session cookies have Secure flag in production environment
- ARC_SEC_AUTH_02c: Verify session expiry is configurable and defaults to <= 24 hours
- ARC_SEC_AUTH_02d: Verify session token is regenerated after successful login
- ARC_SEC_AUTH_02e: Spec MUST document session lifecycle and security properties

**Compliant Example:**
```typescript
app.use(session({
  secret: process.env.SESSION_SECRET,
  cookie: {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: 24 * 60 * 60 * 1000 // 24 hours max
  },
  resave: false,
  saveUninitialized: false
}));

// Regenerate session after login
req.session.regenerate((err) => {
  req.session.userId = user.id;
});
```

**Non-Compliant Example:**
```typescript
// VIOLATION: Insecure cookie settings
app.use(session({
  secret: 'hardcoded-secret', // Never hardcode secrets
  cookie: {
    httpOnly: false,  // Allows XSS to steal session
    secure: false,    // Allows interception over HTTP
    // Missing maxAge = potential infinite session
  }
}));
```

---

## 2. Authorization Requirements

### SEC-AUTHZ-01: Role-Based Access Control

**Requirement:** All protected resources MUST implement server-side authorization checks. Authorization MUST NOT rely solely on client-side controls.

**Applies To:** both

**Severity:** critical

**ARC Verification:**
- ARC_SEC_AUTHZ_01a: Verify all API endpoints have authorization middleware
- ARC_SEC_AUTHZ_01b: Verify authorization is enforced server-side, not client-only
- ARC_SEC_AUTHZ_01c: Verify Spec documents required roles/permissions per endpoint
- ARC_SEC_AUTHZ_01d: Verify authorization failures return 403 Forbidden (not 404)

**Compliant Example:**
```typescript
// Server-side authorization middleware
const authorize = (roles: string[]) => (req, res, next) => {
  if (!req.user || !roles.includes(req.user.role)) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  next();
};

router.delete('/users/:id',
  authenticate,
  authorize(['admin']), // Server-side role check
  deleteUserHandler
);
```

**Non-Compliant Example:**
```typescript
// VIOLATION: No server-side authorization
router.delete('/users/:id', deleteUserHandler); // Anyone can delete!

// VIOLATION: Client-only authorization (easily bypassed)
// Frontend: if (user.role === 'admin') showDeleteButton()
// Backend: router.delete('/users/:id', deleteUserHandler); // No check!
```

---

### SEC-AUTHZ-02: IDOR Prevention

**Requirement:** Resource access MUST verify the requesting user has permission to access the specific resource, not just the resource type.

**Applies To:** implementation

**Severity:** critical

**ARC Verification:**
- ARC_SEC_AUTHZ_02a: Verify resource ownership is checked before returning data
- ARC_SEC_AUTHZ_02b: Verify users cannot access other users' data by changing IDs in requests

**Compliant Example:**
```typescript
// Check ownership before returning resource
async function getDocument(req, res) {
  const doc = await Document.findById(req.params.id);
  if (!doc) return res.status(404).json({ error: 'Not found' });

  // IDOR prevention: verify ownership
  if (doc.ownerId !== req.user.id && !req.user.isAdmin) {
    return res.status(403).json({ error: 'Forbidden' });
  }

  res.json(doc);
}
```

---

## 3. Data Protection Requirements

### SEC-DATA-01: Sensitive Data Handling

**Requirement:** PII and sensitive data MUST be encrypted at rest and in transit. Data classification MUST be documented in specs.

**Applies To:** both

**Severity:** critical

**ARC Verification:**
- ARC_SEC_DATA_01a: Verify database connections use TLS/SSL
- ARC_SEC_DATA_01b: Verify PII fields are encrypted or appropriately protected
- ARC_SEC_DATA_01c: Verify Spec includes data classification (Public/Internal/Confidential/Secret)
- ARC_SEC_DATA_01d: Verify sensitive data is not included in logs or error messages

**Compliant Example:**
```typescript
// TLS connection to database
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: true }
});

// Encrypt sensitive fields
const encryptedSSN = encrypt(user.ssn, process.env.ENCRYPTION_KEY);
```

---

## 4. Injection Prevention

### SEC-INJ-01: SQL Injection Prevention

**Requirement:** All database queries MUST use parameterized queries, prepared statements, or ORM methods. String concatenation in queries is PROHIBITED.

**Applies To:** implementation

**Severity:** critical

**ARC Verification:**
- ARC_SEC_INJ_01a: Verify no string concatenation or template literals in SQL queries
- ARC_SEC_INJ_01b: Verify ORM is used OR parameterized queries exclusively

**Compliant Example:**
```typescript
// Using ORM (Prisma)
const user = await prisma.user.findUnique({ where: { id: userId } });

// Using parameterized query
const result = await db.query('SELECT * FROM users WHERE id = $1', [userId]);

// Using prepared statement
const stmt = db.prepare('SELECT * FROM users WHERE email = ?');
const user = stmt.get(email);
```

**Non-Compliant Example:**
```typescript
// VIOLATION: SQL Injection vulnerable - string concatenation
const result = await db.query(`SELECT * FROM users WHERE id = ${userId}`);

// VIOLATION: SQL Injection vulnerable - template literal
const query = `SELECT * FROM users WHERE name = '${userName}'`;
```

---

### SEC-INJ-02: XSS Prevention

**Requirement:** All user input displayed in HTML MUST be properly escaped or sanitized. Framework auto-escaping should not be bypassed without explicit security review.

**Applies To:** implementation

**Severity:** high

**ARC Verification:**
- ARC_SEC_INJ_02a: Verify user input is escaped before rendering in HTML
- ARC_SEC_INJ_02b: Verify dangerouslySetInnerHTML (React) or v-html (Vue) usage is justified and sanitized
- ARC_SEC_INJ_02c: Verify Content-Security-Policy headers are configured

**Compliant Example:**
```typescript
// React auto-escapes by default
return <div>{userInput}</div>; // Safe

// If HTML is required, sanitize first
import DOMPurify from 'dompurify';
const sanitized = DOMPurify.sanitize(userInput);
return <div dangerouslySetInnerHTML={{ __html: sanitized }} />;
```

**Non-Compliant Example:**
```typescript
// VIOLATION: Unsanitized HTML injection
return <div dangerouslySetInnerHTML={{ __html: userInput }} />;
```

---

## 5. Logging Requirements

### SEC-LOG-01: Security Event Logging

**Requirement:** Authentication events (login success/failure, logout, password changes) MUST be logged with audit trail. Logs MUST NOT contain passwords, tokens, or other secrets.

**Applies To:** implementation

**Severity:** high

**ARC Verification:**
- ARC_SEC_LOG_01a: Verify login attempts (success and failure) are logged
- ARC_SEC_LOG_01b: Verify logs do NOT contain passwords, tokens, or API keys
- ARC_SEC_LOG_01c: Verify log entries include timestamp, user ID, event type, IP address
- ARC_SEC_LOG_01d: Verify password change events are logged

**Compliant Example:**
```typescript
// Structured security logging
logger.info({
  event: 'login_success',
  userId: user.id,
  email: user.email,
  ip: req.ip,
  userAgent: req.headers['user-agent'],
  timestamp: new Date().toISOString()
});

// Never log sensitive data
logger.info({ event: 'login_attempt', email }); // Good
logger.info({ event: 'login_attempt', email, password }); // NEVER!
```

**Non-Compliant Example:**
```typescript
// VIOLATION: Logging sensitive data
logger.info(`User ${email} logged in with password ${password}`);
logger.debug({ user, token: authToken }); // Leaking token
```

---

## Compliance Summary

| ID | Requirement | Severity | Scope | Category |
|:---|:------------|:---------|:------|:---------|
| SEC-AUTH-01 | Secure Password Handling | critical | implementation | authentication |
| SEC-AUTH-02 | Session Management | high | both | authentication |
| SEC-AUTHZ-01 | Role-Based Access Control | critical | both | authorization |
| SEC-AUTHZ-02 | IDOR Prevention | critical | implementation | authorization |
| SEC-DATA-01 | Sensitive Data Handling | critical | both | data-protection |
| SEC-INJ-01 | SQL Injection Prevention | critical | implementation | injection-prevention |
| SEC-INJ-02 | XSS Prevention | high | implementation | injection-prevention |
| SEC-LOG-01 | Security Event Logging | high | implementation | logging |

---

## References

- [OWASP Top 10](https://owasp.org/Top10/)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [OWASP Session Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html)
