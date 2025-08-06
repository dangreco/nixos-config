{ lib, config, ... }:
let
  id = "docker";
  name = "Docker";
  cfg = config.opt.services.${id};
in
{
  options = {
    opt.services.${id} = {
      enable = lib.mkEnableOption name;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
    };
  };
}
