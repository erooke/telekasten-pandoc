{
  description = "Turn telekasten markdown into html";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    telekasten-pandoc = pkgs.callPackage ./nix/telekasten-pandoc.nix {};
  in {
    formatter.${system} = pkgs.alejandra;

    packages.${system} = {
      default = telekasten-pandoc;
      telekasten-pandoc = telekasten-pandoc;
    };

    overlays.default = final: prev: {
      telekasten-pandoc = prev.callPackage ./nix/telekasten-pandoc.nix {};
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.shellcheck
      ];
    };
  };
}
