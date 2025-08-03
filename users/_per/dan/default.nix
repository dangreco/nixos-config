{ _, config, ... }:
{
  users.users.dan = {
    isNormalUser = true;
    description = "Dan Greco";
    extraGroups = _.lib.ifAttr [
      "audio"
      "docker"
      "git"
      "i2c"
      "libvirtd"
      "networkmanager"
      "plugdev"
      "podman"
      "video"
      "wheel"
      "wireshark"
    ] config.users.groups;

    shell = _.pkgs.stable.fish;
  };
}
