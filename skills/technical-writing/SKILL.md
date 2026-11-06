---
name: technical-writing
description: >-
  Improve sentence structure, framing, clarity, and precision in technical documentation.
  Use for READMEs, procedures, reference overviews, explanations, architecture documents, and RFCs.
disable-model-invocation: true
---

# Technical writing

Write documentation that helps readers complete a task or understand a subject.
Use these guidelines with judgment.
Keep a natural sentence when a mechanical rewrite would make it worse.

## Select the audience and document type

Before you write, answer these questions:

1. Who will read this?
2. What should they be able to do or understand after reading it?
3. What knowledge can you assume?
4. What type of document will meet that need?

Load the resource for the document you will write or review:

| Document type | Resource |
| --- | --- |
| README | [README files](./references/readmes.md) |
| Tutorial, how-to guide, or contributing guide | [Procedures](./references/procedures.md) |
| Reference overview, command index, or API index | [Reference documentation](./references/reference.md) |
| Explanation, architecture document, RFC, or proposal | [Design and explanatory documents](./references/design-documents.md) |

Load only resources that apply to the current task.
Load more than one resource when a document contains distinct sections for different purposes.

## Write for the audience

Users want to complete a task.
Give them a short path to a useful result and omit implementation details they cannot act on.

Developers may use, integrate, contribute to, maintain, or review software.
Include the technical detail required for their current role.
Use exact types, symbols, paths, and commands when those details help them complete the task.

A document can serve more than one audience.

## Frame the content

- Put purpose and scope near the start.
- State the main point of a section in its first paragraph.
- Give each paragraph one main point.
- Start a paragraph with context that readers already have.
- Introduce new information after the context it depends on.
- Put causes before effects when readers need the cause to understand the result.
- Make relationships explicit with words such as `because`, `if`, and `therefore`.
- Put prerequisites before instructions that depend on them.
- Put common cases before uncommon cases.
- Use sentence-case headings that describe the content below them.
- Use a numbered list for a sequence.
- Use bullets for items with no required order.
- Introduce a list with a complete sentence.
- Keep list items grammatically parallel.
- Use one level-1 heading and do not skip heading levels.
- Use link text that names the destination or subject.
- Keep each section focused on one purpose.

## Structure sentences

- Address the reader as "you" in instructions.
- Use present tense for current behavior.
- Write instructions as commands: "Select **Submit**."
- Name the actor when it matters: "The compiler checks the query."
- Prefer active voice.
- Put the subject and verb close together.
- Put an action near the start of an instruction.
- Put a condition before the action or result it controls.
- Keep one instruction in each sentence.
- Keep one main idea in other sentences.
- Review instructions longer than 20 words and other sentences longer than 25 words.
- Split a sentence when a reader must go back to understand it.
- Prefer common words such as "use" and "help."
- Use one term for one concept.
- Use articles where normal grammar requires them.
- Remove modifiers that add no information.
- Rewrite past participles that make a noun phrase hard to parse.
- Use `will` only for events that occur in the future.
- Remove "please," "simply," "easy," and "quickly" from instructions.
- Replace an `-ing` phrase when it hides who acts, when an action occurs, or how it relates to the sentence.

## Prevent ambiguity

- Put `only`, `not`, and similar words next to the words they modify.
- Break up long groups of nouns.
- Make each pronoun refer to one clear noun.
- Include a verb for each clause.
- Keep words such as `that` when they make sentence structure clear.
- Repeat an article when it distinguishes two items.
- Make the scope of `and` and `or` clear.
- Use a period to separate complete thoughts.
- Avoid a slash when readers could interpret the relationship in more than one way.
- Avoid idioms, metaphors, and Latin abbreviations.

## Use concrete information

- Replace a general claim with a fact, instruction, example, or measurement.
- Include expected output when it helps readers confirm that a step worked.
- Use real paths and commands.
- Keep examples short and complete.
- Verify counts, file trees, generated output, and compatibility claims.
- Include the command that regenerates generated documentation.
- Link to source when copied facts can become outdated.

## Review the result

Apply the `unslop` skill to each document that this skill changes.
If the client cannot invoke `unslop` by name, read [the bundled Unslop skill](../unslop/SKILL.md) and its referenced pattern catalog, then apply those instructions.
Remove filler, promotional language, vague claims, unnecessary hedging, abstract jargon, and meaningless emphasis.

Before you finish, check the document:

1. Does the opening address the primary audience and task?
2. Can readers find prerequisites, steps, facts, and errors where they expect them?
3. Does each section have a clear purpose?
4. Are commands, paths, symbols, and examples correct?
5. Does each term have one consistent meaning?
6. Can any sentence have two reasonable interpretations?
7. Can you remove any sentence without losing useful information?
8. Does the text sound like a person wrote it for this project?

If you find a recurring form of artificial writing that `unslop` does not cover, mention a proposed rule and replacement in your response.
Do not edit the `unslop` skill as part of this task.
