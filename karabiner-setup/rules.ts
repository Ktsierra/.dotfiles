import fs from "fs";
import { KarabinerRules } from "./types";
import { createHyperSubLayers, app, open, window, shell } from "./utils";

const rules: KarabinerRules[] = [
  // Define the Hyper key itself
  {
    description: "Hyper Key (⌃⌥⇧⌘)",
    manipulators: [
      {
        description: " Right Command -> Hyper Key",
        from: {
          key_code: "right_command", // Changed from caps_lock to right_command
          // key_code: "caps_lock", // Original line, kept for reference
          modifiers: { optional: ["any"] },
        },
        to: [
          {
            set_variable: {
              name: "hyper",
              value: 1,
            },
          },
        ],
        to_after_key_up: [
          {
            set_variable: {
              name: "hyper",
              value: 0,
            },
          },
        ],
        to_if_alone: [
          {
            key_code: "tab",
            modifiers: ["right_command"],
          },
        ],
        type: "basic",
      },
    ],
  },

  {
    description: "Caps Lock -> Escape or Control",
    manipulators: [
      {
        type: "basic",
        from: {
          key_code: "caps_lock",
          modifiers: {
            optional: ["any"],
          },
        },
        to_if_alone: [{ key_code: "escape" }],
        to: [{ key_code: "left_control" }],
      },
    ],
  },

  {
    description: "Left Command -> Command or Cmd + C if pressed alone",
    manipulators: [
      {
        type: "basic",
        from: {
          key_code: "left_command",
        },
        to: [
          {
            key_code: "left_command",
          },
        ],
        to_if_alone: [
          {
            key_code: "c",
            modifiers: ["left_command"],
          },
        ],
      },
    ],
  },

  {
    description: "Left Option -> Left Option or Cmd + V if pressed alone",
    manipulators: [
      {
        type: "basic",
        from: {
          key_code: "left_option",
        },
        to: [
          {
            key_code: "left_option",
          },
        ],
        to_if_alone: [
          {
            key_code: "v",
            modifiers: ["left_command"],
          },
        ],
      },
    ],
  },

  ...createHyperSubLayers({
    /*     spacebar: open(
      "raycast://extensions/stellate/mxstbr-commands/create-notion-todo"
    ), */
    // b = "B"rowse
    b: {
      t: open("https://twitter.com"),
      r: open("https://reddit.com"),
      g: open("https://github.com"),
      y: open("https://youtube.com"),
      p: open("https://perplexity.ai"),
      s: open("https://google.com"), // search
    },

    // o = "Open" applications
    o: {
      x: app("Xcode"),
      c: app("Visual Studio Code"),
      s: app("System Settings"),
      m: app("Mail"),
      f: app("TestFlight"),
      t: app("Copilot"),
      k: app("Karabiner-Elements"),
      a: app("AeroSpace"),
      p: app("Launchpad"),
      d: app("Android Studio"),
      i: app("iPhone Mirroring"),
    },

    // w = "Window"
    w: {
      semicolon: {
        description: "Window: Hide", // to hide the current window, regular macOS behavior
        to: [
          {
            key_code: "h",
            modifiers: ["right_command"],
          },
        ],
      },
      //y: window("previous-display"), // i only use one display
      // o: window("next-display"), // i only use one display
      k: {
        description: "Areospace: Alt+K: Focus Up Window", // to focus the window above
        to: [
          {
            key_code: "k",
            modifiers: ["right_option"],
          },
        ],
      },
      j: {
        description: "Areospace: Alt+J: Focus Down Window", // to focus the window below
        to: [
          {
            key_code: "j",
            modifiers: ["right_option"],
          },
        ],
      },
      h: {
        description: "Areospace: Alt+H: Focus Left Window", // to focus the window on the left
        to: [
          {
            key_code: "h",
            modifiers: ["right_option"],
          },
        ],
      },
      l: {
        description: "Areospace: Alt+L: Focus Right Window", // to focus the window on the right
        to: [
          {
            key_code: "l",
            modifiers: ["right_option"],
          },
        ],
      },
      f: {
        description: "Window: Fullscreen", // to toggle fullscreen in aerospace
        to: [
          {
            key_code: "f",
            modifiers: ["right_option"],
          },
        ],
      },
      u: {
        description: "Window: Previous Tab", // for browsers and terminal
        to: [
          {
            key_code: "tab",
            modifiers: ["right_control", "right_shift"],
          },
        ],
      },
      i: {
        description: "Window: Next Tab", // for browsers and terminal
        to: [
          {
            key_code: "tab",
            modifiers: ["right_control"],
          },
        ],
      },
      n: {
        description: "Window: Next Window", // same app next window, for several terminals or browsers windows
        to: [
          {
            key_code: "grave_accent_and_tilde",
            modifiers: ["right_command"],
          },
        ],
      },
      b: {
        description: "Window: Back", // for safari and finder
        to: [
          {
            key_code: "open_bracket",
            modifiers: ["right_command"],
          },
        ],
      },
      // Note: No literal connection. Both f and n are already taken.
      m: {
        description: "Window: Forward", // for safari and finder
        to: [
          {
            key_code: "close_bracket",
            modifiers: ["right_command"],
          },
        ],
      },
      r: {
        description: "Aerospace Alt+R: Resize Mode", // for windows
        to: [
          {
            key_code: "r",
            modifiers: ["right_option"],
          },
        ],
      },
    },

    // s = "System"
    s: {
      u: {
        to: [
          {
            key_code: "volume_increment",
          },
        ],
      },
      j: {
        to: [
          {
            key_code: "volume_decrement",
          },
        ],
      },
      i: {
        to: [
          {
            key_code: "display_brightness_increment",
          },
        ],
      },
      k: {
        to: [
          {
            key_code: "display_brightness_decrement",
          },
        ],
      },
      l: {
        to: [
          {
            key_code: "q",
            modifiers: ["right_control", "right_command"],
          },
        ],
      },
      p: {
        to: [
          {
            key_code: "play_or_pause",
          },
        ],
      },
      semicolon: {
        to: [
          {
            key_code: "fastforward",
          },
        ],
      },
      // 'v'oice
      v: {
        to: [
          {
            key_code: "spacebar",
            modifiers: ["left_option"],
          },
        ],
      },
    },

    // c = Musi*c* which isn't "m" because we want it to be on the left hand
    c: {
      p: {
        to: [{ key_code: "play_or_pause" }],
      },
      n: {
        to: [{ key_code: "fastforward" }],
      },
      b: {
        to: [{ key_code: "rewind" }],
      },
    },

    // r = "Raycast"
    /*     r: {
      c: open("raycast://extensions/thomas/color-picker/pick-color"),
      n: open("raycast://script-commands/dismiss-notifications"),
      l: open(
        "raycast://extensions/stellate/mxstbr-commands/create-mxs-is-shortlink"
      ),
      e: open(
        "raycast://extensions/raycast/emoji-symbols/search-emoji-symbols"
      ),
      p: open("raycast://extensions/raycast/raycast/confetti"),
      a: open("raycast://extensions/raycast/raycast-ai/ai-chat"),
      s: open("raycast://extensions/peduarte/silent-mention/index"),
      h: open(
        "raycast://extensions/raycast/clipboard-history/clipboard-history"
      ),
      1: open(
        "raycast://extensions/VladCuciureanu/toothpick/connect-favorite-device-1"
      ),
      2: open(
        "raycast://extensions/VladCuciureanu/toothpick/connect-favorite-device-2"
      ),
    }, */

    // x = "Tmux"
    x: {
      i: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt n`, //in accordance with next tab
      u: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt p`, // like previous tab
      c: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt c`, // "create" a new tmux window
      q: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt x`, // "quits" the current tmux window, rebinded from &
      w: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt w`, // "w" list all tmux windows
      s: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt s`, // "s" list all tmux sessions
      r: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt ,`, // rename window
      e: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt $`, // rename session
      d: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt d`, // detach from current session
      t: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt Q`, // reloads tmux config
      1: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt 1`, // switch to window 1
      2: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt 2`, // switch to window 2
      3: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt 3`, // switch to window 3
      4: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt 4`, // switch to window 4
      5: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt 5`, // switch to window 5
      6: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt 6`, // switch to window 6
      7: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt 7`, // switch to window 7
      8: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt 8`, // switch to window 8
      9: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt 9`, // switch to window 9
      0: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt 0`, // switch to window 0
      spacebar: shell`osascript ~/.config/tmux/scripts/open_ghostty_and_sessionize.scpt F`, // switch between 2 windows (like alt+tab)
      //copy mode
      open_bracket: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt [`, // enter copy mode
      close_bracket: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt ]`, // paste from buffer_0
      semicolon: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt :`, // tmux command prompt
    },

    // tmux sessionizer, layer z for specific sessions
    spacebar: shell`osascript ~/.config/tmux/scripts/tmux_controller.scpt l`, // Open Ghostty and run tmux sessionizer

    // z = "Sessionize" into Ghostty
    z: {
      d: shell`osascript ~/.config/tmux/scripts/open_ghostty_and_sessionize.scpt D`, // sessionize into dotfiles
      h: shell`osascript ~/.config/tmux/scripts/open_ghostty_and_sessionize.scpt H`, // sessionize into home
      spacebar: shell`osascript ~/.config/tmux/scripts/open_ghostty_and_sessionize.scpt L`, // alternate 2 session( alt+tab)
      n: shell`osascript ~/.config/tmux/scripts/open_ghostty_and_sessionize.scpt N`, // sessionize into nvim config
    },

    // ghostty always at 0
    0: app("Ghostty"),
    1: app("Safari"),
    2: app("Visual Studio Code"),
    3: app("Finder"),
    4: app("System Settings"),
    5: app("GIMP"),
    6: app("LM Studio"),
    7: app("Simulator"),
    9: app("Firefox"),

    // vim like navigation
    h: {
      to: [{ key_code: "left_arrow" }],
    },
    j: {
      to: [{ key_code: "down_arrow" }],
    },
    k: {
      to: [{ key_code: "up_arrow" }],
    },
    l: {
      to: [{ key_code: "right_arrow" }],
    },
  }),
];

fs.writeFileSync(
  "karabiner.json",
  JSON.stringify(
    {
      global: {
        show_in_menu_bar: false,
      },
      profiles: [
        {
          name: "Default",
          virtual_hid_keyboard: { keyboard_type_v2: "ansi" },
          complex_modifications: {
            rules,
          },
        },
      ],
    },
    null,
    2
  )
);
