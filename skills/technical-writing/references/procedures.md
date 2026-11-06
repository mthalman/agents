# Procedures

Procedural documentation helps readers complete a task.
Tutorials, how-to guides, and contributing guides require different levels of guidance.

## Frame a tutorial

A tutorial guides a learner through a tested exercise.

- State what the learner will build or run.
- List required tools, files, accounts, and prior knowledge.
- Begin with a small result that confirms the environment works.
- Give steps in an order that works from a clean starting point.
- Show an observable result after important steps.
- Choose one working path and follow it throughout the tutorial.
- End with a complete result and a useful next step.

Explain enough to make each step understandable.
Move design history, alternatives, and complete option lists to separate documents.
Test every step from the stated starting point.

## Frame a how-to guide

A how-to guide gives a competent reader a reliable way to complete one task.

- Name the task in the title.
- State the expected result.
- List prerequisites, permissions, and limits.
- Put each condition before the step it affects.
- Include alternate steps only for choices readers are likely to face.
- Include a final verification step.
- Include recovery or rollback steps when failure can leave a partial change.

Keep background information brief.
Link to generated reference or source for complete option lists.

## Frame a contributing guide

A contributing guide helps a developer prepare, change, validate, and submit work to a project.
Write for a developer who understands the programming language and tools and is new to the repository.

Cover the contribution workflow:

- Required tools and supported versions
- Repository setup
- Build, test, and lint commands
- Code generation
- Style and review requirements
- Pull request expectations
- Links to issue, security, and conduct policies

Use exact commands and paths.
State where each command must run.
Show how contributors can verify that setup succeeded.
Move architecture and component-specific procedures to dedicated documents.

## Write the steps

- Write each step as a direct command.
- Give steps in the order readers must perform them.
- Use exact commands, paths, option names, and interface labels.
- Tell readers what output to expect when it confirms progress.
- Explain what an important step changes when the effect is unclear.
- Test the procedure in the environment described by its prerequisites.
