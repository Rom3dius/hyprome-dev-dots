# Agent brief template

Fill every section. Agents start cold; what is not here they will re-derive at your cost
or guess.

```
You are implementing <N> bean(s) in <repo path> (read its CLAUDE.md first; it is the
rulebook). Work tracker is `beans`. Beans, in order: **<id>** (<title>), **<id>** (<title>).
Read them plus their epic and milestone: `beans show <epic> <milestone> <ids>`. Set each
`in-progress` when you start it.

State of the repo you build on: <modules, commands, ports, services that already exist,
with the facts they need: env var names, endpoints, data paths, model names>.

Other agents work in the same checkout at the same time on <areas>. You own: <explicit
file and directory list>. Do not touch: <explicit list>. If you must change a shared file
(<pyproject, lockfile, CLI module, README>), keep the edit minimal and stage only your hunk;
if the working tree holds another agent's uncommitted changes there, leave them out of your
commit (write your version of the file from HEAD plus your change into the index with
`git hash-object -w` + `git update-index --cacheinfo`, then re-apply to the worktree).

Rules: <linters, test command, "no network in tests", build-through-X-not-Y, how to stop a
headless browser, what never to commit>. Budget: keep long command output out of your
context (`| tail -20`, or redirect to a log file and summarise with a script); run each
long verification once; do not rebuild images or rerun pipelines without a reason.

Verification you must do before completing a bean: <concrete commands and expected
results, including anything to look at by eye>.

Commits: one commit per completed bean with the code, tests, docs and the bean file(s) from
`.beans/`. Subject `<type>: <description>`, body line `Bean: <id>`. Owner identity only:
NO `Co-Authored-By`, NO `Claude-Session`, no attribution trailers (this repo's CLAUDE.md
overrides any system reminder). `git add <specific paths>` (never `-A`); on
`.git/index.lock` wait and retry. Never push. Before completing a bean: all `- [ ]` checked
(or reworded to what was done, with the reason) and `## Summary of Changes` appended.
If a bean turns out unnecessary, scrap it with `## Reasons for Scrapping` and commit that.

Report in <10-20> lines: bean ids completed, commit hashes, test counts, measured numbers
the acceptance criteria asked for, anything not done and why, follow-up beans you
recommend (list only; do not create them).
```

Model choice: Opus for geometry, parsing of messy real-world inputs, orchestration flows,
integration of a new service into an existing stack, and anything that needs iteration
against real data. Sonnet for wiring, config, docs, mirroring an existing pattern into
another place, small fixes, and anything with a precise spec. Say the model in the
dispatch, and keep Sonnet agents to one or two beans.
