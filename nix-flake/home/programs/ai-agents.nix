{ lib, ... }:

let
  # Global guidance applied to every AI coding-agent session
  guidance = ''
    # Agent Guidance (global)

    Global guidance for AI coding agents on this machine. Repository-specific
    instructions (a repo's `CLAUDE.md` / `AGENTS.md`) take precedence over this.

    ## Operating Constraints

    - **Do not read outside the working directory without permission.** This
      includes circumventing the restriction through bash scripts or any other
      workaround. Before EVERY command/tool that touches a path, check: is the
      target inside the working directory? If a path starts with `~`, `$HOME`,
      `/Users/hodduc/.config`, `/etc`, or any absolute path outside the repo, STOP
      and ask first — do not `cat`/`grep`/`ls`/`find` it. "I need this context to
      diagnose the problem" is NOT an exception; gather it by asking, or have the
      user run it via `! <command>`. Needing the info never overrides this rule.
    - **Do not add global packages without permission** (pip, npm, cargo, etc.).
      This system is managed through Nix, so do not install things arbitrarily —
      keep the system as stateless as possible. If you need to run a Python
      script, it is fine to spin up a disposable environment (e.g. via `uv run`)
      instead.
    - **Keep comments simple and essential.** Do not leave trivial comments or
      comments that merely restate what the code already makes obvious.
  '';

  # config-dir-relative path -> guidance content, per agent.
  targets = {
    ".claude-work/CLAUDE.md" = guidance;
    ".claude-personal/CLAUDE.md" = guidance;
    ".codex-work/AGENTS.md" = guidance;
    ".codex-personal/AGENTS.md" = guidance;
  };
in
{
  home.file = lib.mapAttrs (_: text: { inherit text; }) targets;
}
