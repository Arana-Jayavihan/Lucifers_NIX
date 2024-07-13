const time = Variable("", {
  poll: [1000, `date "+%H:%M:<span fgalpha='60%'>%S</span>\n%Y/%m/%d"`],
});

export const Date = () =>
  Widget.Label({
    css: "font-size:1.2em",
    hpack: "start",
    useMarkup: true,
    label: time.bind(),
  });
