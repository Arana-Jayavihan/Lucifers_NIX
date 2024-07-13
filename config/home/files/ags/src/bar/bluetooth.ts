import { type BluetoothDevice } from "@ags/service/bluetooth";

import * as COLOR from "colours.json";

const bluetooth = await Service.import("bluetooth");

const BluetoothWheel = (device: BluetoothDevice) =>
  Widget.Revealer({
    transition: "slide_right",
    transitionDuration: 750,
    revealChild: false,
    setup: (self) => {
      Utils.timeout(0, () => (self.revealChild = true));
    },
    child: Widget.Button({
      className: "flat",
      css: "box-shadow: none;text-shadow: none;background: none;padding: 0;margin-right:1px;margin-left:4px;",
      tooltipText: device
        .bind("battery_percentage")
        .as((p) => `${device.alias}\nBattery: ${Math.floor(p)}%`),

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
        startAt: 0.75,
        value: device.bind("battery_percentage").as((p) => p / 100),
        /*child: Widget.Icon({
        icon: device.icon_name + "-symbolic",
				
        css: "font-size:15px;",
      }),*/
        child: Widget.Label({
          css: "font-size:13px;",
          label: "󰥉",
        }),
      }),
    }),
  });

export const BluetoothWheels = () =>
  Widget.Box({
    //children: bluetooth.connected_devices.map(BluetoothWheel),
    attribute: {
      prev_addresses: bluetooth.connected_devices.map((x) => x.address),
      map: new Map<string, ReturnType<typeof BluetoothWheel>>(),
    },
    setup: (self) => {
      for (const device of bluetooth.connected_devices) {
        self.attribute.map.set(device.address, BluetoothWheel(device));
      }
      self.children = Array.from(self.attribute.map.values());

      self.hook(
        bluetooth,
        (self) => {
          const prev = self.attribute.prev_addresses;

          // no change
          if (bluetooth.connected_devices.length === prev.length) {
            return;
          }

          // connected to a new device
          if (bluetooth.connected_devices.length > prev.length) {
            let address = undefined;
            for (const device of bluetooth.connected_devices) {
              if (!prev.includes(device.address)) {
                address = device.address;
              }
            }

            if (address === undefined) return;

            self.attribute.prev_addresses = bluetooth.connected_devices.map(
              (x) => x.address,
            );
            let device = bluetooth.getDevice(address)!;

            let wheel = BluetoothWheel(device);
            self.attribute.map.set(address, wheel);
            self.pack_end(wheel, false, false, 0);
            self.show_all();
            return;
          }

          // disconnected from a device
          if (bluetooth.connected_devices.length < prev.length) {
            const newAddresses = bluetooth.connected_devices.map(
              (x) => x.address,
            );
            let address = undefined;
            for (const oldAddress of prev) {
              if (!newAddresses.includes(oldAddress)) {
                address = oldAddress;
              }
            }

            if (address === undefined) return;

            self.attribute.prev_addresses = bluetooth.connected_devices.map(
              (x) => x.address,
            );
            let wheel = self.attribute.map.get(address)!;

            wheel.revealChild = false;
            Utils.timeout(1000, () => {
              self.attribute.map.delete(address)!;
              wheel.destroy();
            });

            return;
          }
        },
        "notify::connected-devices",
      );
    },
  });
