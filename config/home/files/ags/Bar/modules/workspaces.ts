const hyprland = await Service.import("hyprland");

export const Workspaces = (monitor = 0) => {
  const activeId = hyprland.active.workspace.bind("id");
  let workspaces = hyprland.bind("workspaces").as((ws) =>
    ws
      .filter((ws) => ws.monitorID === monitor)
      .sort((a, b) => a.id - b.id)
      .map(({ id }) =>
        Widget.Button({
          on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
          child: Widget.Label(`${id}`),
          class_name: activeId.as((i) => `${i === id ? "focused" : ""}`),
        })
      )
  );
  return Widget.Box({
    class_name: "workspaces",
    children: workspaces,
  });
};
