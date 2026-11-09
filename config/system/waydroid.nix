{ lib, pkgs, opt, ... }:

# Waydroid itself is enabled in ../../system.nix (virtualisation.waydroid).
# This module only fixes rendering on nvidia hosts.
#
# Waydroid picks its own DRM render node and hard-codes nvidia as unsupported
# (tools/helpers/gpu.py: `unsupported = ["nvidia"]`), so on gondor it lands on
# the AMD iGPU (renderD129) while Hyprland renders *and* scans out on the RTX
# 5070 -- the only card with a monitor attached. The hwcomposer then asks gbm
# for buffers using the compositor's NVIDIA tiling modifiers on an AMD device,
# every allocation fails, and no Wayland surface is ever mapped. Symptom: the
# container boots, all HALs run, `waydroid show-full-ui` returns cleanly over
# binder, and no window appears.
#
# Fix: take the GPU out of the loop. gralloc=default hands out CPU buffers, so
# the hwcomposer uses its wl_shm path (create_shm_wl_buffer) instead of dmabuf,
# which any compositor can display no matter which GPU it lives on. Upstream
# documents egl=swiftshader for this, but the VANILLA system image ships no
# libEGL_swiftshader.so -- only libEGL_angle.so and libEGL_mesa.so -- so we run
# ANGLE over vulkan.pastel.so (SwiftShader's Vulkan ICD), which is present.
#
# Cost: Android renders on the CPU. Fine for ordinary apps, slow for 3D games.
# The only route back to hardware acceleration is putting the compositor on the
# same GPU Waydroid uses -- AQ_DRM_DEVICES=/dev/dri/card2:/dev/dri/card1, or
# moving the monitor to the motherboard's output -- which drags all desktop
# compositing onto the iGPU and adds a cross-GPU blit per frame.
#
# The helper seeds both the [properties] section of waydroid.cfg (so a later
# `waydroid upgrade` keeps the settings) and waydroid_base.prop (what a session
# start actually reads). Both live in /var/lib/waydroid, which no NixOS module
# owns, so this runs on every container start to survive a `waydroid init -f`.

{
  systemd.services.waydroid-container.preStart =
    lib.mkIf (opt.gpuType == "nvidia")
      "${pkgs.python3}/bin/python3 ${./waydroid-swrender.py}";
}
