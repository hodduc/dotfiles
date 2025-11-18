{ config, pkgs, lib, ... }:

{
  # Remap keys using hidutil
  # - Delete key (0x70000004C) -> backtick/tilde (0x700000035)
  # - CapsLock (0x700000039) -> Left Control (0x7000000E0)
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
              },
              {
                "HIDKeyboardModifierMappingSrc": 0x700000039,
                "HIDKeyboardModifierMappingDst": 0x7000000E0
              }
            ]
          }
        ''
      ];
      RunAtLoad = true;
    };
  };
}
