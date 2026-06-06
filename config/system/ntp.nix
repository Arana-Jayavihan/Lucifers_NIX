{ config, lib, options, opt, ... }:

let inherit (opt) ntp; in
lib.mkIf (ntp == true) {
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
}
