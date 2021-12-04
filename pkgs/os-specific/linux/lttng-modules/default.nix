{ lib, stdenv, fetchpatch, fetchurl, kernel }:

stdenv.mkDerivation rec {
  pname = "lttng-modules-${kernel.version}";
  version = "2.13.0";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-modules/lttng-modules-${version}.tar.bz2";
    sha256 = "0mikc3fdjd0w6rrcyksjzmv0czvgba6yk8dfmz4a3cr8s4y2pgsy";
  };

  patches = [
  ] ++
  lib.optional (lib.versionAtLeast kernel.version "5.15")
  # Should be removed once a new version is released
    (fetchpatch {
      url = "https://github.com/lttng/lttng-modules/commit/ffcc873470121ef1ebb110df3d9038a38d9cb7cb.patch";
      sha256 = "sha256-FSNVRujq/f+bl2CHlXoPpBnq65i2K+XG2+O1AnplJ2o=";
    });

  buildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  preConfigure = ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    export INSTALL_MOD_PATH="$out"
  '';

  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Linux kernel modules for LTTng tracing";
    homepage = "https://lttng.org/";
    license = with licenses; [ lgpl21Only gpl2Only mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
