{ nixpkgs-stable, ... }:
bindings:
let
  lib = nixpkgs-stable.lib;
  enumerated = builtins.genList (i: {
    index = i;
    value = builtins.elemAt bindings i;
  }) (builtins.length bindings);
in
builtins.listToAttrs (
  builtins.map (b: {
    name = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString b.index}";
    value = b.value;
  }) enumerated
)
// (
  if builtins.length bindings == 0 then
    { }
  else
    {
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = lib.gvariant.mkArray (
          builtins.map (
            b: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString b.index}/"
          ) enumerated
        );
      };
    }
)
