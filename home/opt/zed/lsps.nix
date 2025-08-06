{ _, ... }:
let
  mkLsp =
    {
      pkg,
      bin,
      args,
    }:
    {
      binary = {
        path = "${pkg}/bin/${bin}";
        arguments = args;
      };
    };

  lsps = {
    json-language-server = {
      pkg = _.pkgs.unstable.vscode-json-languageserver;
      bin = "vscode-json-languageserver";
      args = [ "--stdio" ];
    };
    package-version-server = {
      pkg = _.pkgs.unstable.package-version-server;
      bin = "package-version-server";
      args = [ ];
    };
    yaml-language-server = {
      pkg = _.pkgs.unstable.yaml-language-server;
      bin = "yaml-language-server";
      args = [ "--stdio" ];
    };
  };
in
{
  packages = builtins.map (lsp: lsp.pkg) (builtins.attrValues lsps);
  config = builtins.mapAttrs (_: lsp: mkLsp lsp) lsps;
}
