{ config, lib, ... }:

let inherit (import ../../options.nix) nfs nfsMountPoint nfsDevice; in
lib.mkIf (nfs == true) {
  fileSystems."${nfsMountPoint}" = {
    device = "${nfsDevice}";
    fsType = "nfs";
  };
  services = {
    rpcbind.enable = true;
    nfs.server.enable = true;
  };
}
