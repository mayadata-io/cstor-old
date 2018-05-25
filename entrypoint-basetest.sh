#!/bin/sh

set -ex

export SHARED_LOC=/tmp/

cp /usr/local/bin/{zrepl,zpool,zfs} $SHARED_LOC

cp /usr/lib/{libzfs*.so*,libnvpair*.so*,libuutil*.so*,libzpool*.so*} $SHARED_LOC
