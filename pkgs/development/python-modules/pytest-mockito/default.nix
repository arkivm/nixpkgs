{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, mockito
}:

buildPythonPackage rec {
  pname = "pytest-mockito";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "kaste";
    repo = pname;
    rev = version;
    sha256 = "sha256-vY/i1YV1lo4mZvnxsXBOyaq31YTiF0BY6PTVwdVX10I=";
  };

  buildInputs = [ pytest mockito ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "Base fixtures for mockito";
    homepage = "https://github.com/kaste/pytest-mockito";
    license = licenses.mit;
  };
}
