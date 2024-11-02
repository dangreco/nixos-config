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
    ../common/optional/peripherals/fprintd.nix
    ../common/optional/peripherals/trackpoint.nix
  ];

  networking.hostName = "sake";

  # Use proper graphics driver
  boot.kernelParams = [ "i915.force_probe=46a6" ];

  # yubikey
  boot.initrd.kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
  boot.initrd.luks.yubikeySupport = true;

  # LUKS
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/492d2666-150e-4905-a731-283e0f6eaa10";
      preLVM = true;
      allowDiscards = true;
      yubikey = {
        slot = 2;
        twoFactor = true;
        gracePeriod = 30;
        keyLength = 64;
        saltLength = 64;
        
        storage = {
          device = "/dev/disk/by-uuid/E074-F678";
          fsType = "vfat";
          path = "/crypt-storage/default";
        };
      };
    };
  };

  # Weekly garbage collection
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Trusted users
  nix.extraOptions = ''
    trusted-users = root dan
  '';

  # Docker
  virtualisation.docker.enable = true;

  system.stateVersion = "24.05";
}
