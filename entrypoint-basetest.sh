#!/usr/bin/env bash

set -ex

export SHARED_LOC=/tmp/

cp /usr/local/bin/zrepl $SHARED_LOC
cp /usr/local/bin/zpool $SHARED_LOC
cp /usr/local/bin/zfs $SHARED_LOC

cp /usr/lib/libzfs*.so* $SHARED_LOC
cp /usr/lib/libnvpair*.so* $SHARED_LOC
cp /usr/lib/libuutil*.so* $SHARED_LOC
cp /usr/lib/libzpool*.so* $SHARED_LOC
cp /usr/lib/libzrepl*.so* $SHARED_LOC
