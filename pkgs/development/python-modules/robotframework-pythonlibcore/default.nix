{ lib
, buildPythonPackage
, fetchFromGitHub
, mockito
, pytest
, pytest-cov
, pytest-mockito
, robotframework
}:

buildPythonPackage rec {
  pname = "robotframework-pythonlibcore";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "PythonLibCore";
    rev = "v${version}";
    sha256 = "sha256-hGUC0Ijt+0BSsYTXbG8S13Su+sNkLAegjYYWozbaCW0=";
  };

  checkInputs = [
    mockito
    pytest
    pytest-cov
    pytest-mockito
    robotframework
  ];

  checkPhase = ''
    python3 utest/run.py
  '';

  meta = with lib; {
    description = "Tools to ease creating larger test libraries for Robot Framework using Python";
    homepage = "https://robotframework.org/";
    license = licenses.asl20;
  };
}
