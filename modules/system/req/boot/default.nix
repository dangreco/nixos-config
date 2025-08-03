{ ... }:
{
  boot = {
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };
}
