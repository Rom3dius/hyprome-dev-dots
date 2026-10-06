# Command output

Command output here is condensed to save tokens, keeping every signal and
dropping costly noise. Treat it as the complete result. Truncated results
state their recovery path in their own output. Re-run a command as
`rtk proxy <cmd>` only when its result is unusable: empty when output was
clearly expected, contradicting its exit code, or garbled.

Condensing is skipped for a whole Bash call that contains `$(...)`, a
heredoc, or a `> file` redirect, and for output piped into a further filter
(`cargo test | grep -v`, `cat -n f | head`). So:
- Give `cargo`, `grep`/`rg`, `ls`, `find` and file reads their own call when
  the call would otherwise contain any of the above; run independent calls in
  parallel in one turn. Chaining small commands (`git status`, `git log -3`)
  costs nothing and stays fine.
- Let `cargo test`/`clippy` output through as is instead of piping it into
  `grep` or `tail`; read files with the Read tool or `rtk read`, not `cat -n`
  or `sed -n`.
- Use `jq` rather than `python3` for inspecting JSON.
