{ pkgs, lib, inputs, config, ... }: {

  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
  ];

  options = {};

  config = {
    singleDiskZfsImpermanenceDisko = {
      enable = true;
      device = "/dev/nvme0n1";
    };

    services.tlp = {
      enable = true;
      settings = {
        # source
        # https://knowledgebase.frame.work/en_us/optimizing-fedora-battery-life-r1baXZh

        # GPU
        INTEL_GPU_MIN_FREQ_ON_AC = 100;
        INTEL_GPU_MIN_FREQ_ON_BAT = 100;
        INTEL_GPU_MAX_FREQ_ON_AC = 1500;
        INTEL_GPU_MAX_FREQ_ON_BAT = 800;
        INTEL_GPU_BOOST_FREQ_ON_AC = 1500;
        INTEL_GPU_BOOST_FREQ_ON_BAT = 1000;

        # WIFI
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "off";
        WOL_DISABLE = "on";

        # PCIe
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";
        RUNTIME_PM_ON_AC = "off";
        RUNTIME_PM_ON_BAT = "on";

        # CPU
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 30;
        CPU_BOOST_ON_AC = "on";
        CPU_BOOST_ON_BAT = "off";
        CPU_HWP_DYN_BOOST_ON_AC = "on";
        CPU_HWP_DYN_BOOST_ON_BAT = "off";
        SCHED_POWERSAVE_ON_AC = "off";
        SCHED_POWERSAVE_ON_BAT = "on";
        NMI_WATCHDOG = "off";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        # USB
        USB_AUTOSUSPEND = "on";
        # From Framework: we recommend connecting any device you're going to
        # use and need to absolutely not disconnect via USB by running a lsusb
        # command in the terminal noting the device ID, then adding it to the
        # denylist - remember, the denylist means prevents it from using power
        # savings and potentially disconnecting. This includes HDMI, DisplayPort
        # and Ethernet expansion cards. Run lsusb, get those IDs and add them to
        # the denylist. External mouse? Run lsusb, get the ID and add it to the
        # denylist.
        #USB_DENYLIST = "1111:2222 3333:4444";
        USB_EXCLUDE_AUDIO = "on";
        USB_EXCLUDE_BTUSB = "off";
        USB_EXCLUDE_PHONE = "off";
        USB_EXCLUDE_PRINTER = "on";
        USB_EXCLUDE_WWAN = "off";
        USB_AUTOSUSPEND_DISABLE_ON_SHUTDOWN = "off";
      };
    };

    services.thermald.enable = true;
    services.power-profiles-daemon.enable = false;
    services.fwupd.enable = true;
  };
}
