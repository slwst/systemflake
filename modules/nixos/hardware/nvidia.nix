{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nixos.hardware.nvidia;
in {
  options.modules.nixos.hardware.nvidia = {
    enable = mkEnableOption "Enable NVIDIA";
  };

  config = mkIf cfg.enable {

    # Load modules on boot
    boot.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    /*
      "ibt=off"
      "CONFIG_DRM_SIMPLEDRM=y"
      "module_blacklist=i915"
      "processor.max_cstate=1"
      "pcie_aspm=off"
      */
    boot.kernelParams = [
    ];

    services.xserver = {
      videoDrivers = ["nvidia"];
    };
    /*
      __GL_MaxFramesAllowed = "1";
    */

    environment.variables = {
      # GBM_BACKEND is deliberately unset: libgbm derives the backend name from
      # the DRM driver and both nvidia-drm_gbm.so (64- and 32-bit) ship in
      # /run/opengl-driver*/lib/gbm, so forcing it only leaks into sandboxes
      # that lack the backend (seen as MESA-LOADER failures inside Steam's
      # pressure-vessel container).
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      VKD3D_CONFIG = "dxr";
      PROTON_ENABLE_NGX_UPDATER = "1";
      PROTON_ENABLE_NVAPI = "1";
    };
    environment.systemPackages = with pkgs; [
      vulkan-validation-layers
      nvtopPackages.nvidia
      cudatoolkit
      ];

    hardware = {
    /*
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          vaapiVdpau
          libvdpau-va-gl
        ];
        #setLdLibraryPath = true;
      };
      */
      graphics.enable = true;
      nvidia-container-toolkit.enable = true;
      nvidia = {
        # Xorg-only: nixpkgs applies this purely as an X screen "metamodes"
        # option, so it does nothing in a Wayland session. On X it costs OpenGL
        # performance and delays clocking down, so leave it off.
        forceFullCompositionPipeline = false;
        modesetting.enable = true;
        powerManagement.enable = true;

        # should be one release behind latest or stable
        #package = config.boot.kernelPackages.nvidiaPackages.beta;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        nvidiaSettings = true;

        # experimental
        open = false;
      };
    };
  };
}
