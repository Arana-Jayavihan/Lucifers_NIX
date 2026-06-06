{ pkgs, config, ... }:

{
  home.file.".config/fastfetch/config.jsonc".text = ''
      {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "source": "~/.config/ascii-fastfetch",
        "color": {
          "1": "blue"
        },
        "type": "file",
        "padding": {
          "top": 3
        }
      },
      "display": {
        "separator": "  >  "
      },
      "modules": [
        {
          "type": "custom",
          //"key": "  ",
          "format": "Lucifer's 🍃 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
        },
        //{
        //  "type": "custom",
        //  "format": "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
        //},
        "break",
        {
          "type": "kernel",
          "key": "   VER ",
          "keyColor": "bright_cyan"
        },
        {
          "type": "uptime",
          "key": "   UP  ",
          "keyColor": "bright_green"
        },
        {
          "type": "packages",
          "key": "  󰮯 PKG ",
          "keyColor": "red"
        },
        {
          "type": "wm",
          "key": "  󰨇 DE  ",
          "keyColor": "blue"
        },
        {
          "type": "terminal",
          "key": "   TER ",
          "keyColor": "magenta"
        },
        {
          "type": "shell",
          "key": "   SH  ",
          "keyColor": "yellow"
        },
        "break",
        {
          "type": "custom",
          "format": "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
        },
        "break",
        {
          "type": "host",
          "key": "   PC  ",
          "keyColor": "bright_blue"
        },
        {
          "type": "cpu",
          "key": "   CPU ",
          "keyColor": "bright_green"
        },
        {
          "type": "gpu",
          "key": "  󱤓 GPU ",
          "keyColor": "red"
        },
        {
          "type": "memory",
          "key": "  󰍛 MEM ",
          "keyColor": "bright_yellow"
        },
        {
          "type": "disk",
          "key": "   DISK",
          "keyColor": "bright_cyan"
        },
        "break",
        {
          "type": "custom",
          "format": "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
        }
      ]
    }
  '';
}
