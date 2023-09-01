{ lib
, rustPlatform
, fetchFromGitHub
, llvmPackages
, fetchurl
, pkg-config
, fontconfig
, copyDesktopItems
, makeDesktopItem
, systemd
, cmake
, pkgs
, makeWrapper
}:
rustPlatform.buildRustPackage rec {
  pname = "liana";
  version = "2.0rc1";

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MKNtUlgqatJ7votqoyX3YSowixSRhaIlXnAPfNaym3s=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "liana-2.0.0" = "sha256-vIqnjBrszNHy0CmvJF8PKk91DHE5IdNUsKRycGO1Hes=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = with pkgs; [
    expat
    fontconfig
    freetype
    freetype.dev
    libGL
    pkgconfig
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    systemd
  ];

  sourceRoot = "source/gui";

  postInstall = ''
    install -Dm0644 $src/gui/ui/static/logos/liana-app-icon.svg $out/share/icons/hicolor/scalable/apps/liana.svg
    wrapProgram $out/bin/liana-gui --prefix LD_LIBRARY_PATH : "${builtins.foldl' (a: b: "${a}:${b}/lib") "${pkgs.vulkan-loader}/lib" buildInputs}"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Liana";
      exec = "liana-gui";
      icon = "liana";
      desktopName = "Liana";
      comment = meta.description;
    })
  ];

  doCheck = true;

  meta = with lib; {
    description = "A Bitcoin wallet leveraging on-chain timelocks for safety and recovery";
    homepage = "https://wizardsardine.com/liana";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dunxen ];
    platforms = platforms.linux;
  };
}

