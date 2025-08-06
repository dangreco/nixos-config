{
  _,
  lib,
  config,
  ...
}:
let
  id = "op";
  name = "1Password";
  cfg = config.opt.programs.${id};
in
{
  options = {
    opt.programs.${id} = {
      enable = lib.mkEnableOption name;

      gui = {
        enable = lib.mkEnableOption "${name} GUI";
        package = lib.mkPackageOption _.pkgs.stable "_1password-gui" { };
      };

      cli = {
        enable = lib.mkEnableOption "${name} CLI";
        package = lib.mkPackageOption _.pkgs.stable "_1password-cli" { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs._1password-gui = {
      enable = cfg.gui.enable;
      package = cfg.gui.package;
    };
    programs._1password = {
      enable = cfg.cli.enable;
      package = cfg.cli.package;
    };
  };
}
