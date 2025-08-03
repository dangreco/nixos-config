{ lib, config, ... }:
let
  cfg = config.opt.system.networkmanager;
in
{
  options = {
    opt.system.networkmanager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
