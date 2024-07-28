const hyprland = await Service.import("hyprland");

export const ClientTitle = () => {
  const winTitle = hyprland.active.client.bind("title");

  return Widget.Box({
    tooltipText: winTitle,
    class_name: "client-title-box",
    children: [
      Widget.Label({
        visible: winTitle.as((wTitle) => wTitle != ""),
        hpack: "start",
        truncate: "middle",
        maxWidthChars: 32,
        class_name: "client-title",
        label: winTitle,
      }),
      Widget.Label({
        visible: winTitle.as((wTitle) => wTitle == ""),
        hpack: "start",
        truncate: "end",
        maxWidthChars: 15,
        class_name: "client-title",
        label: " ~ ",
      }),
    ],
  });
};
