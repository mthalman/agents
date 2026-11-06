# Structure decisions

## Establish the reader contract

Record a short working brief:

- Role and priority job.
- Prior knowledge and terminology that need no introduction.
- Starting environment, permissions, and installed prerequisites.
- Target release and supported deployment or consumption model.
- Observable success condition.
- Secondary readers whose paths differ.

Use the brief to select content, not as a mandatory published section.
For multiple roles, provide recognizable entry links rather than duplicating
shared setup. Do not mistake the contributor's repository setup for installation
instructions for a user of the released product.

## Select the document mode

| Reader need | Mode | Include | Keep elsewhere |
|---|---|---|---|
| Learn an unfamiliar workflow | Tutorial | Controlled sequence, milestones, brief explanations | Exhaustive variants and option catalogs |
| Complete a known task | How-to | Preconditions, actions, relevant branches, success check | General introductory teaching |
| Look up a contract | Reference | Inputs, outputs, defaults, limits, errors, compatibility | Long learning sequences |
| Understand a decision | Explanation | Question, mechanisms, alternatives, tradeoffs | Installation walkthroughs |

A short explanation can support a procedure without becoming another file.
Split when the reader must change goals or assumed knowledge to continue.

## Build the README

Use this order, dropping sections that have no reader value:

1. Name, precise purpose, intended user, and consequential fit constraints.
2. Start: prerequisites, installation or access, smallest useful example,
   and observable result.
3. Next tasks: descriptive links to the priority guides and reference.
4. Important behavior: short limitations or defaults that prevent likely errors.
5. Applicable help, contribution, security-reporting, and license links.

Place a warning before its relevant action even if this changes the order.

For a small tool, inline the useful instructions. When onboarding is extensive,
include a preview and link directly to the maintained starting guide.
Do not place promotional material ahead of the common path.

## Decide whether another document is justified

| Candidate | Add or retain when | Combine or omit when |
|---|---|---|
| Installation | Supported platforms need materially different setup | One short path fits the README |
| Configuration reference | Settings have independent lookup needs or nontrivial precedence | A few options fit beside usage or existing help |
| API reference | A public contract needs direct lookup | Existing generated reference already provides it |
| Troubleshooting | Several recurring symptoms require diagnostic branches | One remedy belongs beside its procedure |
| Explanation | A real design question affects decisions | It repeats an introduction without resolving a question |
| Operations/runbook | Operators have deployment, recovery, or monitoring responsibilities | The audience only consumes a hosted service |
| Migration/compatibility | Supported versions differ or upgrades need action | Only unsupported historical variants would be described |
| Contribution guide | Contributor setup and review differ from product usage | A short existing section is sufficient |

Add security-specific material where authentication, permissions, sensitive data,
trust boundaries, or harmful actions require it. Do not manufacture a security
policy or support commitment.

## Organize and maintain routes

Start with flat, descriptive destinations. Add categories when they represent
recognizable reader tasks, product areas, or roles. Give a category a useful
landing page when readers need orientation, not just another click.

Curate learning order. Generate repetitive reference navigation when the existing
toolchain supports it. Keep every maintained page reachable from an appropriate
entry point; do not rely on search to rescue an orphan page.

Use task labels for guides, public names for reference, and question/topic labels
for explanations. Prefer relative source links within repository documentation;
use the publishing system's supported route mechanism for the site.

Preserve public URLs and useful anchors. Before moving a page, inspect inbound
links, navigation, and the existing redirect mechanism. Seek a decision if a
necessary move would otherwise break a published route.

Version documentation only when readers must choose between meaningfully
different supported contracts. Make the version visible. Reuse shared content
only where it remains correct for every participating version.
