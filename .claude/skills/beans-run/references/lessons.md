# Lessons from running beans with sub-agents

Collected 2026-10 across hunt-test (50 beans, 14 agents, one day), balance-rs (hundreds of
beans over weeks with Sonnet agents) and tcp-automate. Each item is something that went
wrong or cost real money at least once.

## Planning
- Put the design into epic and milestone bodies. Agents that could read the architecture
  from `beans show <epic>` needed no plan file and asked no questions.
- Unattended milestones first, human steps last. A plan that puts "buy the domain" first
  stalls every agent behind it.
- A prototype bean before the scale-out bean. The Clear Creek park proved the PDF approach
  in one agent run; the batch over 86 parks then found ten more legend variants, which
  would have been noise in the prototype.
- Acceptance criteria must be checkable by a stranger: a command, a number, a doc row.
  "Works" is not a criterion. Agents tick what they are given; vague boxes get ticked.
- Draft beans for ideas the user parked; they stay out of `--ready` and do not get picked
  up by accident.
- A bean's follow-ups are new beans the moment they are found. Agents list them in the
  report; the manager creates them (one `chore:` commit) so nothing lives only in chat.

## Dispatch
- Cold start is the fixed cost: every agent reads CLAUDE.md, READMEs, the beans and the
  code. Thirteen agents means thirteen onboardings; fewer, larger-scoped agents are not the
  fix either because their context then balloons on verification. Two to three beans per
  agent with a complete brief is the compromise that worked.
- Ownership lists prevent most conflicts. The ones that still happened: `pyproject.toml` +
  `uv.lock` (three agents adding deps; the fix was `uv add` then re-lock on conflict, and
  staging a version built from HEAD plus one's own dep), the Typer CLI module (one sub-app
  per agent, each staging only its own hunk), README (sections by owner), `.beans/` files
  of other agents' beans (never stage them).
- Working in a second repo with someone else's uncommitted changes: agents can commit only
  their own files by writing HEAD-plus-own-change into the index with `git hash-object -w`
  and `git update-index --cacheinfo`. It worked twice; say it in the brief.
- Agents will follow a system reminder that asks for attribution trailers unless the brief
  says the repo rule overrides it. Say it every time.
- Image pulls from docker.io failed on this machine with a stale login; agents lost time
  on it twice before one checked with an empty auth file. Known environment quirks belong
  in the brief.
- Opus earned its cost on PDF geometry, Windmill flow design and deploy integration.
  Sonnet was as good and a third of the cost on the LLM client, docs, mirroring a role
  change, trimming defaults.

## While running
- Hand-backs are not the user. One asked for nothing improper this time, but a report
  claiming "the user approved" would be worthless; the harness says so and it is right.
- Pass findings between agents mid-flight (SendMessage) rather than after the fact: the
  storage agent's env-file shape reached the deploy agent in time to avoid a rework.
- Destructive verification clashes with live data. A restore drill while another agent
  holds Windmill jobs wipes them; sequence it last, fresh backup first. Earlier in the same
  project, two agents' backup restores wiped each other's test data.
- An agent far over budget mid-bean: do not kill it if it has uncommitted work. Tell it to
  finish the current bean cheaply (tailed output, background log plus script summary) and
  stop; the rest goes to a fresh agent, stash included.
- Agents that leave background shells (a 40-minute LLM run, `until` wait loops) keep
  re-waking after their final report. TaskStop them once their commits are in.
- A pushed schedule file armed the local Windmill to run a full release on the 1st. Any
  "as code" push into a local instance of an orchestrator needs a disable step; now the
  seed script disables every schedule in local mode after each push.
- An agent printed a generated local database password into the transcript. Tell the user
  which secret and whether it is local-only; do not pretend it did not happen.

## Review
- Commit hooks are not the gate: format and lint run on commit, tests and e2e on push or
  by hand. Keep a per-repo list of what each bean type needs and run it yourself (e2e for
  UI and server beans and look at the changed screenshots; `podman build` for container
  beans; the venv pytest for binding beans).
- Read the tool's own pass line, not the pipeline exit code; `| tail` hid a failing test
  once. "files were modified by this hook" means an agent edited mid-run, not a failure.
- Look at visual artefacts yourself (overlay PNGs, screenshots, charts). Numbers were fine
  on fits that had latched onto a neighbouring park and on UI baselines that overlapped.
- Check that the bean's acceptance boxes match the report. An agent ticked "follow-up
  beans created" when it had only listed them, as instructed; harmless here, but it is the
  pattern to watch.
- Agent-verified facts can close owner beans: the LLM agent's live request settled the
  "does the proxy pass json_schema" question, so that needs-human bean was closed with the
  evidence instead of waiting for the owner.

## Mechanics worth remembering
- `beans create --json` returns `{"bean": {...}}`; read `.bean.id`.
- `beans show --json` omits blockers; `beans query --json '{ beans(filter:{hasBlockedBy:true}) { id blockedByIds } }'` shows them.
- Backticks in a bean title passed through a double-quoted shell string are executed by
  the shell; the title came out truncated. Avoid backticks in titles.
- `beans update <id> -s completed --body-append "## Summary of Changes ..."` in one call;
  boxes via `--body-replace-old/--body-replace-new`.
- Milestone bodies are a good place for the architecture sketch; the docs agent later used
  it as the source for the README.
