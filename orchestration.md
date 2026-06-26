# Agent Orchestration

**Caveman:** the main Claude Code session is the foreman. It never lays bricks itself — it points each specialist at their job, then merges the results. Subagents are one level deep (they can't hire their own helpers).

## The roster (9)
architect-reviewer · implementer · test-writer · manual-qa · qa-runner · api-qa · reviewer · devops · docs

## The pipeline (sequential first)
```
architect-reviewer            (plan honors the ADRs?)
        |
   implementer                (write the code)
        |
 test-writer + manual-qa       (automated tests + written test cases)   <- parallel later
        |
 qa-runner + api-qa            (run suites + run API/contract tests)     <- parallel later
        |
    reviewer                   (review the diff: correctness/security)
        |
  devops + docs                (ship plumbing + update docs)             <- parallel later
```
Start fully sequential (predictable, cheaper). Promote the bracketed pairs to parallel once the loop feels natural. The main session always merges in one place.

## Least privilege (the core rule)
- Read-only: architect-reviewer, reviewer.
- Bash/read only (run, don't write): qa-runner, api-qa.
- Write code: implementer, test-writer, devops.
- Markdown only: manual-qa, docs.
- MCP scoping: github → reviewer/devops; playwright → qa-runner; postgres → implementer/qa.

## Extension axis
Knowledge → Skill · Context → Subagent · Capability → MCP. Build the cheapest thing that moves the axis.
