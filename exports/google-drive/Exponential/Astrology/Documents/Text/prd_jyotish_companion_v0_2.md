# Product Requirements Document v0.2

Project: Exponential - Jyotish Companion  
Status: Draft v0.2  
Date: 2026-06-29  
Source of truth: Git repository first; Drive/HTML/PDF are exports.

## 0. What Changed Since v0.1

This revision folds in PM decisions from the review on 2026-06-29:

- The product should use a model router so we can plug and play multiple chat, embedding, evaluator, and extraction models.
- The likely model strategy is open-source/open-weight Chinese models first, validated through evals and routed behind the gateway.
- Manual memory remains the default, but memory confirmation should happen at the end of the chat during the CSAT/review moment instead of interrupting the live conversation.
- The product should not gatekeep every negative prediction. It should deliver difficult or cautionary readings like a skilled astrologer: grounded, calm, specific, non-coercive, and never doom-framed.
- Compatibility/Kundali matching is still out of V1, but the data model should stay generic enough for any future multi-subject analysis, not just marriage.
- Git/GitHub is the durable source of truth. Google Drive is a shared export and collaboration surface, not the only canonical copy.

## 1. Product Vision

Jyotish Companion is a personal AI astrologer grounded in the user's computed Vedic chart and their remembered life context.

The product has two kinds of intelligence:

- Deterministic intelligence: chart math, dashas, divisional charts, yogas, doshas, compatibility calculations, and other formal computations. These are produced by code or rule engines, not guessed by an LLM.
- Generative intelligence: conversational explanation, synthesis, memory extraction, tone, narrative, and user guidance. This is where LLMs help.

The golden rule remains: the AI can interpret chart facts, but it cannot invent chart facts.

## 2. Goals and Success Metrics

### Product goals

- Let a user go from signup to a first chart-grounded conversation in under 3 minutes.
- Deliver guidance that feels personal, chart-grounded, specific, and emotionally intelligent.
- Preserve user agency while still allowing serious or cautionary astrological readings.
- Build a model/provider-flexible foundation, with open-source/open-weight model validation as the default path.
- Keep future feature additions backward-compatible.

### Metrics

Early indicators:

- Onboarding completion rate: >= 75%.
- Time to first astrologer reply: <= 3 min median.
- First-session CSAT: target to be calibrated in beta; start with >= 4.0 / 5.
- Per-message thumbs-up rate: >= 80%.
- Chart computation accuracy versus fixtures: >= 99.9% on validation set.

Lagging indicators:

- D7 retention: >= 25%.
- D30 retention: >= 12%.
- Average sessions per active user per month: >= 4.
- Manual memory candidate acceptance rate: target to be calibrated in beta.
- Free to paid conversion among engaged users: >= 5%.
- Safety incident rate: approximately 0 for genuinely harmful responses.

Metric correction: because Manual memory is the default, "Manual or Auto opt-in rate" is not a useful standalone metric. Better memory metrics are candidate acceptance rate, saved memories per active user, memory-screen edits/deletes, and Manual retained after onboarding.

## 3. Users and Personas

### The Seeker

Believes in astrology and faces a real decision: career, relationship, marriage, money, health worry, family timing, or life transition.

Needs: specific, empathetic, grounded guidance that does not feel generic.

### The Curious

Exploring their chart and personality through astrology.

Needs: easy onboarding, beautiful chart explanations, and low-pressure exploration.

### The Regular

Returns repeatedly and treats the astrologer as an ongoing advisor.

Needs: memory, continuity, and consistent interpretation across sessions.

### Internal Ops/Quality Reviewer

Reviews quality, safety, model behavior, and feedback.

Needs: traces, eval results, model versions, prompt versions, safety labels, and replayable examples.

## 4. Scope

### V1 in scope

