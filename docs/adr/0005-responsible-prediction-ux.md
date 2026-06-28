# ADR 0005: Responsible Prediction UX

Status: Accepted for v0.2 draft  
Date: 2026-06-29

## Context

The product should not become bland by hiding every negative astrological reading. Users expect an astrologer to say hard things with skill, context, and care.

At the same time, the product must not produce deterministic doom, fear-selling, medical diagnosis, self-harm framing, or professional overreach.

## Decision

Use a two-layer approach:

- The astrologer prompt is instructed to deliver difficult readings constructively, preserving agency.
- A separate evaluator agent/check checks prediction outputs for grounding, tone, fatalism, overreach, and coercion.

The evaluator should repair delivery, not erase negativity by default.

## Consequences

Negative predictions are allowed when grounded and responsibly framed. The system blocks or rewrites only unsafe delivery or prohibited content, not every difficult message.

