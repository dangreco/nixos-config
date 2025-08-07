{
  nixpkgs-stable,
  nixpkgs-unstable,
  nixos-hardware,
  home-manager,
  ...
}@inputs:
hosts:
let
  lib = nixpkgs-stable.lib;

  mkPkgs = system: {
    stable = (
      import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      }
    );
    unstable = (
      import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      }
    );
  };

  hmFor =
    users: _:
    { config, ... }:
    {
      imports = [ home-manager.nixosModules.home-manager ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bkp";
        extraSpecialArgs = {
          _ = _ // {
            inherit config;
          };
        };
        users = lib.genAttrs users (user: {
          _module.args = { inherit _ user; };

          home.username = user;
          home.homeDirectory = "/home/${user}";
          home.stateVersion = "25.05";
          imports = [
            ../home
            ../home/_per/${user}
          ];
        });
      };
    };

  mkHost =
    name:
    {
      system,
      model ? null,
      users ? [ ],
    }:
    let
      pkgs = mkPkgs system;
      _ = {
        lib = import ../lib inputs;
        inherit pkgs;
      };

      modules = {
        base = [ ../modules ];
        host = [
          ./_per/${name}
          {
            networking.hostName = name;
            nixpkgs.hostPlatform = system;
          }
        ];
        model = lib.optionals (model != null) [ nixos-hardware.nixosModules.${model} ];
        user = map (user: ../users/_per/${user}) users;
        hm = [ (hmFor users _) ];
      };
    in
    inputs.nixpkgs-stable.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit _; };
      modules = builtins.foldl' (ms: ms': ms ++ ms') [ ] (builtins.attrValues modules);
    };
in
builtins.mapAttrs mkHost hosts
