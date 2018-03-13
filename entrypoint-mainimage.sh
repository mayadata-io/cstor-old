#!/bin/sh

set -o errexit
trap 'call_exit $LINE_NO' EXIT

call_exit()
{
echo "at call_exit.."     
echo  "exit code:" $?
echo "reference: "  $0 
}

exec /usr/local/bin/zrepl > /var/log/zrepl.out &
exec service ssh start &
exec service rsyslog start &

child=$!
wait


