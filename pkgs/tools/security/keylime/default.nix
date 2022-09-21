{ lib
, python3Packages
, fetchFromGitHub
, tpm2-tools
, python3
, pkg-config
, swig
, efivar
, libssl
}:

python3Packages.buildPythonApplication rec {
  pname = "keylime";
  version = "6.4.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "keylime";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-fT9jG4wD9cMVpRmuSoB04rb0RX0+xT24HRUSH7v/qZM=";
  };

  buildInputs = [ efivar libssl ];

  propagatedBuildInputs = [
    tpm2-tools
  ] ++ (with python3.pkgs; [
    cryptography
    tornado
    pyzmq
    pyyaml
    requests
    sqlalchemy
    alembic
    packaging
    psutil
    lark
    pyasn1
    pyasn1-modules
    jinja2
    gpgme
  ]);

  postInstall = ''
    install -D keylime.conf $out/etc/keylime.conf
    # for enabling tests
    substituteInPlace $out/lib/${python3.libPrefix}/site-packages/keylime/config.py --replace "libefivar.so.1" "${efivar.out}/lib/libefivar.so.1"
  '';

  preCheck = ''
    export KEYLIME_CONFIG=$out/etc/keylime.conf
  '';

  checkInputs = [
    tpm2-tools
    efivar
  ];


  # TODO: Enable tests
  # doCheck = false;

  meta = with lib; {
    description = "A CNCF Project to Bootstrap & Maintain Trust on the Edge / Cloud and IoT";
    homepage = "https://keylime.dev";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ arkivm ];
  };

}
