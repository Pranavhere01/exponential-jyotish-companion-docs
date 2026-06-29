# ADR 0003: Extension-Ready Analysis Model

Status: Accepted for schema v0.2 base  
Date: 2026-06-28

## Context

Compatibility and Kundali matching are planned examples, but the product may add or pivot into many analysis types: family charts, relationship guidance, muhurta, career timing, regional reports, or non-astrology advisory products.

Adding a special table for every future idea too early would make the schema brittle.

## Decision

Use a generic, versioned analysis layer:

- `analysis_types` defines what kind of analysis is being run.
- `analysis_runs` stores one computed run, including algorithm version, deterministic result, optional narrative output, model/prompt versions, and safety policy version.
- `analysis_run_subjects` links an analysis to one or more subjects/charts with roles such as `primary`, `partner`, `child`, or `candidate`.

Specialized tables or views can be added later only when a use case becomes stable enough to deserve them.

## Consequences

V1 remains simple. V2 can add compatibility or other multi-chart features without a migration rewrite. The same pattern also supports persona regeneration after model/persona upgrades because outputs are versioned rather than overwritten.

