import { revealerState } from "./revealer.ts";
export const Clock = () => {
  const date = Variable("", {
    poll: [1000, 'date "+%I:%M %p %b %e"'],
  });
  return Widget.Label({
    setup: self => self.hook(revealerState, () => {
      self.visible = !revealerState.value.state
    }),
    class_name: "clock",
    label: date.bind().as((date) => ` ${date}`),
  });
};
