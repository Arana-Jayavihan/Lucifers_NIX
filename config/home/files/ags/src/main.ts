import Gdk from "gi://Gdk";
import Gtk from "gi://Gtk";
import { idle } from "resource:///com/github/Aylur/ags/utils/timeout.js";

import { AppLauncher } from "applauncher";
import { Bar } from "bar";
import { Clipboard } from "menus/clipboard";
import { Popovers } from "menus/popovers";
import { SinkPicker } from "menus/sink_picker";
import { NotificationPopups } from "notifications";

import { getMonitorID } from "utils";

const perMonitorWindows = [
	Bar,
	NotificationPopups
] as const

const uniqueWindows = [
	AppLauncher,
	Popovers,
	Clipboard,
	SinkPicker
] as const

idle(async () => {
	uniqueWindows.map(m => App.addWindow(m))

  const display = Gdk.Display.get_default()!;
  for (let m = 0;  m < display?.get_n_monitors();  m++) {
    const monitor = display?.get_monitor(m)!;
    perMonitorWindows.map(w => App.addWindow(w(monitor)));
  }

  display?.connect("monitor-added", (disp, monitor) => {
    perMonitorWindows.map(w => App.addWindow(w(monitor)));
  });

  display?.connect("monitor-removed", (disp, monitor) => {
    App.windows.forEach((window) => {
			const win = window as ReturnType<typeof Widget.Window>;
      if(win.gdkmonitor === monitor) App.removeWindow(win);
    });
  });


});

App.config({ 
});
