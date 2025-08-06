{ lib, config, ... }:
let
  id = "nm";
  name = "NetworkManager";
  cfg = config.opt.system.${id};
in
{
  options = {
    opt.system.${id} = {
      enable = lib.mkEnableOption name;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
