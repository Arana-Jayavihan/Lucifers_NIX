const hyprland = await Service.import("hyprland");
const mpris = await Service.import("mpris");
const audio = await Service.import("audio");
const battery = await Service.import("battery");
const systemtray = await Service.import("systemtray");
const bluetooth = await Service.import("bluetooth");
const powerProfiles = await Service.import("powerprofiles");

const PowerProfile = () => {
  return Widget.Button({
    tooltipText: powerProfiles
      .bind("active-profile")
      .as((profile) => `Active - ${profile}`),
    class_name: "power-profile",
    on_clicked: () => {
      switch (powerProfiles.active_profile) {
        case "balanced":
          powerProfiles.active_profile = "performance";
          break;
        case "performance":
          powerProfiles.active_profile = "power-saver";
          break;
        default:
          powerProfiles.active_profile = "balanced";
          break;
      }
    },
    child: Widget.Label({
      label: powerProfiles
        .bind("active_profile")
        .as((profile) =>
          profile === "performance"
            ? "🚀"
            : profile === "balanced"
            ? "🍃"
            : profile === "power-saver"
            ? "🔋"
            : ""
        ),
    }),
  });
};

const Info = () => {
  const Ram = () => {
    const ram = Variable(
      { total: 0, used: 0 },
      {
        poll: [
          1000,
          [
            "bash",
            "-c",
            `cat /proc/meminfo | awk '/MemTotal/ {total=$2} /MemAvailable/ {available=$2} END {print total ":" available}'`,
          ],
          (x) => {
            let split = x.split(":");
            return {
              total: Number(split[0]),
              used: Number(split[0] - split[1]),
            };
          },
        ],
      }
    );

    return Widget.Box({
      tooltipText: ram
        .bind()
        .as(
          (x) =>
            `${(x.used / 1024 / 1024).toFixed(2)}GB / ${(
              x.total /
              1024 /
              1024
            ).toFixed(2)}GB (${((x.used / x.total) * 100).toFixed(2)}%)`
        ),
      class_name: "info-child",
      children: [
        Widget.Label({ label: " " }),
        Widget.Label({
          label: ram
            .bind()
            .as((x) => `${((x.used / x.total) * 100).toFixed(0)}%`),
        }),
      ],
    });
  };

  const Cpu = () => {
    const cpu = Variable(0, {
      poll: [
        1000,
        [
          "bash",
          "-c",
          String.raw`mpstat 1 1 -o JSON | grep '"cpu":' | awk -F ' ' '{print 100 - $22}'`,
        ],
      ],
    });

    return Widget.Box({
      tooltipText: cpu.bind().as((x) => `${x}%`),
      class_name: "info-child",
      children: [
        Widget.Label({ label: "󰓅 " }),
        Widget.Label({
          label: cpu.bind().as((x) => `${parseFloat(x).toFixed(0)}%`),
        }),
      ],
    });
  };
  return Widget.Box({
    class_name: "info-bars",
    children: [Cpu(), Ram()],
  });
};

const ClientTitle = () => {
  const winTitle = hyprland.active.client.bind("title");

  return Widget.Box({
    tooltipText: winTitle,
    class_name: "client-title-box",
    children: [
      Widget.Label({
        visible: winTitle.as((wTitle) => wTitle != ""),
        hpack: "start",
        truncate: "middle",
        maxWidthChars: 32,
        class_name: "client-title",
        label: winTitle,
      }),
      Widget.Label({
        visible: winTitle.as((wTitle) => wTitle == ""),
        hpack: "start",
        truncate: "end",
        maxWidthChars: 15,
        class_name: "client-title",
        label: " ~ ",
      }),
    ],
  });
};

const Clock = () => {
  const date = Variable("", {
    poll: [1000, 'date "+%I:%M %p %b %e"'],
  });
  return Widget.Label({
    class_name: "clock",
    label: date.bind().as((date) => ` ${date}`),
  });
};

