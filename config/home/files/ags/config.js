import { Bar } from "./Bar/bar.ts";
const hyprland = await Service.import("hyprland");

import App from "resource:///com/github/Aylur/ags/app.js";
App.connect("config-parsed", () => console.log("Config parsed!"));

function addWindows(windows) {
  windows.forEach((win) => App.addWindow(win));
}

function removeWindows(window) {
  App.removeWindow(window);
}

let connectedMonitors = [];

const handleMonitorAdd = () => {
  const monitors = hyprland.monitors;
  try {
    for (let id = 0; id < monitors.length; id++) {
      if (!connectedMonitors.includes(id)) {
        addWindows([Bar(id)]);
        connectedMonitors.push(id);
      }
    }
  } catch (error) {
    console.error(error);
  }
};

const handleMonitorRemove = () => {
  const monitors = hyprland.monitors;
  try {
    let disconnectedMonitors = []
    connectedMonitors.forEach((monitor) => {
      monitors.forEach((mon) => {
        if (mon.id != monitor){
          disconnectedMonitors.push(monitor)
        }
      })
    });
    disconnectedMonitors.forEach((monitor) => {
      removeWindows(`bar-${monitor}`);
      const index = connectedMonitors.indexOf(monitor)
      if (index !== -1) {
        connectedMonitors.splice(index, 1);
      }
    })
  } catch (error) {
    console.error(error);
  }
};

const renderStartUpBars = () => {
  const monitors = hyprland.monitors;
  try {
    for (let id = 0; id < monitors.length; id++) {
      addWindows([Bar(id)]);
      connectedMonitors.push(id);
    }
  } catch (error) {
    console.error(error);
    App.quit();
  }
};

renderStartUpBars();
hyprland.connect("monitor-added", () => handleMonitorAdd());
hyprland.connect("monitor-removed", () => handleMonitorRemove());

App.config({
  style: "./style.css"
});
