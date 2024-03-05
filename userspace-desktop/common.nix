{ config, pkgs, ... }:

{
  # Import userspace-common.
  imports = [ ../userspace-common.nix ];
  environment.variables.MOZ_USE_XINPUT2 = "1";
}
