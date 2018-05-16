#!/bin/sh

set -o errexit
trap 'call_exit $LINE_NO' EXIT

call_exit()
{
echo "at call_exit.."     
echo  "exit code:" $?
echo "reference: "  $0 
}

exec /init.sh volname=vol1 portal=127.0.0.1 path=/tmp/cstor size=10g externalIP=127.0.0.1 replication_factor=3 consistency_factor=2 &

child=$!
wait


