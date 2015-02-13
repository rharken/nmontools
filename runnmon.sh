#!/bin/sh

# Script to automate the running of nmon on a distributed cluster
# Assumes passwordless ssh to all nodes

nodeList=`cat nmonnodes.conf`
#echo $nodeList

rm -f nmon.pidlist

for n in $nodeList
do
	if [[ ! $n =~ ^# ]];
		then
			sn=`echo $n | cut -d'.' -f1`
			echo "Deploying nmon on $n";
			lastPid=`ssh $sn 'nmon -f -s 5 -t -p'`
			echo $sn:$lastPid >> nmon.pidlist
	fi
done

