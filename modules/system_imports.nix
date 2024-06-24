{ config, pkgs, ... }:
{
  imports = [
    ./nixos/distrobox.nix
    ./nixos/input-remapper.nix
    ./nixos/fonts.nix
  ];
}