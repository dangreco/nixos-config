{ ... }@inputs:
{
  ifAttr = import ./ifAttr.nix;
  mkKeyBindings = (import ./mkKeyBindings.nix) inputs;
}
