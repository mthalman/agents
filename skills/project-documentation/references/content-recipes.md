# Content recipes

Use technical-writing for detailed prose guidance. These recipes define the
project-specific information a reader needs, not mandatory page templates.

## Procedure recipe

Present the following information in this order where relevant:

1. Outcome and scope: what the reader will accomplish and what this does not do.
2. Before starting: runtime/platform, required files, working directory,
   permissions, accounts, network access, and supported credential setup.
3. Common path: ordered actions with exact filenames and commands.
4. Checks: expected evidence after important steps and at completion.
5. Recovery: likely symptoms, diagnostic action, remedy, and escalation route.
6. Next tasks: optional branches and links to deeper reference or explanation.

Place irreversible effects, privilege requirements, data disclosure, and cost
warnings before the affected action. Explain the scope of the effect.

Do not put every conceivable prerequisite on every page. Include what is needed
for the task or link to a shared prerequisite page without hiding it.

## Example contract

For every changed example establish:

- Version and environment, including shell when syntax depends on it.
- Complete inputs or an explicit link to the required starting fixture.
- Exact invocation and required working directory.
- Expected stable result and how the reader checks it.
- Relevant failure behavior and safe recovery.
- Cleanup only for resources created by the example.

Derive commands and outputs from project sources or actual safe execution.
An expected result supported by an inspected test is not a captured execution.

Use input-only, language-tagged blocks for copying. Put output in a separate
text block or clearly marked console transcript. Keep prompt characters out
of copyable commands. Name every placeholder and explain where its value comes
from; do not present a placeholder as an immediately runnable value.

For nondeterministic output, state the invariant and identify variable fields.
Do not require matching timings, generated IDs, ordering, or entire logs unless
the project actually guarantees them.

Prefer existing executable examples and snippet inclusion where already
supported. Do not build an inclusion system solely to avoid a small duplication.

## Behavioral reference recipe

Document a bounded public surface consistently:

| Field | Information |
|---|---|
| Name | Exact public command, option, setting, symbol, or endpoint |
| Contract | Accepted inputs, types, units, output, and side effects |
| Default | Actual default, including context-dependent behavior |
| Resolution | Scope, precedence, override, and persistence when applicable |
| Boundaries | Limits, incompatibilities, errors, and unsupported cases |
| Versions | Introduction, deprecation, or supported-version differences |
| Example | A minimal supported use and an expected result |

Omit fields that do not apply. Reference completeness means covering the chosen
public surface, not documenting internal implementation details.

Use a hand-written overview to map capabilities to public commands, APIs, or
components and link each entry to exact details and examples. Keep exact
signatures, overloads, exhaustive option lists, schemas, and default tables in
generated reference when available. Include the project's existing command for
regenerating that reference. When generation is unavailable, verify necessary
exact details against source rather than inventing a generation toolchain.
Explain relationships and surprising behavior that generation does not capture.

Qualify performance and reliability claims with evidence and conditions.
Do not convert a local benchmark, dependency capability, or passing test into
an unconditional product guarantee.

## Select presentation features

| Feature | Use when | Avoid |
|---|---|---|
| Code block | Exact syntax or copyable input matters | Screenshots of commands; unexplained fragments |
| Table | Readers compare parallel facts or look up fields | Long procedures or paragraphs squeezed into cells |
| Screenshot | Visual state or UI location is the subject | Making it the only source of instructions or results |
| Diagram | Relationships, state transitions, or boundaries need spatial explanation | Decorative architecture pictures |
| Tabs | Alternatives are mutually exclusive, such as supported shells | Hiding prerequisites or required sequential steps |
| Admonition | A consequence or exceptional condition deserves interruption | Repeated notes that compete with the main path |
| MDX/live component | Interaction demonstrates a real concept and existing tooling supports it | Introducing a renderer dependency for ordinary prose |
| Collapsible detail | Supplementary explanation would interrupt the path | Hiding required actions, warnings, or success criteria |

Give images descriptive alternatives and diagrams a textual explanation.
Keep screenshots free of secrets and private data. Check narrow-screen and
keyboard behavior for interactive material in the intended renderer.
