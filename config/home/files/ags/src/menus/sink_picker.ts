import { Stream } from "@ags/service/audio";

import * as COLOR from "colours.json";

import Gdk from "gi://Gdk";
import Gtk from "gi://Gtk";

import { FormFactorIcon } from "bar/volume";

const audio = await Service.import("audio");
const WINDOW_NAME = "sink-picker";

const AppItem = (app: Stream) =>
  Widget.Button({
    css: "margin:2px;margin-bottom:0px",
    on_clicked: () => {
      App.closeWindow(WINDOW_NAME);
      audio.control.set_default_sink(app.stream!);
    },
    attribute: { stream: app.stream, name: app.name ?? "" },
    child: Widget.Box({
      children: [
        Widget.Label({
          vpack: "center",
          css: "font-size: 20px;margin-right:8px;",
          label: FormFactorIcon(app.stream?.form_factor ?? ""),
        }),
        Widget.Label({
          css: "font-size: 20px",
          class_name: "title",
          label: app.description,
          xalign: 0,
          vpack: "center",
          wrap: true,
        }),
      ],
    }),
  });

function applicationsList() {
  let applications = audio.speakers.map(AppItem);
  return applications;
}

const Applauncher = ({ width = 500, height = 500, spacing = 12 }) => {
  // list of application buttons
  let applications = applicationsList();

  // container holding the buttons
  const list = Widget.Box({
    vertical: true,
    children: applications,
    spacing,
  });

  // repopulate the box, so the most frequent apps are on top of the list
  function repopulate() {
    applications = applicationsList();

    list.children = applications;
  }

  setTimeout(repopulate, 3000);

  function filterList(text) {
    let first = true;
    for (const item of applications) {
      item.canFocus = true;
      let visible = item.attribute.name.includes(text ?? "");
      item.visible = visible;
      // skip focus over first item, because the entry bar is already the first item
      if (first && visible) {
        item.canFocus = false;
        first = false;
      }
    }
  }

  // wrap the list in a scrollable
  const scrollableList = Widget.Scrollable({
    hscroll: "never",
    css: `min-width: ${width}px;` + `min-height: ${height}px;`,
    child: list,
  });

  // search entry
  const entry = Widget.Entry({
    hexpand: true,
    css: `margin-bottom: ${spacing}px;`,

    // to launch the first item on Enter
    on_accept: () => {
      // make sure we only consider visible (searched for) applications
      const results = applications.filter((item) => item.visible);

      if (results[0]) {
        App.toggleWindow(WINDOW_NAME);
        audio.control.set_default_sink(results[0].attribute.stream!);
      }
    },

    // filter out the list
    on_change: ({ text }) => filterList(text),
  }).on("focus_in_event", () => scrollableList.get_vadjustment().set_value(0));

  return Widget.Box({
    vertical: true,
    css: `margin: ${spacing * 2}px;`,
    children: [entry, scrollableList],
    setup: (self) =>
      self.hook(App, (_, windowName, visible) => {
        if (windowName !== WINDOW_NAME) return;

        // when the applauncher shows up
        if (visible) {
          repopulate();
          entry.text = "";
          filterList("");
          entry.grab_focus();
        }
      }),
  }).on("key-press-event", (_, event: Gdk.Event) => {
    const keyval = event.get_keyval()[1];
    if (keyval == Gdk.KEY_Return || keyval == Gdk.KEY_Tab) {
      return;
    }
    // check if it is a valid character or something like an arrow key or modifier
    const char = Gdk.keyval_to_unicode(keyval);
    if (char != 0) {
      entry.grab_focus_without_selecting();
      entry.event(event);
    }
  });
};

// there needs to be only one instance
export const SinkPicker = Widget.Window({
  css: `border-radius:25px;background-color:${COLOR.Base}`,
  name: WINDOW_NAME,
  setup: (self) =>
    self.keybind("Escape", () => {
      App.closeWindow(WINDOW_NAME);
    }),
  keymode: "exclusive",
  visible: false,
  child: Applauncher({
    width: 500,
    height: 500,
    spacing: 12,
  }),
});
