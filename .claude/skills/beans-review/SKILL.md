---
name: beans-review
description: Review a sub-agent's hand-back or a completed bean before accepting it: commit shape, bean hygiene, honest acceptance criteria, real verification, artefacts checked by eye. Use after every agent report when running beans with sub-agents, when the user asks to check or review a bean, and before closing an epic or milestone.
---

# beans-review

An agent's report is a claim. Accept it only after these checks, in this order, cheapest
first. Stop at the first failure and send the agent back with the exact gap.

## 1. Tracker and git

```bash
beans show <id>                       # status completed, every box checked, ## Summary of Changes present
git log --format='%h %s%n%b' -1 <hash>  # subject <type>: ..., body has Bean: <id>, no Co-Authored-By / Claude-Session trailers
git show --stat <hash>                # bean file included; nothing from data/, build output, env files, lockfiles it did not own
git status --short                    # the agent left nothing of its own uncommitted; foreign changes are untouched
```

A box ticked that the report says was not done is a failure, not a nuance. Boxes may be
reworded to what was actually done only with the reason in the same line.

## 2. Verification the agent cannot be trusted with

- Rerun the project's own gate once yourself (`just test`, `cargo test`, `pytest`), reading
  the tool's own pass line rather than a pipeline exit code; a `| tail` has hidden a failing
  test before.
- Hooks are not enough: commit hooks typically run format and lint, while tests, e2e,
  coverage and container builds are pre-push or manual. Keep a per-repo list of what each
  bean type needs (UI bean: run the e2e suite and look at changed screenshots; container
  bean: actually build it; schema bean: run the migration) and run it.
- Anything visual or geometric (screenshots, map overlays, rendered PDFs, charts): open the
  file with the Read tool and judge it. Agents have reported matching baselines that
  overlapped, and fits that were numerically fine on the wrong feature.
- Live-service claims (an endpoint answered, a flow ran, a message arrived): one curl or one
  listing from your side.

## 3. Content review

- Did it change files outside its ownership? If so, were other agents' uncommitted hunks
  kept out of the commit? (Shared files such as `pyproject.toml`, `uv.lock`, a CLI module,
  a README are the usual culprits.)
- Deviations from the brief are fine when explained; silent ones are not. Scope creep that
  is correct stays, with a note in the bean.
- Secrets: nothing real in files or in the report. If the agent printed a secret into the
  transcript, tell the user which one and whether it is a local-only generated value.
- Owner-only findings (needs sudo, a purchase, a live apply) go into the matching
  needs-human bean body as numbered steps, not only into chat.

## 4. After accepting

- Create beans for every recommended follow-up worth keeping and commit them
  (`chore: add beans for ...`). Dropping them is a decision, say so.
- Close epics and milestones whose children are all done, each with a short
  `## Summary of Changes`, in a `chore:` commit. A draft child may stay parked.
- If the agent still has background shells (long runs, wait loops), stop it with TaskStop
  after its final report so it does not keep waking the session.

Report to the user: what was verified by you versus by the agent, what was sent back, and
what is now open.
