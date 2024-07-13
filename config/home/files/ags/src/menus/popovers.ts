import { Binding } from "@ags/service";
import { Props } from "@ags/service";

import * as COLOR from "colours.json";

import GLib from "gi://GLib";
import GObject from "gi://GObject";
import Gtk from "gi://Gtk";

import brightness from "services/brightness";

const WINDOW_NAME = "popovers";

const audio = await Service.import("audio");
const mpris = await Service.import("mpris");

const animationTime = 500;
function Popover<
  Emitter extends GObject.Object,
  Prop extends keyof Props<Emitter>,
>(
  binding: Binding<Emitter, Prop, number>,
  icon: string,
  startRevealed: boolean,
) {
  const widget = Widget.EventBox({
		// it's okay because emitter[prop] is for sure number
    onScrollUp: () => binding.emitter[binding.prop] += 0.015,
    onScrollDown: () => (binding.emitter[binding.prop] -= 0.015),
    attribute: {
      reveal: () => {
        widget.child.revealChild = true;
      },
      hide: () => {
        widget.child.revealChild = false;
      },
    },
    child: Widget.Revealer({
      css: "min-width:1px;min-height:1px;",
      revealChild: startRevealed,
      transition: "slide_right",
      transitionDuration: animationTime,
      setup: (self) => {
        if (!startRevealed) {
          Utils.timeout(10, () => (self.revealChild = true));
        }
      },
      child: Widget.Box({
        css: `padding:10px;margin:5px;border-radius:5px;
			background-color:${COLOR.Surface0};font-size:20px`,
        child: Widget.Label({
          label: binding.as((p) => {
            return `${icon} ${Math.round(p * 1000) / 10}%`;
          }),
        }),
      }),
    }),
  });
  return widget;
}

export const Popovers = Widget.Window({
  css: "background-color:transparent;",
  name: WINDOW_NAME,
  visible: true,
  anchor: ["top"],
  child: Widget.Box({
    css: "padding:1px;",
    child: Widget.Revealer({
      attribute: {
        timeouts: {},
        widgets: {},
      } as {
        timeouts: Record<string, GLib.Source>;
        widgets: Record<string, ReturnType<typeof Popover>>;
      },
      setup: (self) => {
        function display<
          Emitter extends GObject.Object,
          Prop extends keyof Props<Emitter>,
        >(name: string, binding: Binding<Emitter, Prop, number>) {
          if (!(name in self.attribute.widgets)) {
            self.revealChild = true;
            let popover: ReturnType<typeof Popover>;
            if (self.child.children.length === 0) {
              popover = Popover(binding, name, true);
            } else {
              popover = Popover(binding, name, false);
            }

            self.attribute.widgets[name] = popover;

            self.child.pack_start(popover, false, false, 0);
            self.child.show_all();
          }

          if (self.attribute.timeouts[name]) {
            clearTimeout(self.attribute.timeouts[name]);
          }
          if (self.attribute.widgets[name]) {
            self.attribute.widgets[name].show();
            self.revealChild = true;
          }
          self.attribute.timeouts[name] = setTimeout(() => {
            const popover = self.attribute.widgets[name];
            if (self.child.children.length !== 1) {
              popover.attribute.hide();
            } else {
              self.revealChild = false;
            }
            self.attribute.timeouts[name] = setTimeout(() => {
              popover.destroy();
              delete self.attribute.timeouts[name];
              delete self.attribute.widgets[name];
              if (self.child.children.length === 0) {
                self.revealChild = false;
              }
            }, animationTime + 50);
          }, 2000);
        }

        self.hook(
          audio.speaker,
          () => display("volume", audio.speaker.bind("volume")),
          "notify::volume",
        );
        self.hook(
          brightness,
          () => display("brightness", brightness.bind("screen_value")),
          "screen_changed",
        );
        /*Utils.timeout(3000, () => {
          self.hook(
            mpris.players[0],
            () => display("player", mpris.players[0].bind("position")),
            "position",
          );
        });*/
      },
      revealChild: false,
      transitionDuration: animationTime,
      transition: "slide_down",
      child: Widget.Box({
        css: "padding: 10px;",
        children: [],
      }),
    }),
  }),
});
