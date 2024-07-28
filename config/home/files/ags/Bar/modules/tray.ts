import { revealerState } from "./revealer.ts";
const systemtray = await Service.import("systemtray");

export const SysTray = () => {
  const items = systemtray.bind("items").as((items) =>
    items.map((item) =>
      Widget.Button({
        child: Widget.Icon({ icon: item.bind("icon") }),
        on_primary_click: (_, event) => item.activate(event),
        on_secondary_click: (_, event) => item.openMenu(event),
        tooltip_markup: item.bind("tooltip_markup"),
      })
    )
  );

  return Widget.Box({
    setup: self => self.hook(revealerState, () => {
      self.visible = !revealerState.value.state
    }),
    class_name: "sys-tray",
    children: items,
  });
};