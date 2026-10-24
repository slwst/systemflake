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
      GBM_BACKEND = "nvidia-drm";
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
        forceFullCompositionPipeline = true;
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
