{ lib, config, pkgs, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  programs.fish.enable = true;

  users.users.dan = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ifTheyExist [
      "audio"
      "docker"
      "git"
      "i2c"
      "libvirtd"
      "network"
      "networkmanager"
      "plugdev"
      "podman"
      "video"
      "wheel"
    ];

    packages = with pkgs; [
      home-manager
    ];
  };

  home-manager.users.dan = import ../../../../home/dan/${config.networking.hostName}.nix;
}
