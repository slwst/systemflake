---
name: openspec-to-epic
description: Turn an OpenSpec change (openspec/changes/<change>/) into a beads epic with session-sized child beads wired by dependencies, ready for herdr-agents to work through. Use when the user asks to plan, break down, schedule, or create beads/an epic for an OpenSpec change, or after /opsx:propose when the change is approved.
---

<!-- Installed by devflake-init; rerunning it overwrites this file. -->

# OpenSpec change -> beads epic

The epic replaces the change's `tasks.md` as the unit of execution: agents work the beads, never
the task checkboxes. The OpenSpec artifacts stay the source of truth for *what* to build.

## 1. Read the change

```bash
openspec list                          # pick the change; ask if it is ambiguous
openspec show <change>                 # or read the files directly
```

Read all of `openspec/changes/<change>/`: `proposal.md`, `design.md`, every `specs/**/spec.md`,
and `tasks.md`. Note open questions in the design; resolve them with the user before creating
beads, or record the decision you will make in the bead that hits it.

Check for an existing epic first, so a rerun does not duplicate it:

```bash
bd list --all --type epic --label spec:<change> --json | jq -r '.[] | "\(.id) \(.status) \(.title)"'
```

## 2. Design the work graph

Group `tasks.md` into children, each **one agent session**: one coherent change an agent can
implement, test with `nix flake check`, and merge on its own, typically a few hundred lines
touching one area. Merge trivially small tasks; split anything an agent could not finish and
verify in one sitting.

For each child decide:

- **Title**: imperative, specific ("Session-loading middleware, /api/me and /auth/logout").
- **Description**: the files or packages it touches, the behaviour to implement, the spec
  requirements/scenarios it satisfies (by name), and the decisions already made. Agents start
  each bead with a cleared context, so the description plus the epic must be enough to start.
- **Acceptance**: how it is verified, ideally tests that run under `nix flake check`.
- **Blocks**: which other children must be merged first. Add a dependency only when the work
  truly needs the other's code; every unnecessary edge removes parallelism.

Aim for a graph with some width (independent children ready at once) rather than one long
chain, and put shared foundations (types, config, dependencies, migrations) first. Any change
to the project's dependency lockfiles belongs in an early child, since later children build on
it and parallel lockfile edits conflict.

Show the user the proposed graph (titles, one-line scope, dependencies) and confirm before
creating it.

## 3. Create the beads

```bash
epic=$(bd create "<change>: <one-line summary>" -t epic -l spec:<change> --spec-id <change> --silent \
  -d "Implement the <change> OpenSpec change: <summary of the outcome>.
Source of truth: openspec/changes/<change>/{proposal.md,design.md,specs/...}. Read design.md before starting.
Do NOT tick openspec tasks; this epic replaces tasks.md.
Child beads are sized to fit a single session each; follow dependency order via bd ready.")

c1=$(bd create "<title>" --parent "$epic" --silent -d "<description>" --acceptance "<how verified>")
c2=$(bd create "<title>" --parent "$epic" --deps blocked-by:"$c1" --silent -d "..." --acceptance "...")
# several blockers: --deps blocked-by:$c1,blocked-by:$c2
```

Children inherit the epic's labels. Priorities default to 2; raise the foundations if the user
wants them first.

## 4. Verify and hand off

```bash
bd show "$epic"                        # children and their dependencies
bd ready --parent "$epic"              # what agents can start now (the graph's first wave)
bd blocked --parent "$epic"
```

Fix any child that is ready but should not be, or blocked by the wrong bead (`bd dep add`,
`bd dep remove`). Then propose scheduling, with N = the graph's useful width (rarely more than
3-4):

```bash
herdr-agents spawn N --preset bd-epic --var epic=<epic-id> --loop --rm-on-empty
```

Spawn only once the user confirms. After the epic closes and its work is merged, the change is
archived with `/opsx:archive <change>`.
