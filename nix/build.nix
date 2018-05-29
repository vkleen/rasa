{ pkgs ? import (import ./fetch-nixpkgs.nix) {}, compiler ? "ghc842" }:

with pkgs.lib; with pkgs.haskell.lib;
let
  pkgsMake = import ./pkgs-make {
    origNixpkgs = pkgs;
    haskellArgs = {
      ghcVersion = compiler;
    };
  };


  build-env = hs: pkg:
    (overrideCabal hs."${pkg}" (drv: {
      buildTools = (optionals (drv ? "buildTools") drv.buildTools) ++
                     [ hs.cabal-install hs.hpack hs.stylish-haskell hs.hlint hs.ghcid ];
    })).env;
in pkgsMake ({call, lib} :
  let
    modifiedHaskellCall = f:
      lib.nix.composed [
        lib.haskell.enableLibraryProfiling
        lib.haskell.doHaddock
        f
      ];
    haskellLib = modifiedHaskellCall call.haskell.lib;
    haskellApp = modifiedHaskellCall call.haskell.app;
  in rec {
    rasa                = haskellApp ../rasa;
    rasa-example-config = haskellApp ../rasa-example-config;

    rasa-ext-cmd        = haskellLib ../rasa-ext-cmd;
    rasa-ext-cursors    = haskellLib ../rasa-ext-cursors;
    rasa-ext-files      = haskellLib ../rasa-ext-files;
    rasa-ext-logger     = haskellLib ../rasa-ext-logger;
    rasa-ext-slate      = haskellLib ../rasa-ext-slate;
    rasa-ext-views      = haskellLib ../rasa-ext-views;
    rasa-ext-vim        = haskellLib ../rasa-ext-vim;

    eve       = haskellLib ../eve;
    text-lens = haskellLib ../text-lens;
    yi-rope   = haskellLib ../yi-rope;
  })
