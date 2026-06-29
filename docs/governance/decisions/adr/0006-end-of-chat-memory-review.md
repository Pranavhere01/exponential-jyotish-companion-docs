# ADR 0006: End-of-Chat Memory Review

Status: Accepted for v0.2 draft  
Date: 2026-06-29

## Context

Manual memory is the desired default, but asking memory questions in the middle of chat adds friction and can interrupt emotional flow.

## Decision

Manual memory candidates are collected during the session and shown during end-of-chat review or CSAT.

The user can Save, Edit, or Discard candidates after the conversation. Auto mode remains a later, consented, feature-flagged option.

## Consequences

The chat stays smooth while preserving user control. The schema needs a `memory_candidates` queue separate from saved `memory_facts`.

