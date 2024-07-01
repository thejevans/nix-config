{ ... }:

let

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

main_disk = {
  device = "/dev/nvme0n1";
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

in

{
  imports = [];

  options = {};

  config = {
    disko.devices = {
      disk.main = main_disk;
      zpool.rpool = rpool_zfs_pool;
    };
  };
}
