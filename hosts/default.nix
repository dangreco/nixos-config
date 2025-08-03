{
  nixos-hardware,
  home-manager,
  ...
}@inputs:
hosts:
let
  mkHost =
    name:
    {
      system,
      model ? null,
      users ? [ ],
    }:
    let
      _.lib = import ../lib inputs;
      _.pkgs = {
        stable = _.lib.mkPkgs system inputs.nixpkgs-stable;
        unstable = _.lib.mkPkgs system inputs.nixpkgs-unstable;
      };
    in
    inputs.nixpkgs-stable.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit _; };
      modules =
        # modules
        [ ../modules ]

        # host-specific
        ++ [
          ./_per/${name}
          {
            networking.hostName = name;
            nixpkgs.hostPlatform = system;
          }
        ]

        # model-specific
        ++ (if model != null then [ nixos-hardware.nixosModules.${model} ] else [ ])

        # system users
        ++ builtins.map (user: ../users/_per/${user}) users

        # home manager
        ++ [
          (
            { config, ... }:
            {
              imports = [ home-manager.nixosModules.home-manager ];
              home-manager.extraSpecialArgs = {
                _ = _ // {
                  inherit config;
                };
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bkp";
              home-manager.users = builtins.listToAttrs (
                builtins.map (user: {
                  name = user;
                  value = {
                    home.username = user;
                    home.homeDirectory = "/home/${user}";
                    home.stateVersion = "25.05";

                    imports = [
                      ../home
                      ../home/_per/${user}
                    ];
                  };
                }) users
              );
            }
          )
        ];
    };
in
builtins.mapAttrs mkHost hosts
