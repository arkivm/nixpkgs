{ lib
, buildPythonPackage
, fetchPypi
, psutil
, stdenv
}:

buildPythonPackage rec {
  pname = "guider";
  version = "3.9.88";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-C3U9RIT7nN6rRsEv24u7Nwha5g7KWfFU1a/SNwS4qLA=";
  };

  propagatedBuildInputs = lib.optional stdenv.isDarwin [ psutil ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/iipeace/guider";
    description = "Unified Performance Analyzer";
    license = licenses.gpl2;
    maintainers = with maintainers; [ arkivm ];
  };
}

