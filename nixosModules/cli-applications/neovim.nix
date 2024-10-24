{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [];

  options = {
    nixosModules.neovim.enable = lib.mkEnableOption "enables neovim";
  };

  config = lib.mkIf config.nixosModules.neovim.enable {
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };
}
