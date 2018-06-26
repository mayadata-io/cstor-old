#!/bin/sh

set -o errexit
trap 'call_exit $LINE_NO' EXIT

call_exit()
{
echo "at call_exit.."     
echo  "exit code:" $?
echo "reference: "  $0 
}

cp /usr/local/etc/bkpistgt/istgt.conf /usr/local/etc/istgt/
touch /usr/local/etc/istgt/auth.conf
touch /usr/local/etc/istgt/logfile
externalIP=0.0.0.0
export externalIP=$externalIP
service rsyslog start
exec /usr/local/bin/istgt &

child=$!
wait


