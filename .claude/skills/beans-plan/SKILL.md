---
name: beans-plan
description: Turn a request, a plan or a research result into a beans tree (milestone -> epic -> task) with acceptance criteria, blockers and needs-human tags, then commit it. Use whenever the user asks to create beans, add beans, record todos or follow-ups as beans, break a plan into beans, or says "put everything into beans", and also at the end of a planning session before any code is written.
---

# beans-plan

The bean tree is the hand-off to future agents, so write it as if the reader has only the
repo and the beans, never this conversation. Design notes go into bean bodies, not into a
plan file.

## Shape

- **Hierarchy:** milestone -> epic -> task | bug | feature. Epics are containers, never
  worked on directly. Keep one epic per area of the codebase so parallel agents do not
  share files (pipeline module, deploy, site, docs, another repo).
- **Unattended first.** Anything needing the user (accounts, purchases, emails to third
  parties, phones, remote hosts, applying to a live box, approving results) goes to a
  separate epic tagged `needs-human`, ordered last. Milestones before it must be completable
  by an agent on this machine against placeholders or local stand-ins (MinIO for S3,
  Mailpit for SMTP, localias for TLS).
- **Task size:** one agent should finish a task in one sitting with at most two or three
  files of blast radius. A prototype or spike is its own task with "prove it on one case"
  acceptance, placed before the tasks that depend on it.
- **Body of every task:** `Goal:` (what and where, with file paths), `Acceptance criteria`
  as `- [ ]` items that are checkable without the author (tests pass, a command's output,
  a number, a doc row), `Notes` (facts verified so far, URLs, gotchas). Owner tasks get a
  numbered step list the user can follow.
- **Body of every epic and milestone:** the design that applies to all children:
  architecture sketch, decisions the user made with the date, constraints, verified facts.
  Agents read the epic before the task.
- **Follow-ups found during work are beans immediately**, with the finding verbatim and the
  commit or agent that found it. Low priority is fine; losing them is not.

## Mechanics

- Create with `beans create --json "Title" -t <type> -p <prio> --parent <id> --tag <tag> -d "$body"`
  and read the id with `jq -r .bean.id` (the JSON wraps the bean). Never put backticks in a
  title passed through a double-quoted shell string; the shell runs them.
- Blockers: `beans update <id> --blocked-by <other>`; prefer blocked-by on the dependent
  task. `beans show --json` does not display blockers; verify with
  `beans query --json '{ beans(filter:{hasBlockedBy:true}) { id blockedByIds } }'`.
- Drafts (`-s draft`) for parked ideas the user said not to pursue; they stay out of
  `--ready`.
- When a script creates many beans, capture ids in an associative array and print
  `key=id` lines at the end; dry-run the first create to see the JSON shape.
- Finish with `beans check`, then one commit containing only `.beans/`:
  `chore: add beans for <topic>` with a body naming the milestone or epic ids. Re-planning,
  re-parenting and blocking changes are also `chore:` commits.
- Other repos touched by the plan get their own beans in their own `.beans/` and a pointer
  epic here naming those ids.

## Before you say done

Run `beans-status`'s query and read it as a stranger: can each ready task be started
without asking anyone? Does every needs-human task say exactly what the user must do and
where the result goes? Then report the tree with ids and the commit hash.
