#!/bin/sh
UID=$(id -u)
/usr/lib/gvfsd &
/usr/lib/gvfsd-fuse /run/user/$UID/gvfs -f &
/usr/lib/gvfs-udisks2-volume-monitor &
/usr/lib/gvfsd-metadata &
