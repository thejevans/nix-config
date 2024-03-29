{ inputs, config, pkgs, lib, ... }: {

  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.apple-macbook-air-4
  ];

  options = {};

  config = {
    # Add support for backlight
    boot.kernelParams = [ "acpi_backlight=video" ];
  };

}
