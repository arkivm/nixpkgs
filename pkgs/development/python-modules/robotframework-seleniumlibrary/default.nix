{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, robotframework
, selenium
, mockito
, robotstatuschecker
, approvaltests
, robotframework-pythonlibcore
, pytest
, pytest-approvaltests
}:

buildPythonPackage rec {
  version = "5.1.3";
  pname = "robotframework-seleniumlibrary";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "SeleniumLibrary";
    rev = "v${version}";
    sha256 = "1djlrbrgd7v15xk5w90xk7iy98cr1p2g57k614gvbd298dmnf2wd";
  };

  propagatedBuildInputs = [ robotframework selenium robotframework-pythonlibcore ];
  checkInputs = [ pytest mockito robotstatuschecker approvaltests  pytest-approvaltests ];

  # Only execute Unit Tests. Acceptance Tests require headlesschrome, currently
  # not available in nixpkgs
  checkPhase = ''
    ${python.interpreter} utest/run.py
  '';

  meta = with lib; {
    description = "Web testing library for Robot Framework";
    homepage = "https://github.com/robotframework/SeleniumLibrary";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
