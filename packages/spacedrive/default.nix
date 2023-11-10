{ lib, appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  name = "spacedrive";
  version = "0.1.2";
  src = fetchurl {
    url = "https://github.com/spacedriveapp/spacedrive/releases/download/${version}/Spacedrive-linux-x86_64.AppImage";
    hash = "sha256-OHoOEfMBOD1FAGcJPGqV+APzhbVhVC2kvKYsApRs1VQ=";
  };

  extraPkgs = pkgs: with pkgs; [ libthai ];

  meta = with lib; {
    description = "An open source file manager, powered by a virtual distributed filesystem (VDFS) written in Rust";
    homepage = "https://www.spacedrive.com/";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "spacedrive";
  };
}