interface nix {
  bun: string;
  show_clipboard: string;
  audio_changer: string;
  wifi_menu: string;
  bluetooth_menu: string;
}
export const nix: nix = JSON.parse(
  Utils.readFile(`/home/${Utils.USER}/.local/share/ags/nix.json`),
);
