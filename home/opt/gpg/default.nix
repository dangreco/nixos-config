{
  _,
  lib,
  config,
  ...
}:
let
  cfg = config.opt.gpg;
in
{
  options = {
    opt.gpg = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable GnuPG";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = _.pkgs.stable.gnupg;
        description = "GnuPG package to use";
      };
    };
  };

  config =
    let
      pinentry = _.pkgs.stable.pinentry-gnome3;
    in
    lib.mkIf cfg.enable {
      programs.gpg = {
        enable = true;
        package = cfg.package;
      };

      services.gpg-agent = {
        enable = true;
        enableFishIntegration = true;
        enableSshSupport = true;
        extraConfig = ''
          pinentry-program ${pinentry}/bin/pinentry
        '';
      };

      home.packages = [ pinentry ];
    };
}
