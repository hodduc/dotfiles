{ config, lib, pkgs, ... }:
{
  config = {
    system.defaults = {
      NSGlobalDomain = {
        InitialKeyRepeat = 12;
        KeyRepeat = 1;
        ApplePressAndHoldEnabled = false;

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;

        "com.apple.swipescrolldirection" = true;
      };

      dock = {
        autohide = true;
        orientation = "right";
        showhidden = true;
        mru-spaces = false;
        persistent-apps = [
          "${pkgs.wezterm}/Applications/WezTerm.app"
          "${pkgs.vscode}/Applications/Visual Studio Code.app"
        ];
      };

      finder = {
        _FXShowPosixPathInTitle = false;
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      menuExtraClock = {
        ShowDate = 1;
        ShowSeconds = true;
      };

      trackpad = {
        TrackpadRightClick = true;
      };

      # NOT WORKING!
      # CustomUserPreferences = {
      #   "com.apple.symbolichotkeys" = {
      #     AppleSymbolicHotKeys = {
      #       "60" = {  # select previous input source (cmd+space)
      #         enabled = true;
      #         value = { parameters = [32 49 1048576]; };
      #       };
      #       "61" = {  # select next input source (cmd+option+space)
      #         enabled = true;
      #         value = { parameters = [32 49 1572864]; };
      #       };
      #       "64" = {  # spotlight search (ctrl+space)
      #         enabled = true;
      #         value = { parameters = [32 49 262144]; };
      #       };
      #       "65" = {  # finder search window (ctrl+option+space)
      #         enabled = true;
      #         value = { parameters = [32 49 786432]; };
      #       };
      #     };
      #   };
      # };
    };

    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
      nonUS.remapTilde = false;
    };

    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
