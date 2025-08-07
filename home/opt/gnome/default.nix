{
  _,
  lib,
  ...
}:
let
  enable = _.config.opt.system.gnome.enable;
in
{
  imports = lib.optionals enable [
    ./features
    ./shortcuts
    ./ui
  ];

  options = { };

  config = lib.mkIf enable {
    # sensible defaults
    dconf.settings = {
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ":minimize,maximize,close";
      };
      "org/gnome/desktop/interface" = {
        show-battery-percentage = true;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        power-saver-profile-on-low-battery = true;
      };
      "org/gnome/desktop/session" = {
        idle-delay = lib.gvariant.mkUint32 0;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = false;
      };
    };
  };
}
