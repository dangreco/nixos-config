{ lib, config, ... }@inputs:
let
  cfg = config.opt.gnome.ui.avatar;
  _types = builtins.map (t: import t inputs) [ ./gravatar.nix ];
in
{
  options = with lib; {
    opt.gnome.ui.avatar = {
      type = mkOption {
        type = types.nullOr (types.enum (builtins.map (t: t.name) _types));
        default = null;
      };
      options = mkOption {
        type = types.nullOr (types.oneOf (builtins.map (t: t.type) _types));
        default = null;
      };
    };
  };

  config = builtins.foldl' (c: c': c // c') { } (
    builtins.map (t: lib.mkIf (cfg.type == t.name) t.config) _types
  );

  # config = {
  # }
  # // lib.mkIf (cfg.type == "gravatar") (
  #   let
  #     email = cfg.options.email;
  #     hash = builtins.hashString "sha256" (lib.strings.toLower (lib.strings.trim email));
  #   in
  #   {
  #     home.file.".gravatar".text = hash;
  #   }
  # );
}
