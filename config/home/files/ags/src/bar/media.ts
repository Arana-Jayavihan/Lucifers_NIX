import { type MprisPlayer } from "@ags/service/mpris";

import * as COLOR from "colours.json";

import Gdk from "gi://Gdk";
import Gtk from "gi://Gtk";

App.applyCss(`
.player {
  padding-left: 7px;
  padding-right: 7px;
	margin-bottom: 1px;
  min-width: 240px;
	background-color: ${COLOR.Surface0};
	background-color:rgba(54, 58, 79,0.8);
	border-radius: 15px;
}

.player .img {
    min-width: 100px;
    min-height: 100px;
    background-size: cover;
    background-position: center;
    border-radius: 13px;
    margin-right: 1em;
}

.player .title {
    font-size: 1.2em;
}

.player .artist {
    font-size: 1.1em;
    color: @insensitive_fg_color;
}

.player scale {
	background-color: transparent;
}

.player scale trough {
background-color: #5b6078;
border-radius: 15px;
}

.player scale.position {
    padding: 0;
    margin-bottom: .2em;
}

.player scale.position trough {
    min-height: 8px;
}

.player scale.position highlight {
    background-color: @theme_fg_color;
		border-radius: 15px;
}

.player scale.position slider {
    all: unset;
}

.player button {
    min-height: 1em;
    min-width: 1em;
    padding: .3em;
}

.player button.play-pause {
    margin: 0 .3em;
}
`);

const hyprland = await Service.import("hyprland");

const mpris = await Service.import("mpris");
mpris.cacheCoverArt = false;
const players = mpris.bind("players");

const FALLBACK_ICON = "audio-x-generic-symbolic";
const PLAY_ICON = "media-playback-start-symbolic";
const PAUSE_ICON = "media-playback-pause-symbolic";
const PREV_ICON = "media-skip-backward-symbolic";
const NEXT_ICON = "media-skip-forward-symbolic";
//const SHUFFLE_ENABLE_ICON = "media-playlist-shuffle-symbolic";
//const SHUFFLE_DISABLE_ICON = "media-playlist-no-shuffle-symbolic";

function lengthStr(length: number) {
  if (length <= 0) {
    return `-:--`;
  }
  const min = Math.floor(length / 60);
  const sec = Math.floor(length % 60);
  const sec0 = sec < 10 ? "0" : "";
  return `${min}:${sec0}${sec}`;
}

