nixpkgsSelf: nixpkgsSuper:

let
  inherit (nixpkgsSelf) pkgs;

  ghcVersion = "ghc883";

  hsPkgs = nixpkgsSuper.haskell.packages.${ghcVersion}.override {
    overrides = self: super: {
      # Override ghcide and some of its dependencies since the versions on
      # Nixpkgs is currently broken.
      ghcide = pkgs.haskell.lib.dontCheck (self.callCabal2nix
        "ghcide"
        (builtins.fetchGit {
          url = "https://github.com/digital-asset/ghcide.git";
          rev = "39605333c34039241768a1809024c739df3fb2bd";
        })
        {});
      hie-bios = pkgs.haskell.lib.dontCheck (self.callHackageDirect {
        pkg = "hie-bios";
        ver = "0.4.0";
        sha256 = "19lpg9ymd9656cy17vna8wr1hvzfal94gpm2d3xpnw1d5qr37z7x";
      } {});
      haskell-lsp = pkgs.haskell.lib.dontCheck (self.callHackageDirect {
        pkg = "haskell-lsp";
        ver = "0.21.0.0";
        sha256 = "1j6nvaxppr3wly2cprv556yxr220qw1ghd3ac139iw16ihfjvz8a";
      } {});
      haskell-lsp-types = pkgs.haskell.lib.dontCheck (self.callHackageDirect {
        pkg = "haskell-lsp-types";
        ver = "0.21.0.0";
        sha256 = "0vq7v6k9szmwxh2haphgzb3c2xih6h5yyq57707ncg0ha75bhlll";
      } {});
      shake = pkgs.haskell.lib.dontCheck (self.callHackage "shake" "0.18.5" {});
    };
  };

in
{
  haskell = nixpkgsSuper.haskell // {
    inherit ghcVersion;

    packages = nixpkgsSuper.haskell.packages // {
      "${ghcVersion}" = hsPkgs;
    };
  };
}
