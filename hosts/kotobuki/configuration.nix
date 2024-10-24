{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.apple-macbook-air-4
  ];

  options = {};

  config = {
    singleDiskZfsImpermanenceDisko = {
      enable = true;
      device = "/dev/nvme0n1";
    };

    # Add support for backlight
    boot.kernelParams = ["acpi_backlight=video"];
  };
}
