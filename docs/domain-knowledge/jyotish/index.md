# Jyotish Domain Knowledge

Status: Draft v0.1
Date: 2026-06-30
Owner: Product + AI Quality

This area is reserved for reviewed Jyotish knowledge that can later support the `domain_knowledge` graph scope.

## Day-One Rule

Do not put raw source dumps directly into user-facing retrieval.

The flow remains:

1. Store raw source provenance.
2. Break source material into reviewable chunks.
3. Label chunks by topic, tradition/source, confidence, safety, and delivery policy.
4. Allow reviewed difficult material when relevant.
5. Block or transform prohibited delivery.

## Planned Substructure

```text
docs/domain-knowledge/jyotish/
  index.md
  sources/          # source maps and provenance notes
  reviewed-chunks/  # reviewed excerpts or summaries when approved for docs
  doctrine-map.md   # topic taxonomy and relationship map
```

Only create the subfolders when there is real content to place there.

## Retrieval Policy

Reviewed chunks may include challenging or cautionary material. The review process is not a positivity filter.

Every retrievable item should eventually map to:

- `knowledge_sources`
- `knowledge_chunks`
- `delivery_policy`
- `context_graph_nodes`
- `context_graph_edges`
- `context_graph_evidence`

## Prohibited Use

Do not use domain knowledge to bypass the responsible prediction evaluator.

Do not treat doctrine as deterministic chart fact.

Do not store user-specific memory or birth data in this docs folder.
