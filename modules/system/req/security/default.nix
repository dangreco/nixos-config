{ _, ... }:
{
  security = {
    protectKernelImage = false;
    lockKernelModules = false;
    forcePageTableIsolation = true;
    polkit.enable = true;
    rtkit.enable = true;
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [ _.pkgs.stable.apparmor-profiles ];
    };
  };

  # # credits: poz
  # fileSystems =
  #   let
  #     defaults = [
  #       "nodev"
  #       "nosuid"
  #       "noexec"
  #     ];
  #   in
  #   {
  #     "/boot".options = defaults;
  #     "/var/log".options = defaults;
  #   };

  boot = {
    blacklistedKernelModules = [
      # obscure network protocols
      "ax25"
      "netrom"
      "rose"
      # old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cifs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "f2fs"
      "freevxfs"
      "gfs2"
      "hfs"
      "hfsplus"
      "hpfs"
      "jfs"
      "jffs2"
      "minix"
      "nfsv3"
      "nfsv4"
      "nilfs2"
      "omfs"
      "qnx4"
      "qnx6"
      "squashfs"
      "sysv"
      "vivid"
    ];
  };
}
