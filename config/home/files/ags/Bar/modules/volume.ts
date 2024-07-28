const audio = await Service.import("audio");
const bluetooth = await Service.import("bluetooth");

export const Volume = () => {
    const icons = {
      101: "overamplified",
      67: "high",
      34: "medium",
      1: "low",
      0: "muted",
    };
  
    const getIcon = () => {
      const icon = audio.speaker.is_muted
        ? 0
        : [101, 67, 34, 1, 0].find(
            (threshold) => threshold <= audio.speaker.volume * 100
          );
  
      return `audio-volume-${icons[icon]}-symbolic`;
    };
  
    const icon = Widget.Icon({
      icon: Utils.watch(getIcon(), audio.speaker, getIcon),
    });
  
    const connectedList = Widget.Box({
      setup: (self) =>
        self.hook(
          bluetooth,
          (self) => {
            self.children = bluetooth.connected_devices.map(
              ({ icon_name, name }) =>
                Widget.Box([
                  Widget.Icon({
                    icon: icon_name + "-symbolic",
                    tooltipText: name,
                    css: "margin: 0px 0.2rem;",
                  }),
                ])
            );
  
            self.visible = bluetooth.connected_devices.length > 0;
          },
          "notify::connected-devices"
        ),
    });
  
    const VolumeSlider = (type = "speaker") =>
      Widget.Slider({
        hexpand: true,
        drawValue: false,
        onChange: ({ value }) => (audio[type].volume = value),
        value: audio[type].bind("volume"),
      });
  
    const speakerSlider = VolumeSlider("speaker");
  
    return Widget.Box({
      tooltipText: audio.speaker.bind('volume').as((volume) => `Volume - ${(volume * 100).toFixed(0)}%`),
      class_name: "volume",
      css: "min-width: 140px",
      children: [connectedList, icon, speakerSlider],
    });
  };