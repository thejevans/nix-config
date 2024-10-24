{
  config,
  lib,
  pkgs,
  ...
}: let
  # -----------------------------------------------------------------------------
  # partitions
  # -----------------------------------------------------------------------------
  ESP_partition = {
    size = "500M";
    type = "EF00";
    content = {
      type = "filesystem";
      format = "vfat";
      mountpoint = "/boot";
    };
  };

  zfs_partition = {
    size = "100%";
    content = {
      type = "zfs";
      pool = "rpool";
    };
  };

  # -----------------------------------------------------------------------------
  # disks
  # -----------------------------------------------------------------------------

  main_disk = {device}: {
    inherit device;
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = ESP_partition;
        zfs = zfs_partition;
      };
    };
  };

  # -----------------------------------------------------------------------------
  # zfs datasets
  # -----------------------------------------------------------------------------

  local_dataset = {
    type = "zfs_fs";
    options.mountpoint = "none";
  };

  safe_dataset = {
    type = "zfs_fs";
    options.mountpoint = "none";
  };

  local_root_dataset = {
    type = "zfs_fs";
    mountpoint = "/";
    postCreateHook = ''
      zfs snapshot rpool/local/root@blank
    '';
  };

  local_nix_dataset = {
    type = "zfs_fs";
    mountpoint = "/nix";
    options = {
      atime = "off";
      canmount = "on";
    };
  };

  local_cache_dataset = {
    type = "zfs_fs";
    mountpoint = "/cache";
  };

  safe_home_dataset = {
    type = "zfs_fs";
    mountpoint = "/home";
    options."com.sun:auto-snapshot" = "true";
  };

  safe_persistent_dataset = {
    type = "zfs_fs";
    mountpoint = "/persistent";
    options."com.sun:auto-snapshot" = "true";
  };

  # -----------------------------------------------------------------------------
  # zfs pools
  # -----------------------------------------------------------------------------

  rpool_zfs_pool = {
    type = "zpool";
    mountpoint = null;
    mode = "";
    rootFsOptions = {
      compression = "lz4";
      "com.sun:auto-snapshot" = "false";
    };
    datasets = {
      local = local_dataset;
      safe = safe_dataset;
      "local/root" = local_root_dataset;
      "local/nix" = local_nix_dataset;
      "local/cache" = local_cache_dataset;
      "safe/home" = safe_home_dataset;
      "safe/persistent" = safe_persistent_dataset;
    };
  };
in {
  imports = [];

  options.singleDiskZfsImpermanenceDisko = {
    enable = lib.mkEnableOption "enables single disk ZFS impermanence disko";
    device = lib.mkOption {type = lib.types.str;};
  };

  config = lib.mkIf config.singleDiskZfsImpermanenceDisko.enable {
    disko.devices = {
      disk.main = main_disk {device = config.singleDiskZfsImpermanenceDisko.device;};
      zpool.rpool = rpool_zfs_pool;
    };

    boot.initrd.systemd.enable = true;
    boot.swraid.enable = false;

    services.zfs.trim.enable = true;
    services.zfs.autoScrub.enable = true;

    boot.initrd.systemd.services.rollback = {
      description = "";
      wantedBy = [
        "initrd.target"
      ];
      after = [
        "zfs-import-rpool.service"
      ];
      before = [
        "sysroot.mount"
      ];
      path = with pkgs; [
        zfs
      ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        zfs rollback -r rpool/local/root@blank && echo "  >> >> rollback complete << <<"
      '';
    };

    fileSystems = {
      "/cache".neededForBoot = true;
      "/persistent".neededForBoot = true;
    };

    networking.hostId = builtins.substring 0 8 (
      builtins.hashString "sha256" config.networking.hostName
    );

    environment.persistence."/persistent" = {
      hideMounts = true;
      directories = [
        "/etc/NetworkManager/system-connections"
        "/etc/ssh/authorized_keys.d"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/upower"
        "/var/log"
        "/var/lib/fprint"
        "/var/lib/flatpak/"
      ];
      files = [
        "/etc/adjtime"
        "/etc/machine-id"
        "/etc/zfs/zpool.cache"
      ];
    };

    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';
  };
}
