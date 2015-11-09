#!/bin/sh

nmoncmd='nmon -f -s 5 -c 50000 -N -t -p'

# Script to automate the running of nmon on a distributed cluster
# Assumes passwordless ssh to all nodes
node=`uname -n`
shortName=`echo $node | cut -d'.' -f1`

nodeList=`cat nmonnodes.conf`
#echo $nodeList

if [ -f .running ];
	then
		echo "A previous monitoring session has been started!"
		echo "Please run collectnmon.sh first!"
		exit 1
fi

rm -f nmon.pidlist

for n in $nodeList
do
	if [[ ! $n =~ ^# ]];
		then
			sn=`echo $n | cut -d'.' -f1`
			echo "Deploying nmon on $n";
		        if [ $shortName != $n ];
                		then
					lastPid=`ssh $sn $nmoncmd`
			else
					lastPid=`$nmoncmd`
			fi
			echo $sn:$lastPid >> nmon.pidlist
	fi
done
touch .running
