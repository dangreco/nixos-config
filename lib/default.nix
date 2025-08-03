{ ... }@inputs:
{
  ifAttr = import ./ifAttr.nix;
  mkKeyBindings = (import ./mkKeyBindings.nix) inputs;
  mkPkgs = import ./mkPkgs.nix;
}
