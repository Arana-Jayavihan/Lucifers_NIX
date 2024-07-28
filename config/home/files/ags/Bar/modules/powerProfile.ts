const powerProfiles = await Service.import("powerprofiles");

export const PowerProfile = () => {
  return Widget.Button({
    tooltipText: powerProfiles
      .bind("active-profile")
      .as((profile) => `Active - ${profile}`),
    class_name: "power-profile",
    on_clicked: () => {
      switch (powerProfiles.active_profile) {
        case "balanced":
          powerProfiles.active_profile = "performance";
          break;
        case "performance":
          powerProfiles.active_profile = "power-saver";
          break;
        default:
          powerProfiles.active_profile = "balanced";
          break;
      }
    },
    child: Widget.Label({
      label: powerProfiles
        .bind("active_profile")
        .as((profile) =>
          profile === "performance"
            ? "🚀"
            : profile === "balanced"
            ? "🍃"
            : profile === "power-saver"
            ? "🔋"
            : ""
        ),
    }),
  });
};
