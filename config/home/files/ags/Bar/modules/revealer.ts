import { Volume } from "./volume.ts";
import { BrightnessSlider } from "./brightness.ts";
import { BatteryLabel } from "./battery.ts";

export const revealerState = Variable({
  state: false,
});

export const RevealerButton = () => {
  const handleButtonClick = () => {
    setTimeout(() => {
      if (revealerState.value.state == true) {
        revealerState.setValue({ state: false });
      }
    }, 180000);

    if (revealerState.value.state == false) {
      revealerState.setValue({ state: true });
    } else {
      revealerState.setValue({ state: false });
    }
  };

  return Widget.Button({
    class_name: "revealerButton",
    setup: (self) =>
      self.hook(revealerState, () => {
        (self.on_clicked = () => handleButtonClick()),
          (self.label = revealerState.value.state == true ? ">>>" : "<<<");
          (self.tooltip_text = revealerState.value.state == true ? "Close" : "Open");
      }),
  });
};

export const Revealer = () => {
  return Widget.Revealer({
    transitionDuration: 500,
    transition: "slide_right",
    setup: (self) =>
      self.hook(revealerState, () => {
        self.reveal_child = revealerState.value.state;
      }),
    child: Widget.Box({
      children: [BatteryLabel("revealer"), BrightnessSlider(), Volume()],
    }),
  });
};
