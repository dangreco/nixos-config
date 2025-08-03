{ lib, config, ... }:
let
  cfg = config.opt.services.printing;
in
{
  options = {
    opt.services.printing = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
  };
}
