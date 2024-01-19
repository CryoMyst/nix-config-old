self: super:
let
  lib = super.lib;
in
{
  inherit (self.nixpkgs-master);
  # broken in nixpkgs-unstable
  azure-cli = super.nixpkgs-master.azure-cli;
}