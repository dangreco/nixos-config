{
  _,
  lib,
  config,
  ...
}:
let
  id = "direnv";
  pkg = "direnv";
  name = "direnv";
  cfg = config.opt.${id};
in
{
  options = {
    opt.${id} = {
      enable = lib.mkEnableOption name;
      package = lib.mkPackageOption _.pkgs.stable pkg { };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      package = cfg.package;
      nix-direnv = {
        enable = true;
        package = _.pkgs.stable.nix-direnv;
      };
    };
  };
}
