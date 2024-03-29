local wezterm = require 'wezterm';

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

return {
  use_ime = true,
  send_composed_key_when_left_alt_is_pressed = false,
  send_composed_key_when_right_alt_is_pressed = false,
  font = wezterm.font_with_fallback({
    "Noto Sans Mono",
    "JetBrains Mono",
    "NanumBarunGothic",
    "AppleGothic",
  }, {stretch="Normal"}),
  font_size = 12.5,
  line_height = 1.0,
  dpi_by_screen = {
    -- Some external monitor requires custom DPI setting.
    -- https://github.com/wez/wezterm/issues/4096
    ['LG HDR WFHD'] = 81.75,
  },
  keys = {
    -- Override SUPER+w with CloseCurrentPane (instead of CloseCurrentTab)
    { key="w", mods="SUPER",
      action=wezterm.action{CloseCurrentPane={confirm=true}}},

    -- Make Option-Left/Right equivalent to Alt-b/f which many line editors interpret as backward-word and forward-word
    { key="LeftArrow", mods="OPT",
      action=wezterm.action{SendString="\x1bb"}},
    { key="RightArrow", mods="OPT",
      action=wezterm.action{SendString="\x1bf"}},

    -- Pane related shortkeys (most came from iTerm2)
    { key="d", mods="SUPER",
      action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    { key="d", mods="SUPER|SHIFT",
      action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    { key="Enter", mods="SUPER|SHIFT",
      action="TogglePaneZoomState"},
    { key="LeftArrow", mods="OPT|SUPER",
      action=wezterm.action{ActivatePaneDirection="Left"}},
    { key="RightArrow", mods="OPT|SUPER",
      action=wezterm.action{ActivatePaneDirection="Right"}},
    { key="UpArrow", mods="OPT|SUPER",
      action=wezterm.action{ActivatePaneDirection="Up"}},
    { key="DownArrow", mods="OPT|SUPER",
      action=wezterm.action{ActivatePaneDirection="Down"}},

    -- Debug Overlay
    { key="l", mods="SHIFT|CTRL", action="ShowDebugOverlay"},
  },

  use_fancy_tab_bar = true,
  window_padding = {
    left = 8,
    right = 8,
    top = 0,
    bottom = 0,
  },
  mouse_bindings = {
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "NONE",
      action = wezterm.action.Nop,
    },
  }
}
