{
  _,
  lib,
  config,
  ...
}:
let
  id = "gpg";
  pkg = "gnupg";
  name = "GnuPG";
  cfg = config.opt.${id};
in
{
  options = {
    opt.${id} = {
      enable = lib.mkEnableOption name;
      package = lib.mkPackageOption _.pkgs.stable pkg { };
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
