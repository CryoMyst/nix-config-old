self: super:
let
  lib = super.lib;
in
{
  inherit (self.nixpkgs-stable);
  # broken in nixpkgs-unstable
  azure-cli = super.nixpkgs-stable.azure-cli;
}