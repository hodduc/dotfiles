{ lib, ... }:

let
  # Global guidance applied to every AI coding-agent session
  guidance = ''
    # Agent Guidance (global)

    Global guidance for AI coding agents on this machine. Repository-specific
    instructions (a repo's `CLAUDE.md` / `AGENTS.md`) take precedence over this.

    ## Planning and Design

    - For feature or design work, investigate safely discoverable facts before
      asking questions: relevant code, docs, tests, history, configuration, and
      read-only deployment or endpoint state when useful. Summarize concrete
      findings first.
    - Ask only non-discoverable decisions that materially change scope, rollout,
      disclosure, UX, ownership, or architecture. Order questions by downstream
      impact. When genuine alternatives exist, offer 2–3 mutually exclusive,
      substantive options with a recommendation; otherwise state the
      evidence-backed assumption and proceed.
    - Do not manufacture choices for approval checkpoints. Options such as
      “Approve,” “Revise,” “Reconsider,” or “Other” are not meaningful
      alternatives and must not be presented through a multiple-choice request
      tool.

    ## Commit Messages

    - Write commit subjects in the `scope: description` style used by the
      Linux kernel, Go, and Git projects: a short scope (subsystem,
      directory, or component name), a colon, then a concise imperative
      description. Example: `nix-flake: pin mise to avoid cache miss`.
    - NEVER use Conventional Commits prefixes (`feat:`, `fix:`, `chore:`,
      `refactor:`, `feat(scope):`, and the like). When unsure, the default
      on this machine is always `scope: description`.
    - Exception: if a repository's own commit history or contribution docs
      clearly mandate a different convention (e.g. commitlint-enforced
      Conventional Commits), follow that repository's convention instead.

    ## Operating Constraints

    - **Do not read outside the working directory without permission.** This
      includes circumventing the restriction through bash scripts or any other
      workaround. Before EVERY command/tool that touches a path, check: is the
      target inside the working directory? If a path starts with `~`, `$HOME`,
      `/Users/hodduc/.config`, `/etc`, or any absolute path outside the repo, STOP
      and ask first — do not `cat`/`grep`/`ls`/`find` it. "I need this context to
      diagnose the problem" is NOT an exception; gather it by asking, or have the
      user run it via `! <command>`. Needing the info never overrides this rule.
      - **Exception — agent runtime directories.** Reading and writing the
        directories the agent itself needs to operate is always allowed:
        `$CLAUDE_CONFIG_DIR`, `$CODEX_HOME`, `~/.claude*`, `~/.codex*`, and any
        session/scratchpad/temp directory the harness assigns. Skills, memory,
        and agent configuration live there; accessing them is normal operation,
        not a violation of this rule.
    - **Do not add global packages without permission** (pip, npm, cargo, etc.).
      This system is managed through Nix, so do not install things arbitrarily —
      keep the system as stateless as possible. If you need to run a Python
      script, it is fine to spin up a disposable environment (e.g. via `uv run`)
      instead.
    - **Keep comments simple and essential.** Do not leave trivial comments or
      comments that merely restate what the code already makes obvious.
    - **Do not `git push` or create PRs unless explicitly asked.** Local
      commits are fine when appropriate; anything that leaves this machine
      (push, PR, publishing) waits for an explicit request.
    - **(Claude Code only) Do not spawn subagents on the top-tier model
      (fable) unless explicitly asked.** Subagents inherit the parent model
      by default, so pass an explicit model override — use `opus` or
      `sonnet`, never `haiku`. If a task genuinely seems to need fable, ask
      the user first.
  '';

  codexBase = ''
    [features]
    default_mode_request_user_input = true
  '';

  # Home-relative path -> managed agent instructions.
  instructionTargets = {
    ".claude-work/CLAUDE.md" = guidance;
    ".claude-personal/CLAUDE.md" = guidance;
    ".codex-work/AGENTS.md" = guidance;
    ".codex-personal/AGENTS.md" = guidance;
  };

  codexBaseTargets = {
    ".codex-work/config.toml" = codexBase;
    ".codex-personal/config.toml" = codexBase;
  };
in
{
  home.file =
    lib.mapAttrs (_: text: { inherit text; }) instructionTargets
    // lib.mapAttrs (_: text: {
      inherit text;
      force = true;
    }) codexBaseTargets;
}
