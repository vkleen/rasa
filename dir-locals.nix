{ pkgs ? import (import ./nix/fetch-nixpkgs.nix) {}, ... }:

let env = import ./shell.nix;
in pkgs.nixBufferBuilders.withPackages (   env.buildInputs
                                        ++ env.nativeBuildInputs
                                        ++ env.propagatedBuildInputs)