- Auth and account basics.
- Birth-data capture.
- Deterministic Vedic chart computation.
- Chart Facts Sheet.
- Interpretive Profile generated once per chart version and regenerated only when model/persona versions change.
- Visual chart rendering and a downloadable report.
- Conversational astrologer grounded in chart facts and temporal context.
- Manual memory default, with end-of-chat memory review.
- Feedback and CSAT.
- Safety and responsible prediction UX.
- LLM/model router and observability.
- Provider-neutral embeddings and model catalog.
- Git-versioned prompts, docs, schema, evals, and ADRs.

### V1 out of scope

- Voice.
- Compatibility/Kundali matching between two charts.
- Human astrologer marketplace.
- Muhurta, prashna, and advanced services beyond conversational Q&A.
- Push notifications.
- Full monetization storefront.

### Deferred / V2+

- Voice astrologer.
- Compatibility/Kundali matching.
- Family charts and other multi-subject analyses.
- Proactive dasha/transit notifications.
- Human expert escalation.
- Regional language expansion.
- Specialized paid analyses.

## 5. Core User Flows

### 5.1 Onboarding

1. User creates account.
2. User enters birth details.
3. Backend computes chart deterministically.
4. System generates Chart Facts Sheet.
5. System generates Interpretive Profile asynchronously.
6. User sees chart and starts chat.

### 5.2 Chat

1. User asks a question.
2. Orchestrator loads chart facts, temporal context, relevant memories, and recent conversation.
3. Astrologer uses tools for exact data when needed.
4. Model router selects the configured model for the task.
5. Astrologer answers with grounded, balanced guidance.
6. Evaluator checks the answer for safety, grounding, tone, and prediction-delivery quality.
7. Answer streams or is shown after any required repair.
8. Candidate memories are collected silently for end-of-chat review.

### 5.3 End-of-chat review

At session end or during CSAT:

1. User rates the session.
2. User optionally gives feedback.
3. If Manual memory is on, the UI shows proposed memories from the session.
4. User can Save, Edit, or Discard each proposed memory.
5. Saved memories become available for future sessions.

This avoids interrupting the live conversation with memory prompts.

## 6. Functional Requirements

### 6.1 Chart and grounding

R-CHART-01 MUST compute the chart server-side using deterministic chart logic.

R-CHART-02 MUST store chart outputs immutably with engine version, ayanamsa, house system, and chart schema version.

R-CHART-03 MUST expose a compact Chart Facts Sheet for grounding the model.

R-CHART-04 MUST validate chart computation against golden fixtures before launch and before engine changes.

R-CHART-05 SHOULD compute temporal context at conversation time.

### 6.2 Model router and provider strategy

R-MODEL-01 MUST route all model calls through a model gateway/router.

R-MODEL-02 MUST support different models for different jobs: runtime astrologer, profile synthesizer, memory extractor, evaluator, embeddings, and moderation/safety.

R-MODEL-03 MUST record provider, model, version, route key, prompt version, token usage, latency, cost estimate, and fallback outcome for every model call.

R-MODEL-04 MUST make chat models and embedding models independent choices. Claude/OpenAI/open-source chat models do not require a matching embedding provider.

R-MODEL-05 SHOULD validate open-source/open-weight Chinese models as the default candidate path, including Qwen, DeepSeek, Kimi, GLM, and successor models, subject to license, hosting, quality, latency, and safety checks.

R-MODEL-06 MUST allow fallback routing to another self-hosted or hosted model if the selected model fails, regresses, or becomes uneconomical.

R-MODEL-07 MUST allow routing policy changes by configuration, not schema rewrite.

PM decision: yes, build the router. It is the correct way to keep model strategy flexible.

### 6.3 Embeddings

R-EMB-01 MUST NOT hard-code `vector(1536)` into domain tables.

R-EMB-02 MUST store embeddings separately from domain records and record the embedding model/dimension that generated each vector.

R-EMB-03 MUST add model-specific vector indexes only after the embedding model is chosen.

R-EMB-04 MUST support re-embedding if the provider changes.

### 6.4 Memory

R-MEM-01 MUST support Off, Manual, and Auto memory modes.

