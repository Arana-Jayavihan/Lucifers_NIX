const hyprland = await Service.import("hyprland");
const mpris = await Service.import("mpris");
const audio = await Service.import("audio");
const battery = await Service.import("battery");
const systemtray = await Service.import("systemtray");
const powerProfiles = await Service.import('powerprofiles')

const PowerProfile = () => {
  return Widget.Button({
    tooltipText: powerProfiles.bind('active_profile'),
    class_name: "power-profile",
    on_clicked: () => {
        switch (powerProfiles.active_profile) {
            case 'balanced':
                powerProfiles.active_profile = 'performance';
                break;
            default:
                powerProfiles.active_profile = 'balanced';
                break;
        };
    },
    child: Widget.Label({
      label: powerProfiles.bind('active_profile').as((profile) => profile === "performance" ? "🚀" : "🍃"),
  })
})
}

const ram = Variable(
  { total: 0, used: 0 },
  {
    poll: [
      500,
      ["bash", "-c", `LANG=C free | awk '/^Mem/ {print $2,$3}'`],
      (x) => {
        let split = x.split(" ");
        return { total: Number(split[0]), used: Number(split[1]) };
      },
    ],
  },
);


const Ram = () => {
  return Widget.Box({
      tooltipText: ram.bind().as((x) => `${(x.used / 1024 / 1024 / 1024).toFixed(2)}GiB / ${(x.total / 1024 / 1024 / 1024).toFixed(2)}GiB (${((x.used / x.total) * 100).toFixed(2)}%)`,),
      class_name: "info-child",
      children: [
        Widget.Label({ label: " " }),
        Widget.Label({ 
          label: ram.bind().as((x) => `${((x.used / x.total) * 100).toFixed(2)}%`),
        }),
      ],
    });
}
  
const cpu = Variable(0, {
  poll: [
    500,
    [
      "bash",
      "-c",
      String.raw`mpstat | awk '$3 ~ /CPU/ { for(i=1;i<=NF;i++) { if ($i ~ /%idle/) field=i } } $3 ~ /all/ { print 100 - $field }'`,
    ],
  ],
});

const Cpu = () => {
  return Widget.Box({
    tooltipText: cpu.bind().as((x) => `${(x).padStart(4, "0")}%`),
    class_name: "info-child",
    children: [
      Widget.Label({ label: "󰓅 " }),
      Widget.Label({ 
        label: cpu.bind().as((x) => `${x}%`),
      })
    ],
  });
}

const Info = () => {
  return Widget.Box({
    class_name: "info-bars",
    children: [
      Cpu(),
      Ram()
    ]
  })  
}

const date = Variable("", {
  poll: [1000, 'date "+%I:%M %p %b %e"'],
});

function Workspaces(monitor = 0) {
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
}

function ClientTitle() {
  const winTitle = hyprland.active.client.bind("title");
  const winClass = hyprland.active.client.bind("class");
  return Widget.Box({
    class_name: "client-title-box",
    children: [
      Widget.Label({
        hpack: "start",
        truncate: "end",
        maxWidthChars: 20,
        class_name: "client-title",
        label: winClass,
      }),
      Widget.Label({
        hpack: "start",
        truncate: "end",
        maxWidthChars: 20,
        class_name: "client-title",
        label: " - ",
      }),
      Widget.Label({
        hpack: "start",
        truncate: "end",
        maxWidthChars: 23,
        class_name: "client-title",
        label: winTitle,
      }),
    ],
  });
}

function Clock() {
  return Widget.Label({
    class_name: "clock",
    label: date.bind(),
  });
}

