#!/bin/sh

set -e

exec /usr/local/bin/zrepl > testt.txt &
exec service ssh start &
exec service rsyslog start &

child=$!
wait


