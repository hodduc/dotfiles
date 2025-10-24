{ config, lib, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # Add newline between prompts
      add_newline = true;

      # Configure the format
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$python"
        "$character"
      ];

      directory = {
        style = "blue bold";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      git_branch = {
        symbol = " ";
        format = "[$symbol$branch]($style) ";
        style = "bright-black";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "cyan";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };

      python = {
        symbol = " ";
        format = "[$symbol$virtualenv]($style) ";
      };
    };
  };
}
