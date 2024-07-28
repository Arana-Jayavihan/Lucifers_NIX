import { revealerState } from "./revealer.ts";

const battery = await Service.import("battery");

export const BatteryLabel = (position) => {
  const Percent = () => {
    return Widget.Label({
      label: battery.bind("percent").as((percent) => ` ${percent}%`),
    });
  };
  return Widget.Box({
    setup: self => self.hook(battery, () => {
      if (position == "revealer"){
        self.visible = (battery.percent > 50 && battery.available == true)
      } else if ( position == "bar") {
        self.visible = (battery.percent <= 50 && battery.available == true)
      }
    }),
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
    children: [
      Widget.Icon({
        icon: battery.bind("icon_name"),
      }),
      Percent(),
    ],
  });
};