const Media = () => {
  const playerData = Variable({
    busName: "",
    label: "",
    status: "",
  });

  mpris.connect("player-added", (mpris, busName) => {
    const activePlayer = mpris.players.find(
      (player) => player["bus_name"] == busName
    );
    if (activePlayer != undefined) {
      const { track_artists, track_title, identity, play_back_status } =
        activePlayer;
      const label = `${track_artists.join(", ")} - ${track_title}`;
      const status = `${identity} - ${play_back_status}`;
      playerData.value = {
        busName: busName,
        label: label,
        status: status,
      };
    }
  });

  mpris.connect("player-changed", (mpris, busName) => {
    if (mpris.players.length > 1) {
      const changedPlayer = mpris.players.find(
        (player) => player["bus-name"] == busName
      );
      if (
        changedPlayer != undefined &&
        (changedPlayer["play-back-status"] == "Paused" ||
          changedPlayer["play-back-status"] == "Stopped")
      ) {
        const activePlayer = mpris.players.find(
          (player) => player["play-back-status"] == "Playing"
        );
        if (activePlayer != undefined) {
          const {
            track_artists,
            track_title,
            identity,
            play_back_status,
            bus_name,
          } = activePlayer;
          const label = `${track_artists.join(", ")} - ${track_title}`;
          const status = `${identity} - ${play_back_status}`;
          playerData.value = {
            busName: bus_name,
            label: label,
            status: status,
          };
        } else {
          const {
            track_artists,
            track_title,
            identity,
            play_back_status,
            bus_name,
          } = changedPlayer;
          const label = `${track_artists.join(", ")} - ${track_title}`;
          const status = `${identity} - ${play_back_status}`;
          playerData.value = {
            busName: bus_name,
            label: label,
            status: status,
          };
        }
      } else if (
        changedPlayer != undefined &&
        changedPlayer["play-back-status"] == "Playing"
      ) {
        const {
          track_artists,
          track_title,
          identity,
          play_back_status,
          bus_name,
        } = changedPlayer;
        const label = `${track_artists.join(", ")} - ${track_title}`;
        const status = `${identity} - ${play_back_status}`;
        playerData.value = {
          busName: bus_name,
          label: label,
          status: status,
        };
      }
    } else if (mpris.players.length > 0) {
      const activePlayer = mpris.players.find(
        (player) => player["bus_name"] == busName
      );
      if (activePlayer != undefined) {
        const { track_artists, track_title, identity, play_back_status } =
          activePlayer;
        const label = `${track_artists.join(", ")} - ${track_title}`;
        const status = `${identity} - ${play_back_status}`;
        playerData.value = {
          busName: busName,
          label: label,
          status: status,
        };
      }
    }
  });

  mpris.connect("player-closed", (mpris) => {
    const players = mpris.players;
    if (players.length > 0) {
      const activePlayer = players.find(
        (player) =>
          player["play-back-status"] == "Playing" ||
          player["play-back-status"] == "Paused"
      );
      if (activePlayer != undefined) {
        const {
          track_artists,
          track_title,
          identity,
          play_back_status,
          bus_name,
        } = activePlayer;
        const label = `${track_artists.join(", ")} - ${track_title}`;
        const status = `${identity} - ${play_back_status}`;
        playerData.value = {
          busName: bus_name,
          label: label,
          status: status,
        };
      }
    } else {
      playerData.value = {
        busName: "",
        label: "",
        status: "",
      };
    }
  });

  const currentPlayer = Variable(0);

  const cyclePlayers = () => {
    const players = mpris.players;

    if (currentPlayer.value == players.length - 1) {
      currentPlayer.setValue(0);
      const activePlayer = players[currentPlayer.value];
      const {
        track_artists,
        track_title,
        identity,
        play_back_status,
        bus_name,
      } = activePlayer;
      const label = `${track_artists.join(", ")} - ${track_title}`;
      const status = `${identity} - ${play_back_status}`;
      playerData.value = {
        busName: bus_name,
        label: label,
        status: status,
      };
    } else {
      currentPlayer.setValue(currentPlayer.value + 1);
      if (currentPlayer.value != players.length){
        const activePlayer = players[currentPlayer.value];
        if (activePlayer != undefined) {
          const {
            track_artists,
            track_title,
            identity,
            play_back_status,
            bus_name,
          } = activePlayer;
          const label = `${track_artists.join(", ")} - ${track_title}`;
          const status = `${identity} - ${play_back_status}`;
          playerData.value = {
            busName: bus_name,
            label: label,
            status: status,
          };
        }
      }
    }
  };

  return Widget.Button({
    setup: (self) =>
      self.hook(playerData, () => {
        (self.tooltip_text = playerData.value.status.toString()),
          (self.on_primary_click = () =>
            mpris.getPlayer(playerData.value.busName)?.playPause()),
          (self.on_scroll_up = () =>
            mpris.getPlayer(playerData.value.busName)?.next()),
          (self.on_scroll_down = () =>
            mpris.getPlayer(playerData.value.busName)?.previous()),
          (self.visible =
            playerData.value.status != "" &&
            playerData.value.status != "Stopped"),
          (self.on_middle_click = cyclePlayers);
      }),
    class_name: "media",
    child: Widget.Label({
      justification: "left",
      truncate: "end",
      xalign: 0,
      maxWidthChars: 24,
      wrap: true,
      useMarkup: true,
      class_name: "media-label",
      setup: (self) =>
        self.hook(playerData, () => {
          self.label = playerData.value.label.toString();
        }),
    }),
  });
};

