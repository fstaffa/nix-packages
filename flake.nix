{
  description = "stskeygen for cimpress aws";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    terraform_0_13-nixpkgs.url = "github:NixOS/nixpkgs/c92ca95afb5043bc6faa0d526460584eccff2277";
    terraform_0_14-nixpkgs.url = "github:NixOS/nixpkgs/bf972dc380f36a3bf83db052380e55f0eaa7dcb6";
  };

  outputs = { nixpkgs, flake-utils, terraform_0_13-nixpkgs, terraform_0_14-nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system: {
      formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      packages.stskeygen =
        let
          mappings = {
            x86_64-linux = {
              systemAlias = "linux_amd64";
            };
            i686-linux = {
              systemAlias = "linux_386";
            };
            aarch64-linux = {
              systemAlias = "linux_arm64";
            };
            x86_64-darwin = {
              systemAlias = "darwin_amd64";
            };
            aarch64-darwin = {
              systemAlias = "darwin_arm64";
            };
          };
          urls = builtins.fromJSON (nixpkgs.lib.readFile ./stskeygen.json);
          data = urls.${mappings.${system}.systemAlias};
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.stdenv.mkDerivation {
          name = "stskeygen-${data.version}";

          version = data.version;

          # https://nixos.wiki/wiki/Packaging/Binaries
          src = pkgs.pkgs.fetchurl {
            url = data.url;
            sha256 = data.sha256;
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
