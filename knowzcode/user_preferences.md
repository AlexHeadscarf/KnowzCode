# User Development Preferences

---

**Purpose:** This document captures your personal development preferences and coding standards. These preferences integrate with KnowzCode's workflow while respecting your style and approach.

**Last Updated:** [ISO timestamp - to be filled during init]
**Source:** User-provided during initialization

---

## Core Principles

[User-provided principles, or "Not configured"]

*Examples:*
- Test-Driven Development (TDD mandatory)
- Immutable data structures preferred
- Functional programming patterns
- Domain-Driven Design (DDD)
- SOLID principles

---

## Testing Approach

[User-provided testing preferences, or "Follows KnowzCode TDD requirements"]

*Examples:*
- **Framework:** XUnit / Jest / PyTest / Playwright
- **Style:** Behavior-driven / Unit-first / Integration-focused
- **Coverage:** Minimum 80% / All public APIs / Critical paths only
- **Patterns:** AAA (Arrange-Act-Assert) / Given-When-Then
- **Mocking:** Moq / Jest mocks / unittest.mock

---

## Code Style

[User-provided style preferences, or "Standard for language/framework"]

*Examples:*
- **Naming:** PascalCase for methods, camelCase for variables
- **Structure:** Small functions (max 20 lines), single responsibility
- **Comments:** Self-documenting code, minimal comments
- **Formatting:** Prettier / Black / Standard formatter
- **Linting:** ESLint / Flake8 / Custom rules

---

## Language-Specific Patterns

[User-provided language-specific preferences, or "N/A"]

*Examples (C#):*
- Nullable reference types always enabled
- Records for immutable DTOs
- No null-suppression operators
- FluentValidation for schema validation

*Examples (JavaScript/TypeScript):*
- Strict TypeScript mode
- Functional components with hooks (React)
- Async/await over promises
- ESM imports

*Examples (Python):*
- Type hints for all public functions
- Dataclasses for structured data
- f-strings for formatting
- PEP 8 compliance

---

## Quality Priorities

[User-provided quality focus areas, or "Standard KnowzCode priorities"]

*Rank your top priorities (1-5):*
1. [e.g., Reliability / Security / Performance / Maintainability / Testability]
2. [...]
3. [...]
4. [...]
5. [...]

---

## Project-Specific Conventions

[Any project-specific rules or patterns, or "See project CLAUDE.md"]

*Examples:*
- Database migrations must be reviewed before merge
- All API endpoints require OpenAPI documentation
- Error handling uses Result types (no exceptions)
- Logging format: structured JSON with correlation IDs

---

## Integration with KnowzCode

**Non-Negotiable (KnowzCode Framework):**
- Test-Driven Development (TDD) is mandatory
- Quality gates must pass at each phase
- Living documentation must be maintained
- Incremental verified progress required

**Flexible (Your Preferences):**
- Testing framework choice (as long as TDD followed)
- Code style and naming conventions
- Language-specific patterns
- Quality priority ranking
- Project-specific conventions

**Conflict Resolution:**
When your preferences conflict with KnowzCode requirements, the framework takes precedence for workflow aspects (TDD, quality gates), but your preferences apply for implementation style (naming, patterns, tools).

---

*This document should be reviewed and updated as project conventions evolve.*
