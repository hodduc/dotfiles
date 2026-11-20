{ config, lib, ... }:

let
  claudeCmd = profile: "CLAUDE_CONFIG_DIR=${config.home.homeDirectory}/.claude-${profile} DISABLE_AUTOUPDATER=1 command claude";
  codexCmd = profile: "CODEX_HOME=${config.home.homeDirectory}/.codex-${profile} command codex --profile local";

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

    ## Delegation

    This section applies to the top-level agent of a session. If you were
    spawned by another agent, ignore it: do the work you were given directly
    and do not spawn further agents.

    - **You are the orchestrator, not the implementer.** Your tokens are the
      most expensive ones in the loop, and the usage budget for your model is
      the one that runs out. Spend them on what a cheaper model cannot do as
      well: understanding the request, investigating, deciding the design,
      writing the spec, and verifying the result. Hand the implementation to
      subagents on a cheaper model.
    - **Delegate implementation by default.** Once you know what to change
      and can state it as a spec, delegate the editing, even when you could
      do it quickly yourself. "This is easy" is the reason to delegate, not
      the reason to keep it. This overrides any harness guidance that favors
      doing work inline or says not to spawn when in doubt.
    - **Keep it yourself only when** the change is smaller than the brief
      would be (roughly one file and under 30 lines), or when the work is a
      debugging loop whose every step needs your judgment.
    - **Never spawn a subagent on your own model**, unless explicitly asked.
      Subagents inherit the parent model by default, so the model has to be
      chosen explicitly. Use one tier below yours for multi-file or subtle
      work, and two tiers below for mechanical edits.
    - **(Claude Code) Use the `implementer` and `implementer-hard` agent
      types**, whose models are pinned in their definitions: `implementer`
      for mechanical or well-specified edits, `implementer-hard` for
      multi-file or subtle work. If you use any other agent type for
      implementation, pass an explicit model override, never `haiku`.
    - **Write briefs that stand alone.** The subagent has none of your
      context. Give it the goal, the files, the decisions you already made
      (interfaces, names, behavior), what not to touch, and the commands that
      show it is done.
    - **Run independent pieces in parallel**, in separate worktrees when
      they could touch the same files.
    - **Verify the result yourself.** Read the diff and run the checks; do
      not accept the subagent's report as evidence. Send corrections back to
      the same subagent instead of fixing them yourself, unless the fix is a
      few lines. If a subagent fails the same task twice, move it up one
      tier or take it over; do not keep retrying.
  '';

  # Claude Code subagent definitions. The model is pinned here so that
  # delegation does not depend on the parent passing an override.
  implementerPrompt = ''
    You implement a spec written by an orchestrating agent. The orchestrator
    has already investigated and decided the design; your job is to carry it
    out exactly.

    - Follow the brief. Do not redesign, widen the scope, or refactor code
      the brief did not mention.
    - If the brief is ambiguous, contradicts the code, or cannot work as
      written, stop and report that instead of guessing.
    - Run the checks the brief names before reporting. If none are named, run
      whatever the repository uses for the files you touched.
    - Do not commit, push, or spawn further agents unless the brief says to.
    - Report what you changed (files and a one-line summary each), the exact
      commands you ran with their results, and anything you skipped or could
      not verify. Say plainly when something failed.
  '';

  claudeAgent = { name, description, model }: ''
    ---
    name: ${name}
    description: ${description}
    model: ${model}
    ---

    ${implementerPrompt}
  '';

  claudeAgents = {
    implementer = {
      model = "sonnet";
      description = "Implements a spec that is mechanical or fully specified, where the brief states the files, the change, and the checks.";
    };
    implementer-hard = {
      model = "opus";
      description = "Implements a spec that spans several files or needs judgment in the details, such as subtle logic, concurrency, or code the brief could not fully pin down.";
    };
  };

  codexBase = ''
    [features]
    default_mode_request_user_input = true

    [sandbox_workspace_write]
    network_access = true
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
    // lib.listToAttrs (lib.concatMap (profile:
      lib.mapAttrsToList (name: agent:
        lib.nameValuePair ".claude-${profile}/agents/${name}.md" {
          text = claudeAgent ({ inherit name; } // agent);
        }
      ) claudeAgents
    ) [ "work" "personal" ])
    // lib.mapAttrs (_: text: {
      inherit text;
      force = true;
    }) codexBaseTargets;

  # Each agent also gets the other agent's command for the same profile,
  # which the cross-review skills read from CODEX_CMD / CLAUDE_CMD.
  programs.zsh.shellAliases = {
    claude = "echo 'Use claude-work or claude-personal instead.' && return 1";
    codex = "echo 'Use codex-work or codex-personal instead.' && return 1";
  } // lib.listToAttrs (lib.concatMap (profile: [
    (lib.nameValuePair "claude-${profile}" "CODEX_CMD=${lib.escapeShellArg (codexCmd profile)} ${claudeCmd profile}")
    (lib.nameValuePair "codex-${profile}" "CLAUDE_CMD=${lib.escapeShellArg (claudeCmd profile)} ${codexCmd profile}")
  ]) [ "work" "personal" ]);
}
