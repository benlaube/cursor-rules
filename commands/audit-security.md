# audit-security

## Metadata

- **Status:** Active
- **Created:** 02-12-2025 00:00:00 EST
- **Last Updated:** 12-04-2025 19:07:02 EST
- **Version:** 1.3.0
- **Description:** Perform a comprehensive security audit on the project, scanning for vulnerabilities, secrets, misconfigurations, and security best practices. Includes secrets scanning, dependency audits, RLS validation, API security checks, and configuration validation.
- **Type:** Executable Command
- **Audience:** AI agents performing security audits
- **Applicability:** When auditing security, checking for secrets, scanning for vulnerabilities, or before security-sensitive changes
- **How to Use:** Run this command to perform comprehensive security audit. Use `fix=true` to attempt automatic fixes for minor issues (gitignore entries, .env.example creation)
- **Dependencies:** None
- **Related Cursor Commands:** [audit-project.md](./audit-project.md), [audit-access-control.md](./audit-access-control.md), [full-project-health-check.md](./full-project-health-check.md)
- **Related Cursor Rules:** [supabase-rls-policy-review.mdc](../rules/supabase-rls-policy-review.mdc), [audit-report.mdc](../rules/audit-report.mdc)
- **Related Standards:** [security/security-audit-checklist.md](../../standards/security/security-audit-checklist.md), [security/access-control.md](../../standards/security/access-control.md)

---

# Security Audit Command

Use this command to perform a comprehensive security audit of the project, scanning for vulnerabilities, secrets, misconfigurations, and security best practices.

**Source Checklist:** `standards/security/security-audit-checklist.md` (comprehensive security audit checklist)

## Usage

@agent: When asked to "audit security", "check for secrets", "security scan", or "scan for vulnerabilities", follow this procedure.

**Parameters:**

- `fix`: `true` or `false` (default: `false`). If true, attempt to fix minor issues (e.g., add to gitignore, create .env.example).

---

## Visual Workflow

```mermaid
flowchart TD
    Start([Start security audit]) --> Secrets[Secrets scan & .gitignore validation]
    Secrets --> Env[.env tracking check\n& template validation]
    Env --> Deps[Vulnerability audit\n(npm/pip) + lockfile check]
    Deps --> Unused[Identify unused dependencies]
    Unused --> Access[Access control & RLS review\n(if Supabase)]
    Access --> API[API security checks\n(authn/z, rate limits, schemas)]
    API --> Config[Runtime/config validation\nCORS, HTTPS, headers]
    Config --> Report[Summarize findings\nwith severities and actions]
    Report --> Done([Output report / create issues])
```

---

## Execution Steps

### 1. Secrets & Environment Variables Scan

#### 1.1 Comprehensive Secret Pattern Detection

1. **Scan for Hardcoded Secrets:** Search for all common secret patterns:
   - _Command:_ `grep -rE "sk_live|sk_test|pk_live|pk_test|sk_live_|sk_test_|ghp_|gho_|ghu_|ghs_|ghr_|xoxb-|xoxp-|eyJ|AKIA|aws_access_key_id|client_secret|oauth_token|postgres://|mysql://" . --exclude-dir={node_modules,.git,dist,build,.next} || true`
   - _Patterns Checked:_
     - API Keys: `sk_live`, `sk_test`, `pk_live`, `pk_test`, `sk_live_`, `sk_test_`
     - GitHub Tokens: `ghp_`, `gho_`, `ghu_`, `ghs_`, `ghr_`
     - AWS Keys: `AKIA`, `aws_access_key_id`
     - Database Credentials: `postgres://`, `mysql://` (connection strings with passwords)
     - OAuth Secrets: `client_secret`, `oauth_token`
     - Slack Tokens: `xoxb-`, `xoxp-`
     - JWT Tokens: `eyJ` (base64 encoded JSON)
   - _Action:_ Report any findings immediately with file locations and line numbers.
   - _Severity:_ ❌ Critical - Secrets must be removed immediately

#### 1.2 .gitignore Validation

1. **Check Required Entries:** Verify all required sensitive files are ignored:
   - _Required Entries:_
     - `.env`
     - `.env.local`
     - `.env.*.local`
     - `*.pem`
     - `*.key`
     - `credentials.json`
     - `logs/`
     - `.secrets/`
   - _Command:_ `grep -E "^\.env$|^\.env\.local$|^\.env\..*\.local$|^\*\.pem$|^\*\.key$|^credentials\.json$|^logs/$|^\.secrets/$" .gitignore || echo "Missing entries"`
   - _Action:_ If `fix=true` and entries are missing, append them to `.gitignore`.
   - _Severity:_ ⚠️ High - Missing entries could lead to secret exposure

