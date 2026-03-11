{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
}:
let
  pname = "sliver";
  version = "1.5.44";

  system = stdenv.hostPlatform.system;

  sources = {
    x86_64-darwin = {
      server = {
        url = "https://github.com/BishopFox/sliver/releases/download/v${version}/sliver-server_macos";
        sha256 = "1rmp96z0h9xnx1mam9i3nx90384kjb5bxhrjb9y6cq3v15sls3wf";
      };
      client = {
        url = "https://github.com/BishopFox/sliver/releases/download/v${version}/sliver-client_macos";
        sha256 = "19l7yy55zsvg55rqsxmi1pahvj4f48g9n1nkvhkffv0l6m8a3anv";
      };
    };
    aarch64-darwin = {
      server = {
        url = "https://github.com/BishopFox/sliver/releases/download/v${version}/sliver-server_macos-arm64";
        sha256 = "089142vyhyn0cbvpc1d5qqy6g4cgd66gi61xhpncfjq0dilykr1n";
      };
      client = {
        url = "https://github.com/BishopFox/sliver/releases/download/v${version}/sliver-client_macos-arm64";
        sha256 = "1cs7iq83bhb315jljzki8r7n03wpw6ajg1mzz4x3svl31m09zg8v";
      };
    };
  };

  source = sources.${system} or (throw "Unsupported system for sliver: ${system}");

  serverBin = fetchurl { url = source.server.url; sha256 = source.server.sha256; };
  clientBin = fetchurl { url = source.client.url; sha256 = source.client.sha256; };
in
stdenv.mkDerivation {
  inherit pname version;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 ${serverBin} $out/bin/sliver-server
    install -m755 ${clientBin} $out/bin/sliver-client
    # Add sliver alias to client
    ln -s $out/bin/sliver-client $out/bin/sliver
    runHook postInstall
  '';

  meta = {
    description = "Sliver is a general purpose cross-platform red team framework";
    homepage = "https://sliver.sh/";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
