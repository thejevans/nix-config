{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [];

  options = {
    nixosModules.ld.enable = lib.mkEnableOption "enables ld";
  };

  config = lib.mkIf config.nixosModules.ld.enable {
    environment.systemPackages = with inputs.nix-alien.packages.${config.globalConfig.system}; [
      nix-alien
    ];

    programs.nix-ld.enable = true;
  };
}
