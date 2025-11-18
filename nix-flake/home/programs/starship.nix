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
        "$fill"
        "$kubernetes"
        "$aws"
        "$line_break"
        "$python"
        "$character"
      ];

      directory = {
        style = "blue bold";
        truncation_length = 0;
        truncate_to_repo = false;
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

      kubernetes = {
        disabled = false;
        format = "[\\(](cyan bold)[$context](blue bold)[:](cyan bold)[$namespace](cyan bold)[\\)](cyan bold) ";
        detect_files = [];
        detect_extensions = [];
        detect_folders = [];
      };

      aws = {
        disabled = false;
        format = "[$symbol($profile )(\\($region\\) )]($style)";
        symbol = "☁️  ";
        expiration_symbol = "💥 ";
        style = "bold yellow";
        region_aliases = {
          "us-east-1" = "use1";
          "us-west-2" = "usw2";
          "ap-northeast-2" = "apne2";
        };
      };

      fill = {
        symbol = " ";
      };
    };
  };
}
