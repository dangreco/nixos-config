{ _, ... }:
{
  environment.systemPackages = (
    with _.pkgs.stable;
    [
      git
      vim
      wget
    ]
  );
}
