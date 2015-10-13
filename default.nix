{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, aeson-pretty, attoparsec, base
      , bytestring, containers, directory, fastcgi, filepath, process
      , split, stdenv, utf8-string
      }:
      mkDerivation {
        pname = "control-groups";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [
          aeson aeson-pretty attoparsec base bytestring containers directory
          fastcgi filepath process split utf8-string
        ];
        homepage = "http://github.com/githubuser/control-groups#readme";
        description = "Simple FastCGI server for working with cgroups";
        license = stdenv.lib.licenses.mit;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
