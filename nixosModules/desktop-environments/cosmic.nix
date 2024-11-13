{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  options = {
    nixosModules.cosmic.enable = lib.mkEnableOption "enables COSMIC desktop environment";
  };

  config = lib.mkIf config.nixosModules.cosmic.enable {
    nix.settings = {
      substituters = ["https://cosmic.cachix.org/"];
      trusted-public-keys = [
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      ];
    };

    services = {
      # Enable the X11 windowing system.
      xserver = {
        enable = true;

        # Configure keymap in X11
        xkb = {
          layout = "us";
          variant = "";
        };

        # Enable touchpad support (enabled default in most desktopManager).
        # libinput.enable = true;
      };

      displayManager.cosmic-greeter.enable = true;
      desktopManager.cosmic.enable = true;

      kanata = {
        enable = true;
        keyboards = {
          "laptop_keeb".config = ''
            (defsrc
              grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
              tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
              caps a    s    d    f    g    h    j    k    l    ;    '    ret
              lsft z    x    c    v    b    n    m    ,    .    /    rsft
              lctl lmet lalt           spc            ralt rmet rctl
            )

            (deflayer vimkeys
              grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
              tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
              esc  a    s    d    f    g    h    j    k    l    ;    '    ret
              lsft z    x    c    v    b    n    m    ,    .    /    rsft
              lctl lmet lalt           spc            ralt rmet rctl
            )
          '';
        };
      };
    };
  };
}
