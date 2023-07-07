{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thejevans = {
    isNormalUser = true;
    description = "John Evans";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      neovim
      github-cli
    ];
  };
}