#### 1.3 Environment File Security

1. **Check .env is Not Committed:**
   - _Command:_ `git ls-files .env .env.local`
   - _Action:_ If `.env` is tracked, warn immediately. Should return nothing.
   - _Severity:_ ❌ Critical if `.env` is tracked

2. **Validate .env.example:**
   - _Check:_ Ensure `.env.example` exists and contains NO real values (only placeholders)
   - _Command:_ `grep -E "sk_live|ghp_|password.*=.*[^<]" .env.example 2>/dev/null || echo "No secrets found"`
   - _Action:_ If `fix=true` and `.env.example` is missing, create template with placeholder values.
   - _Severity:_ ⚠️ Medium - Missing or contains real values

3. **Environment Variable Documentation:**
   - _Check:_ Verify required environment variables are documented in README or setup guide
   - _Action:_ Report if documentation is missing
   - _Severity:_ ⚠️ Low - Documentation gap

---

### 2. Dependencies (Supply Chain Security)

#### 2.1 Package Vulnerability Audit

1. **Node.js Projects:**
   - _Command:_ `npm audit` (or `yarn audit`, `pnpm audit` based on lockfile)
   - _Action:_ Categorize vulnerabilities:
     - ❌ Critical: Must fix immediately
     - ⚠️ High: Fix within 24 hours
     - ⚠️ Medium: Review and fix within 1 week
     - ℹ️ Low: Document for future updates
   - _Summary:_ Count and list Critical/High vulnerabilities

2. **Python Projects:**
   - _Command:_ `pip-audit` or `safety check` (if installed)
   - _Action:_ Same categorization as Node.js
   - _Note:_ If tools not installed, suggest installation

#### 2.2 Lockfile Validation

1. **Check Lockfile Presence:**
   - _Required Files:_
     - `package-lock.json` (npm)
     - `yarn.lock` (yarn)
     - `pnpm-lock.yaml` (pnpm)
     - `requirements.txt` with pinned versions (Python)
   - _Command:_ Check for existence of appropriate lockfile
   - _Action:_ Warn if lockfile is missing (prevents supply chain attacks)
   - _Severity:_ ⚠️ High - Missing lockfile

#### 2.3 Unused Dependencies Check

1. **Identify Unused Packages:**
   - _Node.js:_ Suggest running `depcheck` or `npm-check-unused`
   - _Python:_ Suggest running `pip-check` or `pipdeptree`
   - _Action:_ Report suggestion to reduce attack surface
   - _Severity:_ ℹ️ Low - Optimization opportunity

#### 2.4 Dependency Remediation

1. **Auto-Fix (if fix=true):**
   - _Command:_ `npm audit fix` (only if safe, with confirmation)
   - _Action:_ Run fix for non-breaking updates only
   - _Note:_ Always review breaking changes manually

---

### 3. Database & Authentication Security (Supabase)

#### 3.1 Supabase Detection

1. **Check for Supabase:**
   - _Indicators:_ `supabase/` directory exists OR `SUPABASE_URL` environment variable is set
   - _Action:_ If detected, proceed with Supabase-specific checks

#### 3.2 Row Level Security (RLS) Validation

1. **RLS Enablement Check:**
   - _Command:_ Search migrations for `ALTER TABLE ... ENABLE ROW LEVEL SECURITY`
   - _Action:_ Warn if public tables are missing RLS
   - _Severity:_ ❌ Critical - Missing RLS on public tables
   - _Note:_ Deep RLS analysis is automatically applied via `.cursor/rules/supabase-rls-policy-review.mdc` when Supabase is detected

2. **RLS Policy Review:**
   - _Check:_ Ensure policies are not too permissive (e.g., `using (true)` on UPDATE/DELETE)
   - _Action:_ Apply `.cursor/rules/supabase-rls-policy-review.mdc` rule automatically for detailed analysis
   - _Reference:_ `standards/security/access-control.md` for policy patterns

#### 3.3 Service Role Key Security

1. **Check Service Role Key Usage:**
   - _Command:_ `grep -r "SERVICE_ROLE\|service_role" src/ app/ components/ --exclude-dir=node_modules 2>/dev/null || echo "No service role usage found"`
   - _Action:_ Verify `SUPABASE_SERVICE_ROLE_KEY` is ONLY used in:
     - ✅ Edge Functions (server-side)
     - ✅ Secure API routes (server-side)
     - ✅ Admin scripts (local/server-side)
   - _Never:_ Client-side code, browser JavaScript, public repositories
   - _Severity:_ ❌ Critical if found in client code

