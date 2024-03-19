{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thejevans = {
    isNormalUser = true;
    description = "John Evans";
    home = "/home/thejevans";
    group = "thejevans";
    extraGroups = [ "networkmanager" "wheel" "uinput" ];
    shell = pkgs.fish;
  };

  users.groups.thejevans = {};

  programs.fish.enable = true;
}
