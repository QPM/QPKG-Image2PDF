#!/bin/sh
case "$1" in
  start)
    : ADD START ACTIONS HERE
    chmod 655 $SYS_QPKG_DIR/bin/phantomjs
    chmod 777 $SYS_QPKG_DIR/output
    cp $SYS_QPKG_DIR/lib/libfontconfig.so.1 /usr/lib/libfontconfig.so.1
    if [ -f "${SYS_QPKG_DIR}/lib/libXext.so.6" ]; then 
      cp $SYS_QPKG_DIR/lib/libXext.so.6 /usr/lib/libXext.so.6
    fi
    if [ -f "${SYS_QPKG_DIR}/lib/libX11.so.6" ]; then 
      cp $SYS_QPKG_DIR/lib/libX11.so.6 /usr/lib/libX11.so.6
    fi 
    ;;

  stop)
    : ADD STOP ACTIONS HERE
    ;;
  pre_install)
    : ADD PRE INSTALL ACTIONS HERE
    ;;
  post_install)
    # Install after forced start service
    : ADD POST INSTALL ACTIONS HERE
    ;;
  pre_uninstall)
    # Uninstall before forced stop service
    : ADD PRE UNINSTALL ACTIONS HERE
    ;;
  post_uninstall)
    : ADD POST UNINSTALL ACTIONS HERE
    ;;
esac