{
  # Build deps
  symlinkJoin,
  writeScriptBin,
  makeWrapper,
  # Runtime deps
  httplz,
  inotify-tools,
  pandoc,
  parallel,
}: let
  src = builtins.readFile ../telekasten-pandoc;
  script = (writeScriptBin "telekasten-pandoc" src).overrideAttrs (old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
in
  symlinkJoin {
    name = "telekasten-pandoc";
    paths = [script httplz inotify-tools pandoc parallel];
    buildInputs = [makeWrapper];
    postBuild = "wrapProgram $out/bin/telekasten-pandoc --prefix PATH : $out/bin";
  }
