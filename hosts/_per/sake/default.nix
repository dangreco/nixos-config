{ _, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # full disk encryption
  boot.initrd.luks.devices = {
    "luks-1b99a986-5639-4ae3-acb5-ba977c655592" = {
      device = "/dev/disk/by-uuid/1b99a986-5639-4ae3-acb5-ba977c655592";
    };
  };

  # system
  opt.system.audio.enable = true;
  opt.system.gnome.enable = true;
  opt.system.networkmanager.enable = true;

  opt.system.plymouth = {
    enable = true;
    luks.enable = true;
  };

  # services
  opt.services.printing.enable = true;

  # programs
  opt.programs._1password = {
    enable = true;
    gui.enable = true;
    cli.enable = true;
  };

  # extras
  environment.systemPackages = (
    with _.pkgs.stable;
    [
      gh
      nixd
      nixfmt-rfc-style
    ]
  );

  system.stateVersion = "25.05";
}
