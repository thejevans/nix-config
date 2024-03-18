# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Include the results of the hardware scan.
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Include common configuration
    ../host-common.nix

    # Include userspace configuration
    ../userspace-desktop/cosmic.nix
  ];

  networking.hostName = "mujina"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Denver";

  # power management
  services.auto-cpufreq.enable = true;
  services.thermald.enable = true;

  services.avahi.enable = true;
  networking.firewall.allowedTCPPorts = [ 8010 ];
}
