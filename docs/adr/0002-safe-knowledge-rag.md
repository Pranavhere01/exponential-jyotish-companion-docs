# ADR 0002: Reviewed Jyotish Knowledge Retrieval

Status: Accepted for schema v0.2 base  
Date: 2026-06-28

## Context

The product needs grounded Jyotish explanations, including difficult or cautionary readings. The PRD safety section forbids harmful certainty, coercion, medical/legal/financial overreach, and crisis mishandling. Raw classical or report-style Jyotish text may contain material that is useful when reframed and harmful when repeated verbatim.

## Decision

Jyotish reference material must be reviewed and labeled before user-facing retrieval.

Knowledge must pass through a review path:

- `knowledge_sources` stores provenance for books, reports, expert notes, or internal doctrine.
- `knowledge_chunks` stores reviewable chunks with topic, safety, confidence, and delivery labels.
- Reviewed negative/challenging chunks may be retrieved when relevant.
- "Approved" does not mean "positive only."
- Chunks that require careful framing carry a delivery policy such as `allow_caution` or `transform_required`.
- Raw unreviewed chunks stay out of live retrieval until reviewed.
- Output evaluator checks still run after retrieval and generation.

## Consequences

RAG becomes a controlled library, not an unfiltered dump and not a positivity filter. This protects the product while still allowing serious, cautionary, and authentic Jyotish readings.
