{ lib, appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  name = "lume";
  version = "3.0.2";
  src = fetchurl {
    url = "https://github.com/luminous-devs/lume/releases/download/v${version}/lume_${version}_amd64.AppImage";
    hash = "sha256-UsN169qqPMG1YzhE2ZbrQmDvLIA/6g1hKI/r1y380Mk=";
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
