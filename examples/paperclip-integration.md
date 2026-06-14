# Paperclip Integration

Use an OpenAI-compatible endpoint when Paperclip can target an external model or agent endpoint. Configure URLs and credentials locally outside this repository.

A webhook bridge can receive Paperclip events, redact payloads, create constrained Hermes prompts, and return summarized results.

An MCP bridge may be useful, but check the role direction first. Paperclip may expect Hermes to act as an MCP server, while Hermes may primarily operate as an agent/API client depending on deployment.

Do not place secrets in docs, examples, distribution files, or committed config. Use private deployment notes for real endpoints.
