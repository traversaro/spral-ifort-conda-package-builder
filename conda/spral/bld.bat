set PKG_CONFIG_PATH=%PKG_CONFIG_PATH%;%BUILD_PREFIX%\lib\pkgconfig
set PKG_CONFIG=%BUILD_PREFIX%\Library\bin\pkg-config

meson setup builddir --buildtype=release -Dlibdir=lib --prefix=$PREFIX  -Dexamples=false -Dtests=true -Dmodules=false -Dgpu=false
if errorlevel 1 exit 1

# Required for tests to pass, see https://github.com/ralna/spral#usage-at-a-glance
# and https://github.com/ralna/spral/issues/7#issuecomment-288700497
set OMP_CANCELLATION=TRUE
set OMP_PROC_BIND=TRUE
meson test -C builddir
if errorlevel 1 exit 1

# Disable tests before install to avoid tests being installed
meson setup --reconfigure builddir --buildtype=release -Dlibdir=lib --prefix=$PREFIX -Dtests=false
if errorlevel 1 exit 1

meson install -C builddir
if errorlevel 1 exit 1
