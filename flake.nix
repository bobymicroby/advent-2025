{
  description = "Advent of code 2025";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zig-overlay.url = "github:mitchellh/zig-overlay";
    zig-overlay.inputs.nixpkgs.follows = "nixpkgs";
    zls-overlay.url = "github:zigtools/zls";
    zls-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      systems = [
        # "x86_64-linux"
        # "aarch64-linux"
        # "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              inputs.zig-overlay.overlays.default
              (final: prev: {
                zlspkgs = inputs.zls-overlay.packages.${system}.default;
              })
            ];
          };
        in
        {

          default = pkgs.mkShell {
            packages = with pkgs; [
              zigpkgs.default
              zls
            ];
          };
        }
      );
    };
}
