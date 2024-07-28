export const SysStats = () => {
  const Ram = () => {
    const ram = Variable(
      { total: 0, used: 0 },
      {
        poll: [
          1000,
          [
            "bash",
            "-c",
            `cat /proc/meminfo | awk '/MemTotal/ {total=$2} /MemAvailable/ {available=$2} END {print total ":" available}'`,
          ],
          (x) => {
            let split = x.split(":");
            return {
              total: Number(split[0]),
              used: Number(split[0] - split[1]),
            };
          },
        ],
      }
    );

    return Widget.Box({
      tooltipText: ram
        .bind()
        .as(
          (x) =>
            `${(x.used / 1024 / 1024).toFixed(2)}GB / ${(
              x.total /
              1024 /
              1024
            ).toFixed(2)}GB (${((x.used / x.total) * 100).toFixed(2)}%)`
        ),
      class_name: "info-child",
      children: [
        Widget.Label({ label: " " }),
        Widget.Label({
          label: ram
            .bind()
            .as((x) => `${((x.used / x.total) * 100).toFixed(0)}%`),
        }),
      ],
    });
  };

  const Cpu = () => {
    const cpu = Variable(0, {
      poll: [
        1000,
        [
          "bash",
          "-c",
          String.raw`mpstat 1 1 -o JSON | grep '"cpu":' | awk -F ' ' '{print 100 - $22}'`,
        ],
      ],
    });

    return Widget.Box({
      tooltipText: cpu.bind().as((x) => `${x}%`),
      class_name: "info-child",
      children: [
        Widget.Label({ label: "󰓅 " }),
        Widget.Label({
          label: cpu.bind().as((x) => `${parseFloat(x).toFixed(0)}%`),
        }),
      ],
    });
  };
  return Widget.Box({
    class_name: "info-bars",
    children: [Cpu(), Ram()],
  });
};