const Volume = () => {
  const icons = {
    101: "overamplified",
    67: "high",
    34: "medium",
    1: "low",
    0: "muted",
  };

  const getIcon = () => {
    const icon = audio.speaker.is_muted
      ? 0
      : [101, 67, 34, 1, 0].find(
          (threshold) => threshold <= audio.speaker.volume * 100
        );

    return `audio-volume-${icons[icon]}-symbolic`;
  };

  const icon = Widget.Icon({
    icon: Utils.watch(getIcon(), audio.speaker, getIcon),
  });

  const connectedList = Widget.Box({
    setup: (self) =>
      self.hook(
        bluetooth,
        (self) => {
          self.children = bluetooth.connected_devices.map(
            ({ icon_name, name }) =>
              Widget.Box([
                Widget.Icon({
                  icon: icon_name + "-symbolic",
                  tooltipText: name,
                  css: "margin: 0px 0.2rem;",
                }),
              ])
          );

          self.visible = bluetooth.connected_devices.length > 0;
        },
        "notify::connected-devices"
      ),
  });

  const VolumeSlider = (type = "speaker") =>
    Widget.Slider({
      hexpand: true,
      drawValue: false,
      onChange: ({ value }) => (audio[type].volume = value),
      value: audio[type].bind("volume"),
    });

  const speakerSlider = VolumeSlider("speaker");

  return Widget.Box({
    class_name: "volume",
    css: "min-width: 140px",
    children: [connectedList, icon, speakerSlider],
  });
};

const BatteryLabel = () => {
  const Percent = () => {
    return Widget.Label({
      label: battery.bind("percent").as((percent) => ` ${percent}%`),
    });
  };
  return Widget.Box({
    tooltipText: Utils.merge(
      [
        battery.bind("energy_rate"),
        battery.bind("charging"),
        battery
          .bind("time_remaining")
          .as(
            (t) =>
              `${Math.floor(t / 60 / 60)}H:${String(
                Math.floor((t / 60) % 60)
              ).padStart(2, "0")}M`
          ),
      ],
      (watts, charging, time_remaining) =>
        `${charging ? "Gaining" : "Using"}: ${watts.toFixed(
          2
        )}W\n${time_remaining} Remaining`
    ),
    class_name: Utils.merge(
      [battery.bind("percent"), battery.bind("charging")],
      (percent, charging) =>
        charging == true
          ? "battery"
          : charging == false && percent <= 25
          ? "battery-low"
          : "battery"
    ),
    visible: battery.bind("available"),
    children: [
      Widget.Icon({
        icon: battery.bind("icon_name"),
      }),
      Percent(),
    ],
  });
};

const SysTray = () => {
  const items = systemtray.bind("items").as((items) =>
    items.map((item) =>
      Widget.Button({
        child: Widget.Icon({ icon: item.bind("icon") }),
        on_primary_click: (_, event) => item.activate(event),
        on_secondary_click: (_, event) => item.openMenu(event),
        tooltip_markup: item.bind("tooltip_markup"),
      })
    )
  );

  return Widget.Box({
    class_name: "sys-tray",
    children: items,
  });
};

const Workspaces = (monitor = 0) => {
  const activeId = hyprland.active.workspace.bind("id");
  let workspaces = hyprland.bind("workspaces").as((ws) =>
    ws
      .filter((ws) => ws.monitorID === monitor)
      .sort((a, b) => a.id - b.id)
      .map(({ id }) =>
        Widget.Button({
          on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
          child: Widget.Label(`${id}`),
          class_name: activeId.as((i) => `${i === id ? "focused" : ""}`),
        })
      )
  );
  return Widget.Box({
    class_name: "workspaces",
    children: workspaces,
  });
};

// layout of the bar
const Left = (monitor = 0) => {
  return Widget.Box({
    spacing: 6,
    children: [Workspaces(monitor), Media(), Info(), PowerProfile()],
  });
};

const Center = (monitor = 0) => {
  return Widget.Box({
    spacing: 6,
    children: [ClientTitle()],
  });
};

const Right = (monitor = 0) => {
  return Widget.Box({
    hpack: "end",
    spacing: 6,
    children: [Volume(), BatteryLabel(), Clock(), SysTray()],
  });
};

export const Bar = (monitor = 0) => {
  return Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    class_name: "bar",
    monitor,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      start_widget: Left(monitor),
      center_widget: Center(monitor),
      end_widget: Right(monitor),
    }),
  });
};
