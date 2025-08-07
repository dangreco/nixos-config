{ lib, config, ... }:
let
  cfg = config.opt.gnome.ui.avatar;
in
{
  name = "gravatar";

  type =
    with lib;
    types.submodule {
      options = {
        email = mkOption { type = types.str; };
        size = mkOption {
          type = types.int;
          default = 256;
        };
        frequency = mkOption {
          type = types.enum [
            "daily"
            "weekly"
            "monthly"
            "yearly"
          ];
          default = "daily";
        };
      };
    };

  config =
    let
      email = cfg.options.email;
      hash = builtins.hashString "sha256" (lib.strings.toLower (lib.strings.trim email));
    in
    {
      systemd.user.services.avatar-gravatar = {
        Unit = {
          Description = "Run avatar::gravatar script";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "%h/.config/avatar/gravatar.sh";
          StandardOutput = "journal";
          StandardError = "journal";
        };
      };

      systemd.user.timers.avatar-gravatar = {
        Unit = {
          Description = "${cfg.options.frequency} run of avatar::gravatar script";
        };
        Timer = {
          OnCalendar = cfg.options.frequency;
          Persistent = true;
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };

      home.file = {
        ".config/avatar/gravatar.sh" = {
          executable = true;
          text = ''
            #!/usr/bin/env bash
            set -euo pipefail

            TMP=$(mktemp -d)

            panic()
            {
                echo "$1"
                exit 1
            }

            cleanup()
            {
                rm -rf "$TMP"
            }

            trap cleanup EXIT INT TERM

            if ! command -v curl >/dev/null 2>&1
            then
                panic "curl is not installed, exiting"
            fi

            # ========

            EMAIL=${email}
            HASH=${hash}
            SIZE=${toString cfg.options.size}

            echo "Fetching gravatar for $EMAIL (sha256: $HASH)"

            URL="https://gravatar.com/avatar/$HASH?s=$SIZE"
            FACE="$TMP/.face"

            if curl -fLsS --retry 3 -o "$FACE" "$URL"; then
              if ! cmp -s "$FACE" "$HOME/.face"; then
                if [[ -e "$HOME/.face" ]]; then
                  mv "$HOME/.face" "$HOME/.face.abkp"
                fi
                mv "$FACE" "$HOME/.face"
                echo "Updated!"
              else
                echo "Nothing to update!"
              fi
            fi
          '';
        };
      };
    };
}
