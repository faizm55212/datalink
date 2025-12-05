{
  description = "Datalink dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      system = "x86_64-linux";
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs { inherit system overlays; };

      rust = pkgs.rust-bin.stable.latest.default.override {
        targets = [ "x86_64-pc-windows-gnu" ];
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          rust
          pkgs.rustc
          pkgs.cargo
          pkgs.pkg-config
          pkgs.dbus
          pkgs.openssl
          pkgs.zlib
          pkgs.libgit2
          pkgs.pkgsCross.mingwW64.stdenv.cc
          pkgs.pkgsCross.mingwW64.windows.pthreads
        ];

        PKG_CONFIG_PATH = "${pkgs.libgit2.dev}/lib/pkgconfig:${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.zlib.dev}/lib/pkgconfig";
      };
    };
}
