{ pkgs, ... }: {

  imports = [
  ];

  home.packages = with pkgs; [
    fd
    jq

    nixd
    alejandra
    nixfmt-rfc-style
    nvd
    nix-diff
    nix-output-monitor
    nh
  ];
}