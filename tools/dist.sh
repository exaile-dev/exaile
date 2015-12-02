#!/bin/sh

EXAILE_DIR=`dirname $0`/..
DIST_VERSION=`EXAILE_DIR=$EXAILE_DIR python2 -c 'import xl.xdg; xl.xdg.local_hack=False; import xl.version; print xl.version.__version__'` 

if [ ! -f "tools/installer/build_win32_installer.sh" ]; then
  echo "python-gtk3-gst-sdk links not installed (use create_links.sh)! Cannot build windows installer"
  exit 1
fi

echo "Creating distribution for Exaile $DIST_VERSION"

tar --gzip --format=posix --owner 0 --group 0 \
    -cf dist/exaile-${DIST_VERSION}.tar.gz dist/copy \
    --exclude=dist/copy/.git* \
    --transform s/dist\\/copy/exaile-${DIST_VERSION}/

#
# See tools/installer/README.md for instructions
#

echo "Generating Windows installer via python-gtk3-gst-sdk"

pushd tools/installer
./build_win32_installer.sh
popd 

mv tools/win-installer/exaile-LATEST.exe dist/exaile-${DIST_VERSION}.exe

gpg --armor --sign --detach-sig dist/exaile-${DIST_VERSION}.tar.gz
gpg --armor --sign --detach-sig dist/exaile-${DIST_VERSION}.exe
