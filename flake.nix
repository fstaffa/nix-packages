{
  description = "stskeygen for cimpress aws";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    terraform_0_13-nixpkgs.url = "github:NixOS/nixpkgs/c92ca95afb5043bc6faa0d526460584eccff2277";
    terraform_0_14-nixpkgs.url = "github:NixOS/nixpkgs/bf972dc380f36a3bf83db052380e55f0eaa7dcb6";
  };

  outputs = { self, nixpkgs, flake-utils, terraform_0_13-nixpkgs, terraform_0_14-nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system: {
      formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      packages.stskeygen = let
        mappings = {
          x86_64-linux = {
            url = "Linux_x86_64";
            sha256 = "1qbgpwd86nvhqn4pjyxf7k3k16v0ynjzyfs1k7116fydh63n576h";
          };
          i686-linux = {
            url = "Linux_i386";
            sha256 = "0hv8sr3awlj17k19q7xn8bql43yy7y8x3c91pp6za1f8h30b1xch";
          };
          aarch64-linux = {
            url = "Linux_arm64";
            sha256 = "0sbda1nvgp0nlsynhdbgj7jla91n9jrsggpj37mbjdzdz0rwy5wv";
          };
          x86_64-darwin = {
            url = "Darwin_x86_64";
            sha256 = "13d8qq0lz4yiyy5njz85kmz44l2k4qpy49vzzd9qdyv31172vg96";
          };
          aarch64-darwin = {
            url = "Darwin_arm64";
            sha256 = "0nm13cxngsjr7b8sbzs9k9czgcv21xgkbdhqqvkzzvv8q5gi3n56";
          };
        };
        urlSystem = mappings.${system}.url;

      in with import nixpkgs { system = system; };
      stdenv.mkDerivation rec {
        name = "stskeygen-${version}";

        version = "2.2.13";

        # https://nixos.wiki/wiki/Packaging/Binaries
        src = pkgs.fetchurl {
          url =
            "https://ce-installation-binaries.s3.us-east-1.amazonaws.com/stskeygen/${version}/stskeygen_${version}_${urlSystem}.tar.gz";
          sha256 = mappings.${system}.sha256;
        };

        sourceRoot = ".";

        installPhase = ''
          install -m755 -D stskeygen $out/bin/stskeygen
        '';

        meta = {
          homepage = "";
          description = "stskeygen for cimpress aws";
        };
      };
      packages.terraform_0_13 = terraform_0_13-nixpkgs.legacyPackages.${system}.terraform_0_13;
      packages.terraform_0_14 = terraform_0_14-nixpkgs.legacyPackages.${system}.terraform_0_14;
    });
}
