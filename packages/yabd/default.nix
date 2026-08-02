{
  lib,
  buildPythonPackage,
  dbus-python,
  fetchFromGitHub,
  hatchling,
  iio-sensor-proxy,
  pygobject3,
  sdbus,
}:
buildPythonPackage {
  build-system = [
    hatchling
  ];

  buildInputs = [
    iio-sensor-proxy
  ];

  pname = "yabd";

  propagatedBuildInputs = [
    pygobject3
    dbus-python
    sdbus
  ];

  pyproject = true;

  pythonRelaxDeps = [
    "sdbus"
  ];

  src = fetchFromGitHub {
    hash = "sha256-XlvfcxT2LLik1JTodfuq5yv5CCDrNFt5TokXZZUmxVc=";
    owner = "tbrugere";
    repo = "yabd";
    rev = "4cacc9a9083f07a67a5fcb8eebaf919984dd7e6f";
  };

  version = "latest";

  meta = with lib; {
    description = "Yet another brightness daemon";
    homepage = "https://github.com/tbrugere/yabd";
    license = licenses.cecill-b;
    mainProgram = "yabd";
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
