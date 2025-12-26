{ config, lib, pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default.keybindings = [
      {
          key = "cmd+[";
          command = "-editor.action.outdentLines";
          when = "editorTextFocus && !editorReadonly";
      }
      {
          key = "cmd+]";
          command = "-editor.action.indentLines";
          when = "editorTextFocus && !editorReadonly";
      }
      {
          key = "cmd+[";
          command = "workbench.action.navigateBack";
          when = "canNavigateBack";
      }
      {
          key = "ctrl+-";
          command = "-workbench.action.navigateBack";
          when = "canNavigateBack";
      }
      {
          key = "cmd+]";
          command = "workbench.action.navigateForward";
          when = "canNavigateForward";
      }
      {
          key = "ctrl+shift+-";
          command = "-workbench.action.navigateForward";
          when = "canNavigateForward";
      }
      {
          key = "cmd+i";
          command = "composerMode.agent";
      }
    ];

    profiles.default.userSettings = {
      "explorer.excludeGitIgnore" = true;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "editor.tabSize" = 4;
      "files.exclude" = {
          "**/generated" = true;
      };
      "files.trimTrailingWhitespace" = true;
      "git.blame.statusBarItem.enabled" = true;
      "git.blame.editorDecoration.enabled" = true;
      "editor.formatOnSave" = false;
      "[java]" = {
        "editor.defaultFormatter" = "redhat.java";
      };
    };

    profiles.default.enableUpdateCheck = false;
    profiles.default.enableExtensionUpdateCheck = false;
  };
}
