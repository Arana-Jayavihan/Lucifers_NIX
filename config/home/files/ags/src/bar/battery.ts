import * as COLOR from "colours.json";
import { round } from "utils";

const battery = await Service.import("battery");

const batteryIcon = () =>
  Widget.Label({
    label: battery.bind("percent").as((p) => {
      if (p >= 90) {
        return ` `;
      } else if (p >= 65) {
        return ` `;
      } else if (p >= 40) {
        return ` `;
      } else if (p >= 10) {
        return ` `;
      } else {
        return ` `;
      }
    }),
    class_name: battery.bind("charging").as((ch) => (ch ? "charging" : "")),
  });

const TimeRemaining = () =>
  Widget.Label({
    css: battery
      .bind("charging")
      .as((c) => `font-size: 10px;font-weight:${c ? "bold" : "normal"};`),
    label: battery
      .bind("time_remaining")
      .as(
        (t) =>
          `${Math.floor(t / 60 / 60)}:${String(Math.floor((t / 60) % 60)).padStart(2, "0")}`,
      ),
  });

App.applyCss(`
levelbar {
	background-color: transparent;
}

levelbar trough {
  background-color: ${COLOR.Surface1};
	border-radius: 50px;
}

levelbar block.empty {
	background-color: transparent;
}

levelbar block.filled {
  background-color: ${COLOR.Highlight};
	border-radius: 50px;
}
`);

export const BatteryWheel = () =>
  Widget.CircularProgress({
    tooltipText: Utils.merge(
      [
        battery.bind("percent"),
        battery.bind("energy_rate"),
        battery.bind("charging"),
      ],
      (percent, watts, charging) =>
        `${charging ? "Gaining" : "Using"}: ${round(watts)}W (${percent}%)`,
    ),
    css:
      "min-width: 40px;" + // its size is min(min-height, min-width)
      "min-height: 40px;" +
      "font-size: 6px;" + // to set its thickness set font-size on it
      "margin: 1px;" + // you can set margin on it
      `background-color: ${COLOR.Surface1};` + // set its bg color
      `color: ${COLOR.Highlight};`, // set its fg color
    rounded: false,
    inverted: false,
    startAt: 0.75,
    value: battery.bind("percent").as((p) => p / 100),
    child: TimeRemaining(),
  });
