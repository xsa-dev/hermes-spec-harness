# Worktree Delegation

Single-agent usage is simplest: one checkout, one OpenSpec change, one commit boundary.

Multi-agent usage should use one worktree per writing agent. Do not run multiple writing agents in the same checkout.

Suggested roles:

- Orchestrator: owns the change scope, integration, and final report.
- Reviewer: checks proposal/specs/tasks and scope drift.
- Tester: verifies commands, coverage, and regression risk.
- Safety auditor: checks secret safety and destructive operations.

Safe pattern:

```bash
git worktree add ../project-fix-auth fix-auth
git worktree add ../project-test-audit test-audit
```

Each worktree should map to one bounded role or change. Reconcile findings through review, not by letting agents overwrite each other.