function Media() {
    
  const label = Utils.watch("", mpris, "player-changed", () => {
    if (mpris.players[0]) {
      const { track_artists, track_title } = mpris.players[0];
      return `${track_artists.join(", ")} - ${track_title}`;
    } else {
      return "Nothing is playing";
    }
  });

  return Widget.Button({
    visible: false,
    class_name: "media",
    on_primary_click: () => mpris.getPlayer("")?.playPause(),
    on_scroll_up: () => mpris.getPlayer("")?.next(),
    on_scroll_down: () => mpris.getPlayer("")?.previous(),
    child: Widget.Label({
      justification: "left",
      truncate: "end",
      xalign: 0,
      maxWidthChars: 24,
      wrap: true,
      useMarkup: true,
      class_name: "media-label",
      label,
    }),
  });
}

function Volume() {
  const icons = {
    101: "overamplified",
    67: "high",
    34: "medium",
    1: "low",
    0: "muted",
  };

  function getIcon() {
    const icon = audio.speaker.is_muted
      ? 0
      : [101, 67, 34, 1, 0].find(
          (threshold) => threshold <= audio.speaker.volume * 100
        );

    return `audio-volume-${icons[icon]}-symbolic`;
  }

  const icon = Widget.Icon({
    icon: Utils.watch(getIcon(), audio.speaker, getIcon),
  });

  const slider = Widget.Slider({
    hexpand: true,
    draw_value: false,
    on_change: ({ value }) => (audio.speaker.volume = value),
    setup: (self) =>
      self.hook(audio.speaker, () => {
        self.value = audio.speaker.volume || 0;
      }),
  });

  return Widget.Box({
    class_name: "volume",
    css: "min-width: 140px",
    children: [icon, slider],
  });
}

function BatteryLabel() {
  const value = battery.bind("percent").as((p) => (p > 0 ? p / 100 : 0));

  const icon = () => {
    const state = battery.bind("charging");
    if (state.emitter.charging === true) {
      return Widget.Label({
        label: "󰂄 ",
      });
    }
    if (state.emitter.charged === true) {
      return Widget.Label({
        label: "󱘖 ",
      });
    } else {
      return Widget.Label({
        label: battery.bind("percent").as((p) => {
          if (p >= 90) {
            return `󰁹 `;
          } else if (p >= 80) {
            return `󰂂 `;
          } else if (p >= 70) {
            return `󰂁 `;
          } else if (p >= 60) {
            return `󰂀 `;
          } else if (p >= 50) {
            return `󰁿 `;
          } else if (p >= 40) {
            return `󰁾 `;
          } else if (p >= 30) {
            return `󰁽 `;
          } else if (p >= 20) {
            return `󰁼 `;
          } else if (p >= 10) {
            return `󰁻 `;
          } else {
            return `󰁺 `;
          }
        }),
      });
    }
  };
  return Widget.Box({
    tooltipText: Utils.merge(
      [
        battery.bind("percent"),
        battery.bind("energy_rate"),
        battery.bind("charging"),
        battery
          .bind("time_remaining")
          .as(
            (t) =>
              `${Math.floor(t / 60 / 60)}:${String(
                Math.floor((t / 60) % 60)
              ).padStart(2, "0")}`
          ),
      ],
      (percent, watts, charging, time_remaining) =>
        `${charging ? "Gaining" : "Using"}: ${watts.toFixed(2)}W\n(${percent}%) - ${time_remaining} Remaining`
    ),
    class_name: battery.bind("percent").as((p) => (p <= 25 ? "battery-low" : "battery")),
    visible: battery.bind("available"),
    children: [icon(), Widget.Label(`${value.emitter.percent}%`)],
  });
}

function SysTray() {
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
}

// layout of the bar
function Left(monitor = 0) {
  return Widget.Box({
    spacing: 8,
    children: [Workspaces(monitor), Media(), Info(), PowerProfile()],
  });
}

function Center(monitor = 0) {
  return Widget.Box({
    spacing: 8,
    children: [ClientTitle()],
  });
}

function Right(monitor = 0) {
  return Widget.Box({
    hpack: "end",
    spacing: 8,
    children: [Volume(), BatteryLabel(), Clock(), SysTray()],
  });
}

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
