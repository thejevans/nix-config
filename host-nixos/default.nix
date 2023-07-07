{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Include the common host configuration.
#    ../host-common.nix

    # Include home configuration
#    ../home-common.nix
  ];

  # Disables automatic brightness setting and enables keyboard brightness controls.
  # This is necessary due to a bug in the firmware on 12th-gen Intel Framework laptops.
  # Hopefully this will be fixed in the future, but no fix is available as of yet.
  # boot.kernelParams = [ "module_blacklist=hid_sensor_hub" ];

  networking = {
    hostName = "nixos"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

############# host-common.nix

  # Enable flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

#############

############# home-common.nix

 # Define a user account. Don't forget to set a password with ‘passwd’.
 users.users.thejevans = {
   isNormalUser = true;
   description = "John Evans";
   extraGroups = [ "networkmanager" "wheel" ];
   packages = with pkgs; [
     github-cli
     firefox
     kate
     plasma-browser-integration
   ];
 };

 # Enable the X11 windowing system.
 services.xserver.enable = true;

 # Enable the KDE Plasma Desktop Environment.
 services.xserver.displayManager.sddm.enable = true;
 services.xserver.desktopManager.plasma5.enable = true;

 # Configure keymap in X11
 services.xserver = {
   layout = "us";
   xkbVariant = "";
 };

 # Enable Firefox integration
 nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

 # Enable touchpad support (enabled default in most desktopManager).
 # services.xserver.libinput.enable = true;
 
#############
}
