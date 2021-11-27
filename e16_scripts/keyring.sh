#!/bin/sh
/usr/bin/gnome-keyring-daemon --daemonize --login
exec /usr/bin/gnome-keyring-daemon --start --components=ssh,pkcs11,secrets
