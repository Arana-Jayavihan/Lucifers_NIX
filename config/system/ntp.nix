{ config, lib, options, ... }:

let inherit (import ../../options.nix) ntp; in
lib.mkIf (ntp == true) {
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
}
