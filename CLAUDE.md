# Project Instructions for AI Agents

This file provides instructions and context for AI coding agents working on this project.

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:1105d646 -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

**Architecture in one line:** issues live in a local Dolt DB; sync uses `refs/dolt/data` on your git remote; `.beads/issues.jsonl` is a passive export. See https://github.com/gastownhall/beads/blob/main/docs/core-concepts/sync-concepts.md for details and anti-patterns.

## Agent Context Profiles

The managed Beads block is task-tracking guidance, not permission to override repository, user, or orchestrator instructions.

- **Conservative (default)**: Use `bd` for task tracking. Do not run git commits, git pushes, or Dolt remote sync unless explicitly asked. At handoff, report changed files, validation, and suggested next commands.
- **Minimal**: Keep tool instruction files as pointers to `bd prime`; use the same conservative git policy unless active instructions say otherwise.
- **Team-maintainer**: Only when the repository explicitly opts in, agents may close beads, run quality gates, commit, and push as part of session close. A current "do not commit" or "do not push" instruction still wins.

## Session Completion

This protocol applies when ending a Beads implementation workflow. It is subordinate to explicit user, repository, and orchestrator instructions.

1. **File issues for remaining work** - Create beads for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **Handle git/sync by active profile**:
   ```bash
   # Conservative/minimal/default: report status and proposed commands; wait for approval.
   git status

   # Team-maintainer opt-in only, unless current instructions forbid it:
   git pull --rebase
   git push
   git status
   ```
5. **Hand off** - Summarize changes, validation, issue status, and any blocked sync/commit/push step

**Critical rules:**
- Explicit user or orchestrator instructions override this Beads block.
- Do not commit or push without clear authority from the active profile or the current user request.
- If a required sync or push is blocked, stop and report the exact command and error.
<!-- END BEADS INTEGRATION -->


## Build & Test

_Add your build and test commands here_

```bash
# Example:
# npm install
# npm test
```

## Architecture Overview

_Add a brief overview of your project architecture_

## Conventions & Patterns

_Add your project-specific conventions here_

<!-- BEGIN DEVFLAKE (managed by devflake; devflake-upgrade refreshes it, edit outside this block) -->
## Development environment (devflake)

The devshell comes from the `devflake` flake input. `nix develop` (or direnv) provides the
project's toolchain plus `bd` (beads), `openspec`, `claude`, `herdr` and `herdr-agents`, and gives
the project a workspace in the herdr session (attach with `herdr`).

- Workflow: an OpenSpec change (`openspec/changes/<change>/`) becomes a beads epic with a
  dependency graph of session-sized children (the `openspec-to-epic` skill), which agents work
  through in parallel (`herdr-agents spawn N --preset bd-epic --var epic=<id> --loop`).
- devflake moves with `nix run github:slwst/devflake#upgrade [REF]`, not a hand edit of the
  `devflake` input in `flake.nix`: it also refreshes this block and the devflake skills.
- `nix flake check` is the gate before merging: it runs the tests and linters offline in the Nix
  sandbox. `nix build` builds the project.
- Nix only sees files git tracks: `git add` new files before `nix build` or `nix flake check`.
- Agents in `.worktrees/<name>` claim and release beads with `herdr-agents claim|release`,
  deliver work with `herdr-agents merge`, and never commit `.beads/`.
- Beads is published, not private scratch. Bead text and `bd remember` memories share one
  database that `bd dolt push` replicates to the project's remote, often the code remote and
  possibly public; no flag withholds memories from a push, and a push ships history, so editing
  or deleting a row later does not unpublish it. Keep credentials, tokens, customer data and
  private hostnames out of beads — reference where a value lives, never the value.
- Publish beads the first time with `bd dolt push`, which creates `refs/dolt/data` on the remote;
  `bd sync` fails until it exists. Use `bd sync` thereafter: it pulls, checks for conflicts and
  pushes with retry, so it copes with another replica having moved the remote.
- `bd update --notes` **replaces** a bead's notes; use `--append-notes` to add to them.
- The herdr session is shared with every other devflake project open on the host, each in its own
  workspace, and herdr scopes nothing within a session. Panes outside this repository's workspaces
  are not yours: check `worktree.repo_root` in `herdr workspace list` before acting on a pane.
- The herdr tooling belongs to devflake. Project-specific agent presets go in
  `.herdr/prompts/<name>.md` (they shadow built-in presets of the same name), and notes for
  the captain tab in `.herdr/captain.md`.
<!-- END DEVFLAKE -->
