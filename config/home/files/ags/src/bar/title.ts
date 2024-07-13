const hyprland = await Service.import("hyprland");

export const FocusedTitle = () =>
  Widget.Box({
    vertical: true,
    children: [
      Widget.Label({
        hpack: "start",
        truncate: "end",
        maxWidthChars: 45,
        label: hyprland.active.client.bind("title"),
      }),
      Widget.Label({
        hpack: "start",
        css: "opacity: 0.6",
        truncate: "end",
        maxWidthChars: 40,
        label: hyprland.active.client.bind("class"),
        visible: hyprland.active
          .bind("client")
          .as((x) => !(x.title === x.class)),
      }),
    ],
    visible: hyprland.active.client.bind("address").as((addr) => Boolean(addr)),
  });
