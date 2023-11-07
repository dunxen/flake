{ lib, appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  name = "lume";
  version = "2.0.1";
  src = fetchurl {
    url = "https://github.com/luminous-devs/lume/releases/download/v${version}/lume_${version}_amd64.AppImage";
    hash = "sha256-B+LudNgs8xOjoJldb/kuaj/dYDXbD3FIWDEnv+WvFNM=";
  };

  extraPkgs = pkgs: with pkgs; [ libthai ];

  meta = with lib; {
    description = "A cross-platform desktop nostr client";
    homepage = "https://lume.nu/";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "lume";
  };
}
