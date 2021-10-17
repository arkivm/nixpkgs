{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, curl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
  version = "unstable-2021-10-16";

  src = fetchFromGitHub {
    owner = "bennofs";
    repo = "nix-index";
    rev = "5a4b3c603b837ded17845c59227dd06312562782";
    sha256 = "0ir9zjm49qx28a3hp0s3k6s90mjcddn8f86jyp7p3px91v4bma6c";
  };

  cargoSha256 = "0r3rd1jxpbiwz44drdcq300m5gjk8grhn9vyrfvw0q784js5qkna";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl curl ]
    ++ lib.optional stdenv.isDarwin Security;

  doCheck = !stdenv.isDarwin;

  postInstall = ''
    mkdir -p $out/etc/profile.d
    cp ./command-not-found.sh $out/etc/profile.d/command-not-found.sh
    substituteInPlace $out/etc/profile.d/command-not-found.sh \
      --replace "@out@" "$out"
  '';

  meta = with lib; {
    description = "A files database for nixpkgs";
    homepage = "https://github.com/bennofs/nix-index";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ bennofs ncfavier ];
  };
}
