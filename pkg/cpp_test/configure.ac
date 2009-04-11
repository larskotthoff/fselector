AC_PREREQ(2.50) dnl require version 2.5+ of autoconf

AC_INIT([rcppbind], 1.0) dnl package name, version

AC_LANG(C++)
AC_REQUIRE_CPP

: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
  echo "could not determine R_HOME"
  exit 1
fi
CC=`"${R_HOME}/bin/R" CMD config CC`
CFLAGS=`"${R_HOME}/bin/R" CMD config CFLAGS`
CPPFLAGS=`"${R_HOME}/bin/R" CMD config CPPFLAGS`

dnl copy header files to include
dnl copy demo_xxx.cpp, Makefile to src
dnl copy doc.pdf to inst
mkdir -p inst/include
mkdir -p inst/src
cp include/* inst/include
cp src/demo*.cpp src/Makefile.* inst/src
cp LICENSE.txt inst

AC_OUTPUT
