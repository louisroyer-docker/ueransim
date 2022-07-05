#!/usr/bin/env bash

tun_is_up () {
	ip link ls | grep "state UP" | grep uesimtun 2>&1> /dev/null
	return $?
}


until tun_is_up 
do
	sleep 1
done
# Usually interface name is uesimtun0, because the prefix is uesimtun and
# there is no other uesimtun interface.
# This script would not work with multiple uesimtun interfaces because you would have to
# use something else than "default" route.
# The only advantage of not hardcoding uesimtun0 is the case where you have multiple
# uesimtun interfaces, but only 1 is up. This will probably not happend.
T=$(ip link ls | grep "state UP" | grep uesimtun | awk 'BEGIN {FS=": "}; {print $1; exit}')
# By default, UERANSIM only create route on a specific table to preserve default route.
# This is fine in a VM, where you might want to keep the route and use nr-binder.
# But it is better to have a container with the same behaviour as a real UE.
ip -4 route replace default dev "${T}" proto static
ip -6 route replace default dev "${T}" proto static