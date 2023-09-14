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
    deps = with pkgs; [
      httplz
      inotify-tools
      pandoc
      parallel
    ];
    src = builtins.readFile ./telekasten-pandoc;
    script = (pkgs.writeScriptBin "telekasten-pandoc" src).overrideAttrs (old: {
      buildCommand = "${old.buildCommand}\n patchShebangs $out";
    });
  in {
    formatter.${system} = pkgs.alejandra;

    packages.${system} = {
      default = self.packages.${system}.telekasten-pandoc;

      telekasten-pandoc = pkgs.symlinkJoin {
        name = "telekasten-pandoc";
        paths = [script] ++ deps;
        buildInputs = [pkgs.makeWrapper];
        postBuild = "wrapProgram $out/bin/telekasten-pandoc --prefix PATH : $out/bin";
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs =
        [
          pkgs.shellcheck
        ]
        ++ deps;
    };
  };
}
