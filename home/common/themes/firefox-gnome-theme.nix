{ pkgs, ... }: 
let 
  ff_gnome_theme = pkgs.fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "e53b84d428e7f5ba0f04d6a91e6cc6c05c75b632";
    hash = "sha256-J53bks/1loTdXiSQz1OlOAc8jx9g399oF1YiXAX2JKQ=";
  };
in
{

  home.file."firefox-gnome-theme" = {
    target = ".mozilla/firefox/default/chrome/firefox-gnome-theme";
    source = ff_gnome_theme;
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "Default";
      settings = {
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.drawInTitlebar" = true;
        "svg.context-properties.content.enabled" = true;
        "gnomeTheme.hideSingleTab" = true;
      };
      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
        @import "firefox-gnome-theme/theme/colors/dark.css"; 
      '';
    };
  };
}