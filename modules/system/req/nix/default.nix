{ _, ... }:
{
  nix = {
    # use lix [https://lix.systems]
    package = _.pkgs.stable.lix;

    # don't destroy computer
    gc.automatic = false;
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
      sandbox = true;
      trusted-users = [
        "root"
        "@wheel"
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # binary caching
      builders-use-substitutes = true;
      substituters = [ "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = false;
    };
  };
}
