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
}:
rustPlatform.buildRustPackage rec {
  pname = "liana";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "wizardsardine";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+6egIxh1CNRLPLcTp61c4TJ22hcF0qRdwxhV8vZGvTM=";
  };

  cargoLock = {
    lockFile = "${src}/gui/Cargo.lock";
    outputHashes = {
      "liana-1.0.0" = "sha256-zROSTohjAvfhluLzX+0rZAaGTjM7NsR3Ww3HSqyQgS8=";
      "miniscript-9.0.0" = "sha256-5ITjVqh5frqjTTs993xqo5WwDZ5dDAfFn4DGqt2QbiY=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    fontconfig
    systemd
  ];

  sourceRoot = "source/gui";

  postInstall = ''
    install -Dm0644 $src/gui/ui/static/logos/liana-app-icon.svg $out/share/icons/hicolor/scalable/apps/liana.svg
  '';

  desktopItems = [ (makeDesktopItem {
    name = "Liana";
    exec = "liana-gui";
    icon = "liana";
    desktopName = "Liana";
    comment = meta.description;
  }) ];

  doCheck = true;

  meta = with lib; {
    description = "A Bitcoin wallet leveraging on-chain timelocks for safety and recovery";
    homepage = "https://wizardsardine.com/liana";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dunxen ];
    platforms = platforms.linux;
  };
}

