import { BatteryLabel } from "./modules/battery.ts";
import { SysTray } from "./modules/tray.ts";
import { Clock } from "./modules/clock.ts";
import { ClientTitle } from "./modules/clientTitle.ts";
import { Media } from "./modules/mpris.ts";
import { SysStats } from "./modules/stats.ts";
import { PowerProfile } from "./modules/powerProfile.ts";
import { Workspaces } from "./modules/workspaces.ts";
import { Revealer, RevealerButton } from "./modules/revealer.ts";

// layout of the bar
const Left = (monitor = 0) => {
  return Widget.Box({
    spacing: 6,
    children: [Workspaces(monitor), Media(), SysStats(), PowerProfile()],
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
    children: [RevealerButton(), Revealer(), BatteryLabel("bar"), Clock(), SysTray()],
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
