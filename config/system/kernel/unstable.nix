# Kernel (and therefore the whole out-of-tree module set, including the nvidia
# driver) taken from nixpkgs-unstable instead of the pinned release channel.
#
# Needed on hosts where the release channel's nvidia driver is too old for the
# release channel's `linuxPackages_latest`: kernel 7.2-rc1 removed `strncpy()`
# from <linux/string.h>, which nvidia-open 595.71.05 still calls, so nvidia
# fails to build on every kernel >= 7.2. NVIDIA fixed it in 610.57.04, and
# unstable carries 615.x.
#
# config/system/nvidia.nix picks the driver off config.boot.kernelPackages, so
# selecting this kernel also moves the driver to the matching unstable version;
# nothing else there needs to change.
{ lib, pkgs-unstable, opt, ... }:

lib.mkIf (opt.theKernel == "unstable") {
  boot.kernelPackages = pkgs-unstable.linuxPackages_latest;
}
