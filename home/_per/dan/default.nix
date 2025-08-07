{ _, ... }:
{
  opt.direnv.enable = true;

  opt.firefox = {
    enable = true;
    themes.gnome.enable = true;
  };

  opt.fish.enable = true;
  opt.freecad.enable = true;

  opt.git = {
    enable = true;
    lfs.enable = true;
    user = {
      email = "me@dangre.co";
      name = "Dan Greco";
    };
  };

  opt.gnome = {
    features.fractionalScaling.enable = true;
    features.variableRefreshRate.enable = true;

    shortcuts.custom = [
      {
        name = "Ptyxis";
        command = "ptyxis --new-window";
        binding = "<Super>Return";
      }
      {
        name = "Text";
        command = "gnome-text-editor";
        binding = "<Super>t";
      }
    ];

    ui = {
      wallpaper.default.enable = true;

      avatar = {
        type = "gravatar";
        options = {
          email = "me@dangre.co";
          size = 512;
          frequency = "weekly";
        };
      };
    };
  };

  opt.gpg.enable = true;
  opt.openscad.enable = true;

  opt.prusaslicer = {
    enable = true;
    printers = {
      elrond.enable = true;
    };
  };

  opt.ptyxis.enable = true;
  opt.spotify.enable = true;

  opt.zed = {
    enable = true;
    package = _.pkgs.unstable.zed-editor;
    extensions = [
      # language support
      "nix"
      "make"

      # theming
      "catppuccin"
      "catppuccin-icons"
    ];
    settings =
      let
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      in
      {
        font.ui.size = 16;
        font.buffer.size = 14;
        theme.ui = { inherit light dark; };
        theme.icon = { inherit light dark; };
      };
  };

  home.packages = with _.pkgs.stable; [
    jq
  ];
}
