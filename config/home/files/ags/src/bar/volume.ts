import * as COLOR from "colours.json";

const audio = await Service.import("audio");

audio.maxStreamVolume = 1;

const VolumeSlider = () =>
  Widget.Slider({
    hexpand: true,
    drawValue: false,
    onChange: ({ value }) => (audio.speaker.volume = value),
    value: audio.speaker.bind("volume"),
  });

const oldVolumeIndicator = () =>
  Widget.Icon().hook(audio.speaker, (self) => {
    const vol = audio.speaker.volume * 100;
    let icon = [
      [101, "overamplified"],
      [67, "high"],
      [34, "medium"],
      [1, "low"],
      [0, "muted"],
    ].find(([threshold]) => Number(threshold) <= vol)?.[1];
    if (audio.speaker.is_muted) {
      icon = "muted";
    }

    self.icon = `audio-volume-${icon}-symbolic`;
    self.css = "font-size:15px;";
  });

type formFactor =
  | "internal"
  | "speaker"
  | "handset"
  | "tv"
  | "webcam"
  | "microphone"
  | "headset"
  | "headphone"
  | "hands-free"
  | "car"
  | "hifi"
  | "computer"
  | "portable";

export const FormFactorIcon = (formFactor: formFactor) => {
  switch (formFactor) {
    case "headphone":
    case "headset":
      return "";
    case "webcam":
    case "handset":
    case "hands-free":
    case "portable":
      return "";
    default:
      return "";
  }
};

const VolumeIndicator = () =>
  Widget.Label({
    css: "font-size:18px;",
    label: Utils.merge(
      [audio.speaker.bind("stream"), audio.speaker.bind("is_muted")],
      (stream, is_muted) => {
        if (is_muted) {
          return "";
        }

        const formFactor = (stream?.formFactor ?? "speaker") as formFactor;

        return FormFactorIcon(formFactor);
      },
    ),
  });

export const VolumeWheel = () =>
  Widget.Button({
    className: "flat",
    css: "box-shadow: none;text-shadow: none;background: none;padding: 0;",
    onClicked: () => (audio.speaker.is_muted = !audio.speaker.is_muted),
    //onSecondaryClick: () => Utils.execAsync(nix.audio_changer).catch(print),
    onSecondaryClick: () => App.openWindow("sink-picker"),
    tooltipText: Utils.merge(
      [audio.speaker.bind("volume"), audio.speaker.bind("description")],
      (vol, name) => `${name}\nVolume ${Math.floor(vol * 100)}%`,
    ),
    onScrollUp: () => {
      audio.speaker.volume += 0.015;
    },
    onScrollDown: () => (audio.speaker.volume -= 0.015),

    child: Widget.CircularProgress({
      css:
        "min-width: 40px;" + // its size is min(min-height, min-width)
        "min-height: 40px;" +
        "font-size: 6px;" + // to set its thickness set font-size on it
        "margin: 1px;" + // you can set margin on it
        `background-color: ${COLOR.Surface1};` + // set its bg color
        `color: ${COLOR.Highlight};`,
      rounded: false,
      inverted: false,
      startAt: 0.4,
      endAt: 0.105,
      value: audio.speaker.bind("volume"),
      child: VolumeIndicator(),
    }),
  });