R-MEM-02 MUST default to Manual.

R-MEM-03 MUST treat memories as user-asserted facts, never chart facts.

R-MEM-04 MUST collect candidate memories during chat without interrupting the chat.

R-MEM-05 MUST show Manual-mode memory candidates at end-of-chat alongside CSAT/session review.

R-MEM-06 MUST let users Save, Edit, or Discard each candidate.

R-MEM-07 MUST allow memory review, edit, delete, export, and full erasure.

R-MEM-08 SHOULD support Auto later, behind feature flags and consent.

### 6.5 Responsible prediction UX

R-PRED-01 MUST allow difficult, cautionary, or negative readings when they are grounded in chart facts, dasha/transit context, or reviewed Jyotish doctrine.

R-PRED-02 MUST NOT omit negative material simply to keep the experience positive.

R-PRED-03 MUST present difficult readings as tendencies, periods, risks, or areas needing care, not as unavoidable doom.

R-PRED-04 MUST avoid claims of death, terminal illness, self-harm inevitability, catastrophe, or irreversible curse-like fate.

R-PRED-05 MUST avoid medical diagnosis, legal advice, and specific financial directives.

R-PRED-06 MUST avoid fear-selling and coercive remedies.

R-PRED-07 MUST use an evaluator agent/checker for generated predictions before delivery or immediately before finalizing the streamed answer.

R-PRED-08 MUST also include prompt-level behavior instructions for the astrologer persona. The best UX is evaluator plus prompt, not one or the other.

R-PRED-09 SHOULD support "exalted astrologer" tone: direct, compassionate, precise, and agency-preserving.

PM decision: the system should not gatekeep negativity. It should gatekeep ungrounded, harmful, exploitative, or fatalistic delivery.

### 6.6 Jyotish knowledge base / RAG

R-KNOW-01 MUST store Jyotish sources with provenance.

R-KNOW-02 MUST split sources into reviewable chunks.

R-KNOW-03 MUST label chunks by topic, tradition/source, confidence, and delivery risk.

R-KNOW-04 MUST allow reviewed negative/challenging chunks to be retrieved when they are relevant.

R-KNOW-05 MUST NOT treat "approved" as "positive only."

R-KNOW-06 MUST block or transform content that violates hard safety boundaries: death prediction, self-harm framing, terminal diagnosis, coercive fear-selling, or professional overreach.

R-KNOW-07 MUST log which knowledge chunks influenced an answer.

R-KNOW-08 SHOULD keep raw unreviewed source material out of direct user-facing retrieval until reviewed, but internal evaluators/researchers may inspect it.

PM decision: curate for provenance and delivery quality, not for artificial positivity.

### 6.7 Compatibility and future analyses

R-ANALYSIS-01 MUST model future analyses generically as versioned analysis runs.

R-ANALYSIS-02 MUST allow one or more subjects/charts per analysis.

R-ANALYSIS-03 MUST store deterministic results separately from AI narrative explanations.

R-ANALYSIS-04 MUST support compatibility/Kundali matching later as one analysis type, not as the entire schema center.

R-ANALYSIS-05 SHOULD support future analyses such as muhurta, family charts, relationship guidance, career timing, and specialized paid reports.

R-MATCH-01 SHOULD support deterministic two-chart compatibility in V2, including Ashtakoot/Guna Milan and Manglik compatibility if chosen.

R-MATCH-02 SHOULD present compatibility as score, breakdown, interpretation, and optional report.

R-MATCH-03 MUST keep compatibility grounded in computed data, not LLM guesses.

R-MATCH-04 MUST present relationship difficulty constructively rather than as a doom verdict.

## 7. Open-Source Chinese Model Validation

The plan to validate open-source/open-weight Chinese models is sound, but it should be treated as a model strategy, not a blind commitment to one model family.

Candidate families to evaluate:

