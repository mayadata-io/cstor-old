#!/bin/sh

set -o errexit
trap 'call_exit $LINE_NO' EXIT

call_exit()
{
echo "at call_exit.."     
echo  "exit code:" $?
echo "reference: "  $0 
}

if [ ! -f "/usr/local/etc/istgt/istgt.conf" ];then
	cp /usr/local/etc/bkpistgt/istgt.conf /usr/local/etc/istgt/
fi
cp /usr/local/etc/bkpistgt/istgtcontrol.conf /usr/local/etc/istgt/
touch /usr/local/etc/istgt/auth.conf
touch /usr/local/etc/istgt/logfile
export externalIP=0.0.0.0
service rsyslog start
sed -i -n '/LogicalUnit section/,$!p' /usr/local/etc/istgt/istgt.conf

exec /usr/local/bin/istgt &

child=$!
wait


