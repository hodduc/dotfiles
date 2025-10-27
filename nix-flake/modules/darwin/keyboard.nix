{ config, pkgs, lib, ... }:

{
  # Remap Delete key to backtick/tilde using hidutil
  # This creates a launchd user agent that runs on login
  launchd.user.agents.keyboard-remap = {
    serviceConfig = {
      ProgramArguments = [
        "/usr/bin/hidutil"
        "property"
        "--set"
        ''
          {
            "UserKeyMapping": [
              {
                "HIDKeyboardModifierMappingSrc": 0x70000004C,
                "HIDKeyboardModifierMappingDst": 0x700000035
              }
            ]
          }
        ''
      ];
      RunAtLoad = true;
    };
  };
}
