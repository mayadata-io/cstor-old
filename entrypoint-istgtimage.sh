#!/bin/sh

set -o errexit
trap 'call_exit $LINE_NO' EXIT

call_exit()
{
echo "at call_exit.."     
echo  "exit code:" $?
echo "reference: "  $0 
}

volname=vol1
path=/tmp/cstor
size=1G
mkdir -p $path
touch $volname
truncate -s $size $path/$volname
touch $path/sdisk.img
truncate -s $size $path/sdisk.img
touch /tmp/ztest1.0a
truncate -s 1G /tmp/ztest1.0a
cp /usr/local/etc/bkpistgt/istgt.conf /usr/local/etc/istgt/
touch /usr/local/etc/istgt/auth.conf
touch /usr/local/etc/istgt/logfile
externalIP=127.0.0.1
export externalIP=$externalIP
exec /usr/local/bin/istgt &

child=$!
wait


