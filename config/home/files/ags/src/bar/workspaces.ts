import * as COLOR from "colours.json";

import Gdk from "gi://Gdk";
import { getMonitorID } from "utils";

import { newAspectFrame as AspectFrame } from "widgets/AspectFrame";

const hyprland = await Service.import("hyprland");

App.applyCss(`
.workspace-icon {
	margin-left: 1px;
	margin-right: 1px;
	font-size: 15px;
}`);

const dispatch = (ws: number) =>
  hyprland.messageAsync(`dispatch workspace ${ws}`);

export const Workspaces = (monitor: Gdk.Monitor) =>
  Widget.EventBox({
    //onScrollUp: () => dispatch("+1"),
    //onScrollDown: () => dispatch("-1"),
    child: Widget.Box({
      children: Array.from({ length: 10 }, (_, i) => i + 1).map((i) =>
        AspectFrame({
          className: "flat",
          child: Widget.Button({
            attribute: i,
            label: `${i}`,
            onClicked: () => dispatch(i),
            className: "circular workspace-icon",
          }),
          ratio: 1,
        }),
      ),

      setup: (self) =>
        self.hook(hyprland, () =>
          self.children.forEach((frame) => {
            const btn = frame.child;
            if (
              btn.attribute === hyprland.monitors[getMonitorID(monitor)]?.activeWorkspace?.id
            ) {
              // active on this window
              btn.css = `background-color:${COLOR.Highlight};`;
            } else if (
              hyprland.workspaces.some(
                (ws) => ws.id === btn.attribute && ws.monitorID === getMonitorID(monitor),
              )
            ) {
              // open on this monitor
              btn.css = `background-color:${COLOR.Overlay1};`;
            } else if (
              // open on a different monitor
              hyprland.workspaces.some((ws) => ws.id === btn.attribute)
            ) {
              btn.css = `background-color:${COLOR.Overlay0};opacity:0.75;`;
            } else {
              // not open
              btn.css = `background-color:${COLOR.Surface1};opacity:0.5;`;
            }
          }),
        ),
    }),
  });
