# Hermes Spec Harness

OpenSpec-governed engineering harness for Hermes Agent.

Hermes Spec Harness packages a practical workflow for teams that want Hermes to work from reviewed specs instead of directly changing a codebase. It combines a Hermes profile distribution, a reusable Hermes skill, project `AGENTS.md` rails, OpenSpec schema bundles, bootstrap scripts, and examples.

## Problem Statement

Agentic coding can drift when the workflow is implicit. Large repositories need a stable source of truth, clear review points, safe delegation, and a commit boundary that matches the approved change. Hermes Spec Harness makes those constraints installable and repeatable.

## Why Profile-First Packaging

The repository can be installed as a Hermes profile distribution. Profile mode gives the harness its own identity, configuration, skills, sessions, and runtime state while keeping credentials, user memories, and local machine state outside the published package.

The profile is not a filesystem sandbox. Use worktrees, Docker, a remote terminal backend, or a constrained project cwd when work needs isolation.

## Why Skill-First Packaging Still Matters

The skill can be installed without adopting a full profile. Skill-only mode is portable, easy to inspect, and works with an existing Hermes setup. It keeps the OpenSpec workflow close to the agent without requiring changes to Hermes itself.

## Why OpenSpec Is Source Of Truth

OpenSpec is the source of truth for all non-trivial changes. Source code changes only happen after an OpenSpec change exists, specs/tasks are reviewed, and the implementation scope is approved. Completed changes should be archived before the commit boundary.

## Repository Layout

```text
hermes-spec-harness/
├── distribution.yaml
├── SOUL.md
├── config.yaml
├── README.md
├── install.sh
├── uninstall.sh
├── scripts/init-project.sh
├── templates/AGENTS.md
├── skills/hermes-spec-harness/SKILL.md
├── openspec-schemas/
├── examples/
└── docs/
```

## Installation Mode A: Skill-Only

Skill-only installation:

```bash
./install.sh --verbose
```

The default destination is `~/.hermes/skills/hermes-spec-harness`. Use `--skill-path PATH` to install somewhere else. Use `--force` only when replacing an existing different skill directory is intentional.

## Installation Mode B: Profile Distribution

Profile distribution installation:

```bash
hermes profile install github.com/xsa-dev/hermes-spec-harness --name hsh --alias --yes
hsh chat
```

The profile has its own config, identity, skills, sessions, and runtime state. Secrets and user memories must not be shipped in the distribution. The profile is not a filesystem sandbox; still use worktrees, Docker/remote terminal backend, or constrained project cwd.

## Using Hermes Spec Harness as a profile

Hermes Spec Harness profile = Hermes Agent + OpenSpec workflow + HSH skill + project `AGENTS.md` + safe review/verify/archive discipline. Use it when you want a dedicated OpenSpec-governed engineering agent rather than only a portable skill in an existing profile.

## Uninstall

Preview first:

```bash
./uninstall.sh --dry-run --verbose
```

Then remove the installed skill directory:

```bash
./uninstall.sh --verbose
```

Only the exact `hermes-spec-harness` skill directory is removed.

## Bootstrap A Legacy Project

```bash
./scripts/init-project.sh /path/to/project --default-schema hsh-legacy-audit --allow-external-write --verbose
```

The bootstrap script initializes OpenSpec with `--tools none` when needed, copies the HSH schema bundles into `openspec/schemas/`, configures a default schema safely, and creates `AGENTS.md` from the template when missing.

If the target project already has `.hermes.md` or `HERMES.md`, those files may override `AGENTS.md` and should be reviewed. Existing `AGENTS.md` is preserved unless `--overwrite-agents` or `--force` is provided.

## OpenSpec Schemas

- `hsh-fix`: bounded implementation work after specs/tasks are approved.
- `hsh-investigation`: diagnosis and recommendation without source changes.
- `hsh-legacy-audit`: audit-first onboarding for existing projects with proposal, specs, and tasks.

## Safety And Idempotence

All scripts support `--dry-run`, `--verbose`, and `--help`. They are designed to be idempotent: repeated runs should not duplicate content or rewrite unrelated files. The overwrite policy is safe by default. Existing project files are preserved unless an explicit overwrite flag is passed.

External-write safety is enforced by `scripts/init-project.sh`: a target outside the caller's current working directory is refused unless `--allow-external-write` is provided.

No commits are performed by scripts.

## Connecting To External Tools Such As Paperclip

The primary integration path is a Hermes API server or OpenAI-compatible endpoint if the external tool can target agent/model endpoints. A webhook bridge can translate external events into Hermes prompts. An MCP bridge may be possible, but confirm the direction: Paperclip may expect Hermes to act as an MCP server, while Hermes deployments may primarily act as an agent/API client.

## Testing

```bash
find . -type f | sort
sh -n install.sh
sh -n uninstall.sh
sh -n scripts/init-project.sh
./install.sh --dry-run --verbose
./uninstall.sh --dry-run --verbose
```

For a local bootstrap smoke test, create a temporary git project and run `scripts/init-project.sh` against it. If network access is available, also run:

```bash
npx --yes @fission-ai/openspec@latest schema validate
```

## Publishing

This project is licensed under the Apache License 2.0. See `LICENSE`.

Publish the GitHub repository, optionally publish the Hermes skill, publish the profile distribution entry, and share the OpenSpec schema bundle as a community schema package.
