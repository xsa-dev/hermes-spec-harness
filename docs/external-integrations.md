# External Integrations

Paperclip-style tools should connect through a Hermes API server or another OpenAI-compatible endpoint when they support external agent/model endpoints. Keep endpoint URLs, credentials, and headers in local configuration, not in this repository.

A webhook bridge is a practical alternative. The bridge can receive events from Paperclip, map them to a constrained Hermes prompt, and return a summarized result. Redact secrets before logging or forwarding webhook payloads.

An MCP bridge is possible only if the deployment direction matches. Some tools may expect Hermes to act as an MCP server, while Hermes may primarily act as an agent/API client depending on setup. Confirm the expected role before building the bridge.

Use no secrets in docs, examples, or distribution files. Prefer local environment configuration and private deployment manifests for real endpoints.
