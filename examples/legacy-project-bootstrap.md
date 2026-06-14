# Legacy Project Bootstrap

Run the bootstrap from the HSH repository:

```bash
./scripts/init-project.sh /path/to/legacy-project --default-schema hsh-legacy-audit --allow-external-write --verbose
```

Then give Hermes this prompt:

```text
Use Hermes Spec Harness. Create an audit-only OpenSpec change baseline-project-audit for this legacy project. Inspect repository structure, command surfaces, risks, and modernization opportunities. Do not modify source code. Stop after proposal/specs/tasks.
```

Expected files are `openspec/`, copied HSH schemas under `openspec/schemas/`, and `AGENTS.md` if missing. The expected human review step is approval of the audit proposal/specs/tasks before any implementation follow-up.
