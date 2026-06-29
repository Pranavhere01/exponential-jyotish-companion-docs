1. can we not build a model router that supports both that gives us flexibility to plug and play any model we like?

2. Instead of increasing friction when chat is being done, we can ask the memory questions at the end of the chat during csat collection.

3. Safe version
Knowledge is curated before use
Sources are stored with provenance.
Chunks get safety labels.
Only approved chunks reach user-facing answers.

A.We can have those predictions flagged by an additional evaluator agent
OR
B. WE can have system prompt set in a way that warns for caution but in an acceptable manner.
Think and let me know what would be better ux, the idea here is for the agent to not omit negative predictions but prepare the user for them like an exalted astrologer would.

Approve
Only safe chunks are retrievable


I am against this, we cannot gatekeep negativity.

Against this thought as well

Answer to "we will find a way to better manufacture predictions": yes, but manufacture them through deterministic chart engines, curated doctrine, repeatable evals, and versioned analysis outputs. Do not let the LLM freestyle predictions from raw text.

We will be using opensource chinese models, that is my plan validate that.

PM takeaway: marriage matching is a useful example, but the product base should support "any analysis involving one or more subjects." That keeps us pivot-friendly.

Completely agree

Edit and enhance the PRD, giving you access to my google drive docs in the shared folder Exponential@google-drive 

Read and setup on githubPRD ADDENDUM v0.2 — COMPATIBILITY / KUNDALI MATCHING (MARRIAGE)

Project: Exponential — Jyotish Companion
Status: Draft addendum to PRD v0.1 · authored 2026-06-28
Scope decision: OUT of V1. Planned for V2. The data model is ready as of schema v0.2, so this can be turned on later without a migration rewrite.

Note: the PRD is a Google Doc and the Drive connector can't edit a Doc's body in place, so this addendum holds the exact surgical changes. Fold it into PRD v0.2 at the next full revision.

----------------------------------------------------------------------
NEW REQUIREMENTS
----------------------------------------------------------------------

R-MATCH-01 — Two-chart compatibility (SHOULD, deferred).
The system can compute a deterministic marriage-compatibility result ("Kundali Milan" / Guna-Milan) between two birth charts — including the Ashtakoot 36-guna score and Mangal/Manglik-dosha compatibility. Like the natal chart, this is computed math, never the LLM's guess.

R-MATCH-02 — Match-subject profiles (SHOULD, deferred).
A user can create and save additional birth profiles (e.g. a prospective partner) that are distinct from their own primary profile, and run a match against them. (Generalizes the existing multi-profile requirement R-DATA-07.)

R-MATCH-03 — Deterministic + grounded (MUST, when shipped).
The match is computed by the engine, stored immutably (same lifecycle as the chart), and the astrologer is grounded in the stored result. The astrologer never invents or recomputes a compatibility score.

R-MATCH-04 — Presentation + tone (MUST, when shipped).
The match is presented as a headline score + a per-koota breakdown + an optional downloadable report. The astrologer may discuss it conversationally, but framed constructively and non-fatalistically — no "this marriage is doomed" verdicts. (Bound by the existing safety section 8 / R-SAFE-02.)

R-MATCH-05 — Reuse for future multi-chart features (COULD).
Other relationship / family / multi-person analyses reuse the same match_subject profile + compatibility_matches infrastructure rather than inventing new tables.

----------------------------------------------------------------------
POINTERS TO EXISTING PRD SECTIONS (edits to apply at next revision)
----------------------------------------------------------------------

- Section 4.2 Out of scope (V1): keep matchmaking out of V1, but note it is now data-model-ready.
- Section 4.3 Deferred: the "compatibility / kundali matching" line is now backed by concrete requirements (R-MATCH-01..05) and schema support.
- Section 6.2 DATA: add that birth profiles carry a kind — self (the account owner, exactly one active) vs match_subject (others; can be many).
- Section 14 Roadmap: compatibility moves from "someday" to "planned V2, data model already in place."

----------------------------------------------------------------------
WHAT CHANGED IN THE DATABASE (schema v0.2) TO SUPPORT THIS
----------------------------------------------------------------------

- New compatibility_matches table: links two charts (A and B), stores the deterministic breakdown (match_object JSONB), the headline score (total_points / max_points), Manglik compatibility, a grounding facts-sheet, and an optional rendered report. Same gold/immutable pattern as the chart.
- birth_profiles.profile_kind (self | match_subject | other). The "one active profile per user" rule is now "one active self profile per user," so match subjects don't collide with it.
- Supporting enums: profile_kind, match_method (ashtakoot / dashakoot / other), match_status.

V1 behaviour is unchanged — every addition is forward-compatible.[https://docs.google.com/document/d/1VPToQ3lFlEzFHqlQH32Mja-QIYNYxoZu0oq-J_DVipw/edit?tab=t.0](https://docs.google.com/document/d/1VPToQ3lFlEzFHqlQH32Mja-QIYNYxoZu0oq-J_DVipw/edit?tab=t.0)

Referenced pasted text files:
- pasted text file: /Users/pranavkumar/.codex/attachments/53b9dfb4-5ef0-4894-9fdb-f044f59b562f/pasted-text-1.txt. Read this file before continuing.
- pasted text file: /Users/pranavkumar/.codex/attachments/53b9dfb4-5ef0-4894-9fdb-f044f59b562f/pasted-text-2.txt. Read this file before continuing.

Referenced image files:
- [Image #1]: /Users/pranavkumar/.codex/attachments/53b9dfb4-5ef0-4894-9fdb-f044f59b562f/image-1.png
- [Image #2]: /Users/pranavkumar/.codex/attachments/53b9dfb4-5ef0-4894-9fdb-f044f59b562f/image-2.png
- [Image #3]: /Users/pranavkumar/.codex/attachments/53b9dfb4-5ef0-4894-9fdb-f044f59b562f/image-3.png