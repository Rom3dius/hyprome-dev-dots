---
name: beans-status
description: Show what is left in a beans-tracked repo, grouped by milestone and epic, with blockers and needs-human tags. Use whenever the user asks what beans are open, what is left, what to pick next, or what still needs them, even if they do not say "beans".
---

# beans-status

Answer "what is left" from the tracker, not from memory. Everything comes from `beans query`
because `beans show --json` omits blockers.

1. Pull the open tree in one query:
   ```bash
   beans query --json '{ beans(filter:{excludeStatus:["completed","scrapped"]}) { id title status type tags priority parent { id title } blockedByIds } }'
   ```
   Add `beans list --ready --json` for the unblocked set.
2. Group by milestone, then epic. Mark each task as **ready**, **blocked by <ids>**,
   **in-progress**, **draft** or **needs-human** (tag). An epic or milestone whose children
   are all done but that is still `todo` is itself a to-do: say so.
3. Report in this order: what an agent can start now, what is blocked and on what, what
   only the user can do, what is parked (draft). Put counts in a short table, not prose.
4. If the user asks what to do next, recommend one item and say why (critical path,
   unblocks the most, or smallest).

Do not create or change beans here; that is `beans-plan`. Do not start work; that is
`beans-run`.
