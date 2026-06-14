# Review Prompts

Create change:

```text
Use Hermes Spec Harness. Create an OpenSpec change <change-id> for <goal>. Stop after proposal/specs/tasks.
```

Show spec/tasks:

```text
Show the OpenSpec proposal, specs, and tasks for <change-id>. Do not edit source code.
```

Approve implementation:

```text
Implement only approved OpenSpec change <change-id>. Run verification and report results. Do not commit.
```

Archive:

```text
Archive OpenSpec change <change-id> after verification. Do not commit.
```

Staged diff review:

```text
Review the staged diff against OpenSpec change <change-id>. Report scope drift, missing tests, secret safety issues, and commit readiness.
```