function Player(player: MprisPlayer | undefined) {
  /*const img = Widget.Box({
    class_name: "img",
    vpack: "start",
    css: player.bind("cover_path").as(
      (p) => `
            background-image: url('${p}');
        `,
    ),
  });*/

  const title = Widget.Label({
    class_name: "title",
    wrap: true,
    hpack: "start",
    maxWidthChars: 25,
    truncate: "end",
    label: player?.bind("track_title") ?? "Song Title",
  });

  const artist = Widget.Label({
    class_name: "artist",
    wrap: true,
    hpack: "end",
    maxWidthChars: 23,
    truncate: "end",
    label:
      player?.bind("track_artists").transform((a) => a.join(", ")) ??
      "Artist Name",
  });

  const positionSlider = Widget.Slider({
    class_name: "position",
    draw_value: false,
    on_change: ({ value }) => (player!.position = value * player!.length),
    setup: (self) => {
      if (player === undefined) return;

      function update() {
        if (player!.length <= 0) {
          self.value = 1;
        } else {
          const value = player!.position / player!.length;
          self.value = value > 0 ? value : 0;
        }
      }
      self.hook(player, update);
      self.hook(player, update, "position");
      self.poll(1000, update);
    },
  }) as unknown as Gtk.Widget;

  const positionLabel = Widget.Label({
    class_name: "position",
    hpack: "start",
    label: lengthStr(-1),
    setup: (self) => {
      if (player === undefined) return;

      const update = (_: any, time: number | undefined = undefined) => {
        self.label = lengthStr(time ?? player!.position);
      };

      self.hook(player!, update, "position");
      self.poll(1000, update);
    },
  });

  const lengthLabel = Widget.Label({
    class_name: "length",
    hpack: "end",
    label: player?.bind("length").transform(lengthStr) ?? lengthStr(-1),
  });

  /*const icon = Widget.Icon({
    class_name: "icon",
    hexpand: true,
    hpack: "end",
    vpack: "start",
    tooltip_text: player.identity || "",
    icon: player.bind("entry").transform((entry) => {
      const name = `${entry}-symbolic`;
      return Utils.lookUpIcon(name) ? name : FALLBACK_ICON;
    }),
  });*/

  const playerName = Widget.Label({
    hpack: "end",
    css: "margin-right:3px;",
    label: player?.bind("identity") ?? "Player",
  });

  const playPause = Widget.Button({
    class_name: "play-pause",
    on_clicked: () => player?.playPause(),
    sensitive: player?.bind("can_play") ?? false,
    child: Widget.Icon({
      icon:
        player?.bind("play_back_status").transform((s) => {
          switch (s) {
            case "Playing":
              return PAUSE_ICON;
            case "Paused":
            case "Stopped":
              return PLAY_ICON;
            default:
              return PLAY_ICON;
          }
        }) ?? PLAY_ICON,
    }),
  });

  const prev = Widget.Button({
    on_clicked: () => player?.previous(),
    sensitive: player?.bind("can_go_prev") ?? false,
    child: Widget.Icon(PREV_ICON),
  });

  const next = Widget.Button({
    on_clicked: () => player?.next(),
    sensitive: player?.bind("can_go_next") ?? false,
    child: Widget.Icon(NEXT_ICON),
  });

  // shuffle button is buggy af, totally unusable
  // not my fault :(
  /*
  const shuffle = Widget.Button({
    on_clicked: () => player.shuffle(),
    //visible: player.bind("shuffle_status").as(x => {console.log(x);return(x != null)}),
    child: Widget.Icon({
			icon: player.bind("shuffle_status").as(shuffle_active => {
				console.log(shuffle_active);they added distro 
				if (shuffle_active) {
					return SHUFFLE_DISABLE_ICON
				} else {
					return SHUFFLE_ENABLE_ICON
				}
			})
		}),
  });
	*/

  return Widget.EventBox({
    on_primary_click: () => {
      // focuses the player's actual window when the player is pressed
      if (player === undefined) return;

      const idMap = {
        Chrome: "initialclass:google-chrome",
        Feishin: "initialclass:feishin",
        Spotify: "initialtitle:[sS]potify",
      } as const;
      const regex = idMap[player.identity];
      if (regex !== undefined) {
        hyprland.messageAsync(`dispatch focuswindow ${regex}`);
      } else {
        console.log("players: ", player);
        console.log("hypr clients: ", hyprland.clients);
        console.log("player not found");
        console.log("identity: ", player?.identity);
      }
    },
    child: Widget.Box(
      { class_name: "player", attribute: player?.bus_name },
      Widget.Box(
        {
          vertical: true,
          vexpand: true,
          vpack: "center",
          hexpand: true,
        },
        Widget.CenterBox({ start_widget: title, end_widget: artist }),
        positionSlider,
        Widget.CenterBox({
          start_widget: positionLabel,
          center_widget: Widget.Box([prev, playPause, next]),
          end_widget: Widget.Box({
            hpack: "end",
            children: [playerName, lengthLabel],
          }),
        }),
      ),
    ),
  });
}

export const Media = () => {
  let lastScroll = Number(new Date());

  const scrollableList = Widget.Scrollable({
    hscroll: "never",
    vscroll: players.as((p) => (p.length > 1 ? "external" : "never")),
    //vscroll: "external",
    child: Widget.EventBox({
      setup: (self) => {
        self.connect("scroll-event", (self, event: Gdk.Event) => {
          return Gdk.EVENT_STOP;
        });
      },

      child: Widget.EventBox({
        css: players.as((p) => (p.length > 1 ? "" : "padding-bottom:1px")),
        // assumes vadjustment.lower = 0
        onScrollDown: () => {
          const time = Number(new Date());
          if (time - lastScroll < 200) return;

          scrollableList.vadjustment.value +=
            scrollableList.vadjustment.upper / mpris.players.length;
          lastScroll = time;
        },
        onScrollUp: () => {
          const time = Number(new Date());
          if (time - lastScroll < 200) return;

          scrollableList.vadjustment.value -=
            scrollableList.vadjustment.upper / mpris.players.length;
          lastScroll = time;
        },
        child: Widget.Box({
          vertical: true,
          children: players.as((p) => {
            if (p.length === 0) {
              return [Player(undefined)];
            } else {
              return p.map(Player);
            }
          }),
        }),
      }),
    }),
  });

  return Widget.Revealer({
    revealChild: players.as((p) => p.length > 0),
    transitionDuration: 750,
    transition: "slide_right",
    child: scrollableList,
  });
};
