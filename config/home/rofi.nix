{ pkgs, config, ... }:

let
  palette = config.colorScheme.palette;
in {
  home.file.".config/rofi/config.rasi".text = ''
    @theme "/dev/null"

    * {
      bg: #${palette.base00}dd;
      background-color: transparent;
    }

    configuration {
      modi:		    "run,filebrowser,drun";
      show-icons:	    true;
      icon-theme:	    "Papirus";
      location:		    0;
      font:		    "JetBrainsMono Nerd Font 12";	
      drun-display-format:  "{icon} {name}";
      display-drun:	    "   Apps ";
      display-run:	    "   Run ";
      display-filebrowser:  "   File ";
    }

    window { 
      width: 40%;
      transparency: "real";
      orientation: vertical;
      border: 2px ;
      border-color: #${palette.base08};
      border-radius: 10px;
      background-color: @bg;
    }

    mainbox {
      children: [ inputbar, listview, mode-switcher ];
    }

    // ELEMENT
    // -----------------------------------

    element {
      padding: 8 14;
      text-color: #${palette.base05};
      border-radius: 5px;
      background-color: transparent;
    }

    element selected {
      text-color: #${palette.base01};
      background-color: #${palette.base0C};
    }

    element-text {
      text-color: inherit;
      background-color: transparent;
    }

    element-icon {
      size: 24 px;
      padding: 0 6 0 0;
      alignment: vertical;
      background-color: transparent;
    }

    listview {
      columns: 2;
      lines: 9;
      padding: 8 0;
      fixed-height: true;
      fixed-columns: true;
      fixed-lines: true;
      border: 0 10 6 10;
      background-color: transparent;
    }

    // INPUT BAR 
    //------------------------------------------------

    entry {
      text-color: #${palette.base05};
      padding: 10 10 0 0;
      margin: 0 -2 0 0;
      background-color: transparent;
    }

    inputbar {
      //background-image: url("~/.config/rofi/rofi.jpg", width);
      padding: 10 0 0;
      margin: 0 0 0 0;
      background-color: transparent;
    } 

    prompt {
      text-color: #${palette.base0D};
      padding: 10 6 0 10;
      margin: 0 -2 0 0;
      background-color: transparent;
    }

    // Mode Switcher
    //------------------------------------------------

    mode-switcher {
      border-color:   #${palette.base0F};
      spacing:	      0;
      background-color: transparent;
    }

    button {
      padding:	      10px;
      background-color: transparent;
      text-color:	      #${palette.base05};
      vertical-align:   0.5; 
      horizontal-align: 0.5;
    }

    button selected {
      background-color: @bg;
      text-color: #${palette.base0D};
    }

    message {
      background-color: transparent;
      margin: 2px;
      padding: 2px;
      border-radius: 5px;
    }

    textbox {
      padding: 6px;
      margin: 20px 0px 0px 20px;
      text-color: #${palette.base0F};
      background-color: transparent;
    }
  '';
}
