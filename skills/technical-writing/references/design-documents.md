# Design and explanatory documents

Explanations, architecture documents, and RFCs help readers understand why a system works as it does or evaluate a proposed change.
They need context, evidence, and clear relationships between decisions and consequences.

## Frame an explanation

Start with a real question or point of confusion.
Define the scope and the knowledge readers need.
Keep the document centered on one subject.

- Describe relevant context and constraints.
- Explain causes and consequences.
- Compare alternatives that were seriously considered.
- State an opinion when it helps readers understand a decision.
- Use diagrams or examples when relationships are hard to explain in prose.
- Link claims to source, measurements, decisions, or other evidence.

Keep procedures in procedural documents.
Keep exact API details in source or generated reference.
Use hand-written reference to help readers find those details.

## Frame an architecture document

Define component responsibilities and important boundaries.
Explain how components communicate and where data or control moves between them.
Describe a data flow when it helps readers understand behavior or make changes safely.
Link to source for details that change often.

State the reason for each important boundary or constraint.
Readers need enough context to preserve the design when they change the system.

## Frame an RFC

An RFC helps reviewers understand a problem, evaluate a proposal, and record a decision.

Include the decision context:

- Status, owners, and review deadline
- Problem statement
- Goals and excluded scope
- Current behavior
- Constraints and requirements
- Evidence about cost, scale, risk, or user impact

Describe proposed behavior and important interfaces.
Explain changes to data, control, deployment, or ownership.
Discuss realistic alternatives and the reason for the proposed choice.
State costs, risks, operational effects, compatibility effects, and unresolved questions.
Identify migration, rollout, rollback, and validation requirements.

Update the RFC after reviewers make a decision.
Record the chosen option, major reasons, and follow-up work.
Keep implementation logs and meeting transcripts outside the RFC.
