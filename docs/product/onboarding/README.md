# Onboarding And Auth Mockups

Status: Draft v0.1

Owner: Product
Source of truth: PRD v0.2, especially sections 1, 2, 4, 5.1, 6.1, 6.4, and 6.5.

This folder holds user-facing onboarding mockups for Jyotish Companion.

## Current Artifacts

- [Onboarding Auth Flow v0.1](onboarding-auth-flow-v0.1.html)

## Flow Covered

1. Welcome screen with a medium Jyotish Companion logo, Create Account, and Login.
2. Auth screen with Email/Phone Number, Password, Continue with Google, and Continue with Apple.
3. One-time onboarding intro with four screens:
   - deterministic chart computation;
   - chart-grounded and memory-aware conversation;
   - responsible prediction delivery;
   - manual memory review and user control.
4. Birth-data capture screen:
   - Name;
   - Birth Date;
   - Birth Time;
   - Place of Birth.
5. Primary CTA routes to a main homepage preview.

## Product Rationale

The PRD goal is to let a user go from signup to a first chart-grounded conversation in under three minutes. The mockup keeps the onboarding short and makes the first required data step obvious: birth details are needed before the product can compute a chart.

The four intro screens are not generic marketing slides. Each maps to a core product promise:

- chart facts are computed deterministically, not guessed by an LLM;
- the astrologer answers with chart facts, relevant memory, and conversation context;
- difficult readings are allowed but must be grounded and non-fatalistic;
- memory is Manual by default, with user review at the end of chat.

## Prototype Notes

The HTML prototype uses local browser storage to simulate "intro shown once." After the user finishes or skips the intro, later auth actions route directly to birth-data capture. Use the Reset intro demo button on the home screen to replay the intro.

The prototype does not implement real authentication, chart computation, or geocoding. Production should compute the chart server-side and should not allow the runtime astrologer to invent chart facts.
