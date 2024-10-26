{ lib, pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/dan

    ../common/optional/cups.nix
    ../common/optional/dconf.nix
    ../common/optional/flatpak.nix
    ../common/optional/fonts.nix
    ../common/optional/ntp.nix

    ../common/optional/audio/pipewire.nix
    ../common/optional/boot/systemd-boot.nix
    ../common/optional/boot/quietboot.nix
    ../common/optional/desktop/gnome.nix
    ../common/optional/network/networkmanager.nix
    ../common/optional/peripherals/trackpoint.nix
  ];

  networking.hostName = "sake";

  # Use proper graphics driver
  boot.kernelParams = [ "i915.force_probe=46a6" ];

  # Weekly garbage collection
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  system.stateVersion = "24.05";
}
