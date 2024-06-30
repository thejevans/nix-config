{ inputs, pkgs, ... }: {

  imports = [
    ./personal_workstation.nix
  ];

  options = {};

  config = {
    homeManagerModules = {
      pipewireScarlett8i6.enable = true;
    };

    home.packages = with pkgs; [
      openrgb
    ];
  };

}
