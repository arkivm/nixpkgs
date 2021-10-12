{
  fetchurl,
  lib,
  stdenv,
  undmg,
}:

let
  pname = "notion-kb";
  version = "2.0.17";

  srcs = {
    x86_64-darwin = fetchurl {
      url = "https://desktop-release.notion-static.com/${version}.dmg";
      sha256 = "arca8Gbr4ytiCk43cifmNj7SUrDgn1XB26zAhZrVDs0=";
    };

    aarch64-darwin = fetchurl {
      url = "https://desktop-release.notion-static.com/Notion-${version}-arm64.dmg";
      sha256 = "sha256-dBH1tcLeiGXPR7ESsmvQTMcBgt3Rmy+Z/28z/8VXftk";
    };
  };

  src = srcs.${stdenv.hostPlatform.system};

  meta = with lib; {
    description = "Notion is a knowledge base that has notes, kanban boards, wikis, calendars and reminders";
    homepage = "https://www.notion.so";
    license = licenses.unfree;
    maintainers = with maintainers; [ arkivm ];
    platforms = builtins.attrNames srcs;
  };

in stdenv.mkDerivation {
  inherit pname version src meta;

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications/Notion.app
    cp -R . $out/Applications/Notion.app
  '';
}
