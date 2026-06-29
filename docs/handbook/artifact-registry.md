# Artifact Registry

Status: Draft v0.1
Date: 2026-06-30
Owner: Product + Engineering

The artifact registry is the machine-readable index for graph ingestion.

Canonical registry file:

- [`artifact-registry.yaml`](artifact-registry.yaml)

Use this registry to give every durable source-of-truth artifact a stable ID, type, scope, owner, lifecycle status, and relationship map.

## How To Use

When adding or changing a durable artifact:

1. Add or update the artifact under the right domain.
2. Add or update its row in `artifact-registry.yaml`.
3. Use relation names from [Relation Types](relation-types.md).
4. Update [Version Manifest](version-manifest.md) if the artifact is current source of truth.
5. Run `scripts/verify_artifacts.sh`.

## Ingestion Rule

The registry should be treated as a graph seed, not as duplicate prose. Keep the prose in canonical docs and keep the registry focused on IDs, ownership, paths, and relationships.
