{ lib, buildPythonPackage, fetchFromGitHub, pytest, requests }:

buildPythonPackage rec {
  version = "0.0.3";
  pname = "empty-files";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "approvals";
    repo = "EmptyFiles.Python";
    rev = "v${version}";
    sha256 = "sha256-K4rlVO1X1AWxYI3EqLsyQ5/Ist/jlwFrmOM4aMojtKU=";
  };

  buildInputs = [ pytest requests ];

  propagatedBuildInputs = [ requests ];

  doCheck = false;

  meta = with lib; {
    description = "Assertion/verification library to aid testing";
    homepage = "https://github.com/approvals/ApprovalTests.Python";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
