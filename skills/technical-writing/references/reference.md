# Reference documentation

Reference documentation helps humans and coding agents discover what a system can do and where to find exact details.
It provides a map of capabilities, concepts, commands, formats, and public entry points.
Readers should not need to scan the entire codebase to learn what is available.

## Answer discovery questions

A reference overview should help readers answer these questions:

1. What can this system do?
2. Which component, command, or API supports that capability?
3. When should I use it?
4. Where can I find exact details and examples?
5. Which limits or compatibility requirements affect my choice?

Group content by capability, domain, or another concept that readers already know.
Use exact names so readers and agents can search for the corresponding source.

## Organize for lookup

- Use stable headings for repeated entries.
- Put the same kind of information in the same order for each entry.
- Use tables when readers need to compare capabilities or options.
- Include terms that readers are likely to search for.
- Link related capabilities and concepts.
- Link each overview entry to a guide, generated reference, or source entry point.

## Keep hand-written reference focused

Record information that helps readers choose a feature and find its entry point:

- Purpose
- Common uses
- Main inputs and results
- Important limits
- Compatibility requirements
- Common failure conditions
- Links to examples and exact details

Keep exact signatures, overloads, complete option lists, field-by-field schemas, and default tables in generated output when possible.
Avoid copying facts that readers and agents can get directly from source.
Hand-written reference should add organization, context, and links.

## Generate exact details

Generate detailed API reference from code, schemas, command metadata, or existing doc comments.
Link generated output from the hand-written overview.
Include the command that regenerates the output.
Keep generated reference consistent with supported versions.

Writing and maintaining source comments requires its own workflow.
This skill does not cover source comments or doc comments.