- Qwen: strong open-weight family with tool-use and multilingual claims.
- DeepSeek: strong reasoning/cost-performance candidate, subject to model license and hosting validation.
- Kimi: agent/tool-use oriented candidate, subject to license and serving validation.
- GLM: multilingual open model family, useful as an additional benchmark candidate.

Evaluation gates:

- Groundedness: does it stick to chart facts and tool outputs?
- Tool use: can it reliably call chart, dasha, memory, and knowledge tools?
- Prediction tone: can it deliver hard readings without doom or coercion?
- Language: English first; Hindi and regional-language path later.
- Domain language: does it handle Jyotish terms without fabricating?
- Latency: first token and full response under target.
- Cost: hardware/inference cost versus quality.
- Hosting: self-hosting complexity, GPU availability, quantization path.
- License: commercial use, model restrictions, redistribution limits.
- Privacy: whether PII can remain in our infrastructure.
- Fallback: whether the router can move traffic away if quality drops.

Decision: validate open-source/open-weight Chinese models behind the model router. Do not couple the product to any single model before evals pass.

## 8. Safety and Ethics

The safety posture is not "never say anything negative." The safety posture is "never harm the user with ungrounded certainty, fear, professional overreach, or fatalism."

Hard limits:

- No self-harm advice or astrology response to crisis content.
- No death, terminal illness, or catastrophe prediction.
- No medical diagnosis or treatment directive.
- No specific financial trading/investment instruction.
- No legal advice.
- No fear-selling remedies.
- No unavoidable curse framing.

Allowed:

- "This period may feel heavier for work and responsibility."
- "Relationship compatibility shows friction points around communication and family expectations."
- "Health topics should be handled gently; use the chart as reflection, not diagnosis."
- "This is a cautionary period for impulsive financial decisions; slow down and consult a professional."

Not allowed:

- "This marriage is doomed."
- "You will die / your relative will die."
- "You will get a terminal illness."
- "Buy this remedy or disaster will strike."
- "Put all your money into this trade."

## 9. Data and Schema Direction

The v0.2 schema base should include:

- `model_catalog` for model/provider metadata.
- `model_routes` for router configuration.
- `model_eval_runs` for model validation results.
- `text_embeddings` for provider-neutral embeddings.
- `memory_candidates` for end-of-chat Manual memory review.
- `knowledge_sources` and `knowledge_chunks` with safety/delivery labels.
- `analysis_types`, `analysis_runs`, and `analysis_run_subjects` for future extensibility.

The schema should not include hard-coded embedding dimensions in domain tables.

## 10. GitHub and Documentation SOP

The Git repository is the source of truth.

Required folders:

- `docs/` for PRD, system design, PM guides, and ADRs.
- `db/` for schema and migrations.
- `prompts/` for versioned prompts.
- `evals/` for fixtures and rubrics.
- `.github/` for PR templates and review workflow.

Google Drive structure:

- `Exponential / Astrology / Documents / Html` holds HTML exports.
- `Exponential / Astrology / Documents / Text` holds Markdown/text exports.

Rule: Drive files are exports or stakeholder-readable copies. Git remains canonical.

## 11. Decisions to Close Next

- D1: astrology engine build/buy/hybrid.
- D2: app stack and mobile path.
- D3: confirm Manual memory default and end-of-chat memory review.
- D4: launch languages.
- D5: model router candidate list, including open-source Chinese model shortlist.
- D6: monetization model.
- D7: one thread vs multiple chat threads.
- D8: V1 chart depth.
- D9: unknown birth time handling.
- D10: responsible prediction policy threshold.
- D11: knowledge curation workflow and reviewer owner.

## 12. External Validation Notes

- Qwen model family reference: https://github.com/QwenLM
- DeepSeek model family reference: https://github.com/deepseek-ai
- Kimi model family reference: https://github.com/MoonshotAI
- GLM model family reference: https://github.com/THUDM

These sources validate that an open-source/open-weight Chinese model path is plausible. They do not replace product-specific evals, license review, hosting-cost review, or safety validation.