#### 3.4 Public Access (Anon Role) Review

1. **Check Anon Permissions:**
   - _Action:_ Review if `anon` role has excessive permissions
   - _Check:_ Are public tables properly protected?
   - _Check:_ Is public data read-only where appropriate?
   - _Severity:_ ⚠️ High if anon has write access to sensitive tables

#### 3.5 Database Documentation

1. **Table Comments (if Supabase MCP available):**
   - _Check:_ Verify tables have descriptions/comments
   - _Action:_ Report tables without comments
   - _Reference:_ `standards/database/schema.md`
   - _Severity:_ ℹ️ Low - Documentation gap

---

### 4. API & Edge Functions Security

#### 4.1 Input Validation

1. **Check for Validation Libraries:**
   - _Node.js/TypeScript:_ Look for Zod schemas, Joi, or validation middleware
   - _Python:_ Look for Pydantic models or validation decorators
   - _Command:_ `grep -rE "zod|pydantic|joi|validate" src/ --include="*.ts" --include="*.js" --include="*.py" | head -20`
   - _Action:_ Verify all API routes and Edge Functions validate:
     - Input types (string, number, object, etc.)
     - Input sizes (max length, array limits)
     - Required fields
     - Format validation (email, URL, etc.)
   - _Severity:_ ⚠️ High if validation is missing

#### 4.2 Rate Limiting

1. **Check for Rate Limiting:**
   - _Indicators:_ Look for rate limiting middleware, counters, CAPTCHA, or throttling logic
   - _Command:_ `grep -rE "rate.?limit|throttle|captcha|abuse" src/ --include="*.ts" --include="*.js" --include="*.py" | head -10`
   - _Action:_ Report if rate limiting is missing on sensitive endpoints
   - _Severity:_ ⚠️ Medium - Missing rate limiting

#### 4.3 Error Handling Security

1. **Check Error Messages:**
   - _Command:_ Review error handling in API routes and Edge Functions
   - _Check:_ Ensure production errors do NOT expose:
     - Stack traces
     - Database errors
     - File paths
     - Internal system details
   - _Action:_ Verify generic error messages are returned to users
   - _Severity:_ ⚠️ High if stack traces are exposed

#### 4.4 Service Role Key in Client Code

1. **Double-Check Client Code:**
   - _Command:_ `grep -r "SERVICE_ROLE\|service_role" src/app src/components --exclude-dir=node_modules 2>/dev/null`
   - _Action:_ This is a critical security issue - report immediately if found
   - _Severity:_ ❌ Critical

---

### 5. Logging & Output Security

#### 5.1 Sensitive Data in Logs

1. **Check for PII/Secrets in Logging:**
   - _Command:_ `grep -rE "password|api_key|token|secret" src/ --include="*.ts" --include="*.js" --include="*.py" | grep -iE "console\.log|logger|print" | head -20`
   - _Patterns to Check:_
     - Passwords
     - API keys
     - Tokens
     - Credit card numbers
     - Social Security Numbers
     - Personal Identifiable Information (PII)
   - _Action:_ Report any findings - sensitive data should never be logged
   - _Severity:_ ❌ Critical if secrets are logged, ⚠️ High if PII is logged

#### 5.2 Console.log in Production

1. **Check for Debug Code:**
   - _Command:_ `grep -r "console\.log\|debugger" src/ --exclude-dir=node_modules --include="*.ts" --include="*.js" | wc -l`
   - _Action:_ Report count and suggest using structured logging instead
   - _Severity:_ ⚠️ Medium - Should use logger module

#### 5.3 Structured Logging

