{ pkgs, ... }: {

  imports = [
  ];

  home.packages = with pkgs; [
    fd
    jq
    direnv
    devenv

    nixd
    alejandra
    nixfmt-rfc-style
    nvd
    nix-diff
    nix-output-monitor
    nh
  ];
}
