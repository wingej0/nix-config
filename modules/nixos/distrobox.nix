{ config, pkgs, lib, ... }:
{
  imports = [];

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enable = true;      
    };
    
  };

  environment.systemPackages = with pkgs; [
   podman-tui
   podman-compose
   distrobox
  ];
  
}