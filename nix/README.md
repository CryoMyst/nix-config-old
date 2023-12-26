# Nix
This is a bunch of Nix modules for my setup
the config.nix values should not be used directly but instead passed in

## ./features
These are global features

## ./overlays
These are overlays for packages that I use that are not in nixpkgs

## ./personal
These are personal modules that are specific to me
- Network shares
- Ssh
- Email
- Secrets

## ./setups
These are a predefined set of features/personal/overlays which then can be customized

## ./testing
These are testing modules.