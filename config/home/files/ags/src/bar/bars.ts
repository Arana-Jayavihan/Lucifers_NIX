import { round } from "utils";

const ram = Variable(
  { total: 0, used: 0 },
  {
    poll: [
      2000,
      ["bash", "-c", `LANG=C free | awk '/^Mem/ {print $2,$3}'`],
      (x) => {
        let split = x.split(" ");
        return { total: Number(split[0]), used: Number(split[1]) };
      },
    ],
  },
);

export const RamBar = () =>
  Widget.Box({
    tooltipText: ram
      .bind()
      .as(
        (x) =>
          `${round(x.used / 1024 / 1024)}GiB / ${round(x.total / 1024 / 1024)}GiB (${round((x.used / x.total) * 100)}%)`,
      ),
    children: [
      Widget.Label({ label: " " }),
      Widget.LevelBar({
        widthRequest: 100,
        value: ram.bind().as((x) => x.used / x.total),
        css: "border: 1px transparent solid;",
      }),
    ],
  });

const cpu = Variable(0, {
  poll: [
    4000,
    [
      "bash",
      "-c",
      // returns two numbers, the first one is bad
      // the second one is the percentage IDLE time
      String.raw`lANG=C top -bn2 | awk '/Cpu\(s\):/ { print $8 }'`,
    ],
    (idle_percents) => {
      return 100 - Number(idle_percents.split("\n")[1]);
    },
  ],
});

const CpuBar = () =>
  Widget.Box({
    tooltipText: cpu.bind().as((x) => `${round(x).padStart(4, "0")}%`),
    children: [
      Widget.Label({ label: "󰓅 " }),
      Widget.LevelBar({
        widthRequest: 100,
        value: cpu.bind().as((x) => x / 100),
        css: "border: 1px transparent solid;",
      }),
    ],
  });

const networking = await Service.import("network");

const NetworkIcon = () =>
  Widget.Label({
    label: Utils.merge(
      [
        networking.wifi.bind("strength"),
        networking.bind("primary"),
        networking.bind("connectivity"),
      ],
      (p, primary, connectivity) => {
        if (connectivity === "none") {
          return "󰤭 ";
        }
        if (primary === "wired") {
          return "󰈀 ";
        }

        if (p >= 90) {
          return "󰤨 ";
        } else if (p >= 65) {
          return `󰤥 `;
        } else if (p >= 40) {
          return `󰤢 `;
        } else if (p >= 10) {
          return `󰤟 `;
        } else {
          return `󰤯 `;
        }
      },
    ),
  });

const ip = Variable("", {
  poll: [
    60000,
    [
      "bash",
      "-c",
      `ip -o -4 addr list wlp1s0 | awk '{print $4}' | cut -d/ -f1`,
    ],
  ],
});

const NetworkingBar = () =>
  Widget.EventBox({
    // TODO: onSecondaryClick: () => App.openWindow("network"),
    child: Widget.Box({
      tooltipMarkup: Utils.merge(
        [networking.bind("wifi"), ip.bind()],
        (wifi, ip) => `${wifi.ssid} (${wifi.strength}%)\n${ip}`,
      ),
      children: [
        NetworkIcon(),
        Widget.LevelBar({
          widthRequest: 100,
          value: networking.wifi.bind("strength").as((x) => Math.abs(x) / 100),
          css: "border: 1px transparent solid;",
        }),
      ],
    }),
  });

export const InfoBars = () =>
  Widget.Box({
    vertical: true,
    css: "padding-right:4px;padding-left:7px;",
    children: [NetworkingBar(), CpuBar(), RamBar()],
  });
