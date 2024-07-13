import Gdk from "gi://Gdk";

export function round(number: number) {
  return String(Math.round(number * 10) / 10);
}

const display = Gdk.Display.get_default()!;
export function getMonitorID(gdkmonitor: Gdk.Monitor): number {
  const screen = display.get_default_screen()!;
  for(let i = 0; i < display.get_n_monitors()!; ++i) {
    if(gdkmonitor === display.get_monitor(i))
      return i;
  }
	console.error("screen ID not found", display, screen)
	return 0
}
