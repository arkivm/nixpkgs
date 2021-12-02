{ lib, buildPythonPackage, fetchFromGitHub, pytest, pyperclip, beautifulsoup4, empty-files, numpy }:

buildPythonPackage rec {
  version = "3.2.0";
  pname = "approvaltests";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "approvals";
    repo = "ApprovalTests.Python";
    rev = "v${version}";
    sha256 = "sha256-uOAUWuo5XCC9smRLDNgYC4RZnDyUjDX6pbfvHxz7M6s=";
  };

  buildInputs = [ beautifulsoup4 empty-files ];

  checkInputs = [ pytest numpy ];

  propagatedBuildInputs = [ pyperclip beautifulsoup4 empty-files ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyperclip==1.5.27" "pyperclip>=1.5.27" \
      --replace '"bs4"' '"beautifulsoup4"'
  '';

  meta = with lib; {
    description = "Assertion/verification library to aid testing";
    homepage = "https://github.com/approvals/ApprovalTests.Python";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
