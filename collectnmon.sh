#!/bin/sh
#set -x

# Script to automate the shutting down of nmon on a distributed cluster
# and collecting the nmon data
# Assumes passwordless ssh to all nodes
if [ ! -f .running ];
	then
		echo "No session currently active!"
		echo "Please start a monitoring session first with runnmon.sh!"
		exit 1
fi

pidList=`cat nmon.pidlist`
#echo $nodeList

node=`uname -n`
shortName=`echo $node | cut -d'.' -f1`
#echo $shortName

for p in $pidList
do
        n=`echo $p | cut -d':' -f1`
	pid=`echo $p | cut -d':' -f2`
	echo "collecting nmon data and stopping processes on $n"
	ssh $n kill -USR2 $pid
	if [ $shortName != $n ];
		then 
			scp $n:*nmon .
			ssh $n rm -f *nmon
	fi
done

#now process the files for downloading
rm -f nmon.zip
zip nmon.zip *nmon
rm -f *nmon
rm -f .running
echo Now download nmon.zip and start the spreadsheet processing


