# Review and validation

## Match checks to the change

Inspect existing scripts before execution: even a docs build can fetch remote
content, execute components, or write generated files.

| Change | Minimum relevant checks |
|---|---|
| Prose only | Facts, terminology, reader path, links, Markdown mechanics |
| Command or API example | Version-matched source trace, prerequisites, safe targeted execution or existing example test, expected result |
| Default or configuration | Definition and implementation, precedence, affected examples and reference |
| Navigation or page move | Incoming links, anchors, sidebar, published route or redirect |
| MDX or visual material | Existing build diagnostics and inspection in the intended renderer |
| Compatibility or support statement | Published policy and release evidence; distinguish tested from supported |

Inspect every changed example. Run the smallest safe representative checks;
increase coverage for new syntax, version-sensitive behavior, authentication,
or materially different platforms. Do not imply that one environment validates
all variants.

Use existing Markdown and link tooling. When available, use markdown-toolkit
and resolve its helpers from the loaded skill, not the target repository.
Do not introduce a new toolchain merely to validate one document.

## Handle unavailable verification

Distinguish these outcomes:

- Executed: state the command/check, environment, and observed result.
- Source-checked: identify the authoritative evidence; execution did not occur.
- Unverified: identify the missing evidence, access, or environment.
- Not applicable: explain why the check does not apply.

A failed or unavailable check is not a pass. A successful build establishes
only the properties the build checks.

If execution would mutate production, delete data, expose credentials, incur
cost, or run an untrusted installer, do not use it as a documentation check.
Use an authorized disposable environment or existing test double. If neither
exists, report the exact blocked check.

If source evidence conflicts or is unavailable, preserve accurate existing
material, leave the disputed claim unresolved in a draft, and ask for the
minimum decision or evidence needed. Do not silently choose a support promise.

## Review checklist

- Accuracy: changed technical claims have version-matched authoritative evidence;
  examples and validation claims are represented honestly.
- Onboarding: the declared reader has the prerequisites, common path, observable
  result, and relevant recovery directions.
- Findability: priority tasks have descriptive entry links; changed destinations
  and anchors resolve; published routes are preserved.
- Proportionality: each section or page serves a named job without unnecessary
  duplication, taxonomy, or tooling.
- Maintainability: facts have one canonical home where practical; existing
  ownership and behavior-change review cover the affected material.

Record pass or fail from observable evidence. Keep unverified checks explicitly
unverified rather than treating them as passed.

## Maintain the result

Use existing ownership and contribution mechanisms; do not invent an owner.
For behavior changes, inspect affected guides, examples, generated reference,
navigation, and migration notes. Update the applicable surfaces together.

Prefer shared sources or existing checks for facts that repeatedly drift.
Propose additional automation only for a demonstrated recurring problem,
with its scope, maintenance cost, and required authorization.

## Report format

For create or improve work:

- Deliverable or changed paths.
- Reader outcome and reason for structural changes.
- Material source evidence.
- Checks actually performed and their outcomes.
- Unresolved claims and unperformed checks.

For reviews, order findings by reader impact:

Location | Reader problem | Evidence | Smallest repair

Separate correctness problems from stylistic preferences. If no material
findings remain, say so without claiming broader verification than performed.
