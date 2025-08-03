{
  lib,
  config,
  ...
}:
let
  cfg = config.opt.firefox.themes.gnome;
in
{
  options = {
    opt.firefox.themes.gnome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable firefox-gnome-theme";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.fgt = {
      Unit = {
        Description = "Run fgt (firefox-gnome-theme) script";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "%h/.config/fgt/fgt.sh";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    systemd.user.timers.fgt = {
      Unit = {
        Description = "Daily run of fgt script";
      };
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    home.file = {
      ".config/fgt/fgt.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          set -euo pipefail

          TMP=$(mktemp -d)
          C_WHITE='\033[1;37m'
          C_BLACK='\033[0;30m'
          C_RESET='\033[0m'
          C_GREEN='\033[1;32m'
          C_RED='\033[1;31m'

          panic()
          {
              echo -e "''${C_RED}[ERROR]''${C_RESET} $1"
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

          if ! command -v jq >/dev/null 2>&1
          then
              panic "jq is not installed, exiting"
          fi

          if ! command -v gh >/dev/null 2>&1
          then
              panic "gh is not installed, exiting"
          fi

          if ! gh auth status > /dev/null 2>&1;
          then
            panic "gh auth inactive, please log in using 'gh auth login'"
          fi

          # ========

          FGT_ORG="rafaelmardojai"
          FGT_REPO="firefox-gnome-theme"
          FGT_RELEASE="latest"

          CONFIG="$HOME/.config/fgt"

          setup()
          {
              local version="$1"

              # initialize config dir
              echo -e "- Creating config directory..."
              mkdir -p "$CONFIG"
              mkdir -p "$CONFIG/source"
              mkdir -p "$CONFIG/source/$version"

              # write version
              echo -e "- Writing version..."
              echo "$version" > "$CONFIG/version"

              # get tarball
              echo -e "- Fetching tarball..."
              local tarball="$CONFIG/source/$version/release.tar.gz"
              curl -LJo "$tarball" "https://github.com/$FGT_ORG/$FGT_REPO/tarball/$version" > /dev/null 2>&1\

              # extract tarball
              echo -e "- Extracting tarball..."
              tar -xzf $tarball --strip-components=1 -C "$TMP"

              # install
              echo -e "- Installing..."
              (
                  cd "$TMP"
                  chmod +x scripts/auto-install.sh
                  ./scripts/auto-install.sh > /dev/null 2>&1\
              )

              echo -e "============== [''${C_GREEN}OK''${C_RESET}] ==============="
          }

          get_version_remote()
          {

              local readonly MAX_ATTEMPTS=10
              local readonly RETRY_DELAY=3
              local endpoint="/repos/$FGT_ORG/$FGT_REPO/releases/$FGT_RELEASE"

              local version=""
              for ((i=1; i<=MAX_ATTEMPTS; i++)); do
                  version=$(gh api --method GET "$endpoint" | jq -r '.tag_name')
                  if [[ -n "$version" ]];
                  then
                      break
                  fi
                  sleep "$RETRY_DELAY"
              done

              if [[ -z "$version" ]];
              then
                panic "Could not get latest release; timed out after ''${MAX_ATTEMPTS} attempts"
              fi

              printf "%s" "$version"
          }

          get_version_local()
          {
              local file="$CONFIG/version"
              local content=""

              if [[ -r $file ]]; then
                  content=$(<"$file")
              fi

              printf '%s' "$content"
          }

          echo -e "======== ''${C_WHITE}Fetching versions''${C_RESET} ========"

          VERSION_REMOTE=$(get_version_remote)
          echo -e "- ''${C_WHITE}Remote:''${C_RESET} $VERSION_REMOTE"

          VERSION_LOCAL=$(get_version_local)
          echo -e "- ''${C_WHITE}Local:''${C_RESET} $VERSION_LOCAL"

          echo -e "============== [''${C_GREEN}OK''${C_RESET}] ===============\n"

          if [[ "$VERSION_LOCAL" != "$VERSION_REMOTE" ]];
          then
              echo -e "========= ''${C_WHITE}Installing $VERSION_REMOTE''${C_RESET} ========="
              setup "$VERSION_REMOTE"
          else
              echo "Version up to date!"
          fi
        '';
      };
    };
  };

}
