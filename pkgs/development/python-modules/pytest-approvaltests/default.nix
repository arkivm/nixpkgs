{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, approvaltests
}:

buildPythonPackage rec {
  pname = "pytest-approvaltests";
  version = "0.2.3";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "approvals";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-M1Io2E4We0ZYxvfUmvR/IjVl9s/Py4fm8lyFHeU8Ccg=";
  };

  buildInputs = [ approvaltests pytest ];

  checkInputs = [ pytest approvaltests ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "Base fixtures for mockito";
    homepage = "https://github.com/kaste/pytest-mockito";
    license = licenses.mit;
  };
}
