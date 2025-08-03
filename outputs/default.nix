{ ... }@inputs:
let
  hosts = {
    sake = {
      system = "x86_64-linux";
      model = "lenovo-thinkpad-x1-10th-gen";
      users = [ "dan" ];
    };
  };
in
{
  nixosConfigurations = import ../hosts inputs hosts;
}
