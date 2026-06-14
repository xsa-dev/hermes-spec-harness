---
name: hermes-spec-harness
description: OpenSpec-governed engineering harness for Hermes Agent
version: 0.1.0
author: Hermes Spec Harness
license: Apache-2.0
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [openspec, workflow, profile-distribution, engineering-governance, codex, worktrees]
---

# Hermes Spec Harness

Use this skill when a Hermes Agent should work from OpenSpec changes, maintain clean commit boundaries, and avoid direct source edits before review.

## What This Skill Is

Hermes Spec Harness is an OpenSpec-governed engineering workflow. It provides rules, prompts, bootstrap patterns, and safety checks for projects where specs are source-of-truth.

## When To Use It

Use it for non-trivial fixes, investigations, legacy audits, refactors, feature additions, and delegated engineering work. For tiny read-only questions, answer directly without creating an OpenSpec change.

## Golden Workflow

1. Create or select an OpenSpec change.
2. Write proposal/specs/tasks.
3. Stop for human review.
4. Implement only the approved scope.
5. Verify with documented commands.
6. Archive the completed OpenSpec change.
7. Commit exactly one change when the human asks.

## Never Rules

- no code before OpenSpec change.
- one-change-one-commit.
- secret safety: never print or commit secrets, tokens, `.env` values, authorization headers, private keys, or private endpoints.
- worktree rules: use worktrees for parallel agents or risky experiments.
- delegation rules: delegate only bounded roles with clear ownership and no overlapping write scope.

## Standard Prompt Patterns

Create change:

```text
Use Hermes Spec Harness. Create an OpenSpec change for <goal>. Stop after proposal/specs/tasks.
```

Review spec/tasks:

```text
Review the OpenSpec change <change-id> for scope, acceptance criteria, verification, and secret safety. Do not edit source code.
```

Implement approved scope:

```text
Implement only the approved OpenSpec change <change-id>. Run verification and report results. Do not commit.
```

Archive:

```text
Archive completed OpenSpec change <change-id> after verification. Do not commit unless asked.
```

## Delegation Roles

Use bounded roles such as spec reviewer, test auditor, docs/examples auditor, and safety auditor. Each role should produce concise findings and avoid unrelated edits.

## Worktree Rules

Use one worktree per writing agent. Do not let multiple agents modify the same checkout. Keep each worktree tied to one change id and reconcile only after review.

## Legacy Project Bootstrap Pattern

Run `scripts/init-project.sh` with `--default-schema hsh-legacy-audit`. Ask Hermes to create an audit-only OpenSpec change named `baseline-project-audit` and stop after artifacts.

## Investigation-Only Pattern

Use `hsh-investigation` when no source changes are allowed. Collect evidence, redact secrets, classify the issue, and recommend follow-up work.

## Fix Pattern

Use `hsh-fix` for bounded fixes. Keep expected files, acceptance criteria, verification, archive plan, and no-commit confirmation explicit.

## Verification Pattern

Record every command, its result, and any skipped reason. If a failure is caused by missing network or unavailable tooling, keep the repository intact and report the blocker exactly.

## Pitfalls

- Starting code edits before a reviewed OpenSpec change exists.
- Mixing cleanup, dependency upgrades, and feature work in one change.
- Printing secrets in logs or examples.
- Treating profile mode as a filesystem sandbox.
- Delegating overlapping write scopes.

## Profile Distribution Mode

As a profile distribution, HSH has its own config, identity, skills, sessions, and runtime state. It ships no secrets or user memories and still requires worktrees or other isolation for filesystem safety.
