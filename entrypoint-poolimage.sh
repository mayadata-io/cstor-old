#!/bin/sh

set -o errexit
trap 'call_exit $LINE_NO' EXIT

call_exit()
{
echo "at call_exit.."     
echo  "exit code:" $?
echo "reference: "  $0 
}

service ssh start

if [ -z "$LOGLEVEL" ]; then
	LOGLEVEL=info
fi
exec /usr/local/bin/zrepl -l $LOGLEVEL
