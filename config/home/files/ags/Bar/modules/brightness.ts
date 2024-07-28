import brightness from '../../Services/brightness.ts'

export const BrightnessSlider = () => {
  const slider = Widget.Slider({
    hexpand: true,
    drawValue: false,
    on_change: self => brightness.screen_value = self.value,
    value: brightness.bind('screen-value'),
  });

  const icon = Widget.Label({
    label: "🔆"
  })

  return Widget.Box({
    class_name: "volume",
    tooltipText: brightness.bind("screen-value").as((value) => `Brightness - ${(value * 100).toFixed(0)}%`),
    css: "min-width: 140px",
    children: [icon, slider]
  })
}