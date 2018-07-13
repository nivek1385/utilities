#!/bin/bash
#ip: Provides public and private IP addresses. Without interface specified, defaults to iface of default route
whoami
echo -e \ - Public facing IP Address:
curl ipecho.net/plain
echo
echo -e \ - Internal IP Address:
if [ $# -eq 0 ]
  then
        int=$(route | grep '^default' | grep -o '[^ ]*$')
        echo "No interface supplied, using default route's interface: $int"
else
        int=$1
fi
if [ "$(ifconfig $int | grep 'inet')" != "" ]; then
        ifconfig $int | grep 'inet ' | sed "s/   \+/:/" | sed "s/  .*//" | sed "s/[a-z: ]\+//"
else
        echo "No IP address found for interface $int"
fi