1. **Check Logging Practices:**
   - _Indicators:_ Look for logger module usage, log levels, structured format
   - _Action:_ Verify use of:
     - Structured logging (JSON format)
     - Log levels (ERROR, WARN, INFO, DEBUG)
     - Context information (user ID, request ID, trace ID)
     - PII scrubbing (use logger module's built-in scrubbing)
   - _Reference:_ `modules/logger-module` for best practices
   - _Severity:_ ℹ️ Low - Best practice recommendation

---

### 6. Configuration Security

#### 6.1 Secure Headers Validation

1. **Check Next.js Configuration:**
   - _File:_ `next.config.js` or `next.config.ts`
   - _Required Headers:_
     - `Content-Security-Policy` (CSP)
     - `Strict-Transport-Security` (HSTS)
     - `X-Content-Type-Options: nosniff`
     - `X-Frame-Options: DENY`
     - `X-XSS-Protection: 1; mode=block`
   - _Command:_ `grep -E "headers|Content-Security-Policy|Strict-Transport-Security" next.config.* 2>/dev/null || echo "Headers not configured"`
   - _Action:_ Report missing headers
   - _Severity:_ ⚠️ High if headers are missing

2. **Check Express/Middleware:**
   - _Indicators:_ Look for Helmet middleware or custom header configuration
   - _Action:_ Verify secure headers are configured

#### 6.2 CORS Configuration

1. **Check CORS Settings:**
   - _Command:_ `grep -rE "cors|CORS|Access-Control-Allow-Origin" . --include="*.ts" --include="*.js" --include="*.py" | grep -v node_modules | head -10`
   - _Check:_ Never use `*` for allowed origins
   - _Check:_ Specific domains are configured
   - _Check:_ Environment variables are used for allowed origins
   - _Severity:_ ❌ Critical if wildcard `*` is used

#### 6.3 Environment Variable Configuration

1. **Review .env.example (if fix=true):**
   - _Action:_ Create `.env.example` template if missing
   - _Template:_ Include all required variables with placeholder values only

---

### 7. Authentication & Authorization

#### 7.1 Password Security

1. **Check Password Requirements:**
   - _Indicators:_ Look for password validation, complexity requirements
   - _Requirements:_
     - Minimum 8 characters (prefer 12+)
     - Require complexity (uppercase, lowercase, numbers, symbols)
     - Use secure hashing (bcrypt, argon2)
     - Never store plaintext passwords
   - _Action:_ Report if requirements are too weak
   - _Severity:_ ⚠️ High if weak password requirements

#### 7.2 Session Management

1. **Check Session Practices:**
   - _Indicators:_ Look for session configuration, expiration, rotation
   - _Best Practices:_
     - Use secure, HTTP-only cookies
     - Implement session expiration
     - Rotate session tokens
     - Invalidate sessions on logout
   - _Action:_ Report if best practices are missing
   - _Severity:_ ⚠️ Medium if session management is weak

#### 7.3 Multi-Factor Authentication (MFA)

1. **Check MFA Implementation:**
   - _When Required:_ Admin accounts, financial operations, sensitive data access
   - _Action:_ Report if MFA should be implemented but isn't
   - _Severity:_ ⚠️ Medium - Security enhancement opportunity

---

### 8. Report Generation

**Note:** This command follows the audit report standards defined in `.cursor/rules/audit-report.mdc` and `standards/project-planning/documentation-management.md` Section 8.

1. **Create Structured Report:**
   - _Location:_ `/docs/audit/security_audit_MM-DD-YYYY.md` (see audit-report rule for naming format)
   - _Ensure Directory Exists:_ Create `/docs/audit/` if missing
   - _Format:_ Structured markdown with sections:

     ```markdown
     # Security Audit Report

     **Generated:** MM-DD-YYYY HH:MM:SS EST
     **Auditor:** AI Agent
     **Scope:** Security audit of codebase, dependencies, and configuration

     ## Executive Summary

     - Total Issues: X
     - Critical: X
     - High: X
     - Medium: X
     - Low: X

     ## 1. Secrets & Environment Variables

     [Findings...]

     ## 2. Dependencies

     [Findings...]

     ## 3. Database & Authentication

     [Findings...]

     ## 4. API & Edge Functions

     [Findings...]

     ## 5. Logging & Output

     [Findings...]

     ## 6. Configuration

     [Findings...]

     ## 7. Authentication & Authorization

     [Findings...]

     ## Action Items (Prioritized)

     1. [Critical] Fix item 1
     2. [High] Fix item 2
        ...
     ```

   - _Include:_ Summary statistics, prioritized action items, cross-references to standards

2. **Print Summary to Chat:**
   - _Format:_ Use success/failure format (see Output Format section below)

---

## Output Format

### Success Case

```
✅ Security Audit complete – no critical issues found.

Summary:
- Secrets: ✅ No hardcoded secrets found
- Dependencies: ✅ No critical vulnerabilities
- Database: ✅ RLS enabled, service role secure
- API Security: ✅ Input validation present
- Logging: ✅ No sensitive data in logs
- Configuration: ✅ Secure headers configured
- Authentication: ✅ Password requirements adequate

Minor recommendations:
- ⚠️ Consider adding rate limiting to /api/users endpoint
- ℹ️ 3 unused dependencies detected (optimization opportunity)

Full report saved to: /docs/audit/security_audit_MM-DD-YYYY.md
```

### Failure Case

```
❌ Security Audit found critical security issues.

Issues Found:

**Secrets & Environment Variables:**
- ❌ [Critical] Found hardcoded API key in `src/config.ts:12`
- ⚠️ [High] `.env.local` not in `.gitignore`
- ⚠️ [Medium] `.env.example` missing

**Dependencies:**
- ❌ [Critical] 2 critical vulnerabilities in `lodash@4.17.20`
- ⚠️ [High] 5 high vulnerabilities in dependencies
- ⚠️ [High] `package-lock.json` missing

**Database & Authentication:**
- ❌ [Critical] Table `public.users` missing RLS
- ❌ [Critical] Service role key found in `src/components/UserList.tsx:45`
- ⚠️ [High] Anon role has write access to `public.posts`

**API & Edge Functions:**
- ⚠️ [High] Missing input validation in `src/api/users.ts`
- ⚠️ [Medium] No rate limiting on `/api/auth/login`

**Logging & Output:**
- ❌ [Critical] Password logged in `src/utils/auth.ts:78` (console.log)
- ⚠️ [Medium] 12 console.log statements in production code

**Configuration:**
- ⚠️ [High] Missing CSP header in `next.config.js`
- ❌ [Critical] CORS configured with wildcard `*` in `src/api/cors.ts`

**Authentication:**
- ⚠️ [High] Password minimum length is 6 (should be 8+)

---
Action Required (Prioritized):
1. [Critical] Remove hardcoded API key from `src/config.ts`
2. [Critical] Enable RLS on `public.users` table
3. [Critical] Remove service role key from client code
4. [Critical] Fix CORS wildcard configuration
5. [Critical] Remove password logging
6. [High] Add `.env.local` to `.gitignore`
7. [High] Fix critical dependency vulnerabilities
8. [High] Add input validation to API routes
9. [High] Add CSP header configuration
10. [High] Increase password minimum length

Full report saved to: /docs/audit/security_audit_MM-DD-YYYY.md
```

---

## Self-Healing (if fix=true)

If `fix=true`, this command will attempt to automatically fix:

1. **Gitignore Entries:**
   - Add missing standard entries (`.env`, `*.pem`, `logs/`, etc.)
   - Append to `.gitignore` if entries are missing

2. **.env.example Creation:**
   - Create `.env.example` template if missing
   - Include placeholder values for all detected environment variables

3. **Dependency Fixes:**
   - Run `npm audit fix` for non-breaking updates (with confirmation)
   - **Note:** Will NOT fix breaking changes automatically

4. **Suggestions Only:**
   - For other issues, provide specific remediation steps
   - **Will NOT:** Remove secrets (requires manual review)
   - **Will NOT:** Fix RLS policies (requires manual review)
   - **Will NOT:** Modify authentication logic (requires manual review)

---

## Manual Verification

**Important:** Automated tools cannot catch all security issues. Always:

1. **Review Checklist:** Manually review `standards/security/security-audit-checklist.md` for logical flaws
2. **RLS Logic:** Deep RLS policy analysis is automatically applied via `.cursor/rules/supabase-rls-policy-review.mdc` when Supabase is detected, but review policy logic manually
3. **Business Logic:** Review authentication/authorization logic for business-specific vulnerabilities
4. **Third-Party Services:** Review API keys and tokens for third-party services
5. **Environment-Specific:** Review production-specific configurations

---

## Integration with Other Commands

### Related Commands

- **`pre-flight-check`** (`.cursor/commands/pre-flight-check.md`) - Quick validation before coding
- **`pr-review-check`** (`.cursor/commands/pr-review-check.md`) - Pre-PR validation (includes basic security checks)
- **`project-audit`** (`.cursor/commands/project-audit.md`) - Full project health check (can include security audit with `deep=true`)
- **`full-project-health-check`** - Run all audits together (includes this command)

### Related Rules (Auto-Applied)

- **`.cursor/rules/supabase-rls-policy-review.mdc`** - Deep RLS policy analysis (automatically applied when Supabase is detected)

### Related Standards

- **`standards/security/security-audit-checklist.md`** - Comprehensive security audit checklist (authoritative source)
- **`standards/security/access-control.md`** - Access control and RLS standards
- **`standards/database/schema.md`** - Database schema conventions

### Related Checklists

- **`standards/security/security-audit-checklist.md`** - Comprehensive security audit checklist

### Integration Points

- This command is referenced in `AGENTS.md` as the **required step** for security-sensitive changes
- Run before PRs that touch security-sensitive code
- Run periodically (weekly/monthly) for active projects
- Included in `full-project-health-check` for comprehensive reviews

---

_This command provides comprehensive security scanning. For deep RLS analysis, the `.cursor/rules/supabase-rls-policy-review.mdc` rule is automatically applied when Supabase is detected._
