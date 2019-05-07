#!/bin/bash
basedir=$(pwd)
packdir=$(dirname $0)
pack=$1
if [ "x$pack" == "x" ];then pack="pack";fi

if [ $packdir != "./.store" ];then 
    storedir="$packdir/../../.store"
    if [ ! -d "$storedir" ];then 
	mkdir -p $storedir
	cp -rf $packdir/pack.sh $storedir/
	cp -rf $packdir/pack.conf $storedir/
	sed -i.bak "s/RepoBasics\/store/.store/" $storedir/pack.conf
	git add $storedir/*.sh $storedir/*.conf
    fi
else
    storedir=$packdir
fi

confile="pack.conf"

if [ $pack = "pack" ];then
    echo "Packing..."
    rm -r $storedir/*--* &> /dev/null
    for file in $(cat $storedir/$confile |grep -v "#")
    do
	echo -e "\tfile $file..."
	fname=$(basename $file)
	dname=$(dirname $file)
	uname=$(echo $dname |sed -e s/\\//_/)
	sdir="$storedir/$uname--$fname"
	mkdir -p "$sdir"
	cd $sdir
	split -b 20000 $basedir/$file $fname-
	cd - &> /dev/null
	git add "$storedir/$uname--$fname/*"
    done
    git add $storedir/*--*
else
    echo "Unpacking..."
    for file in $(cat $storedir/$confile |grep -v "#")
    do
	echo -e "\tUnpacking $file..."
	fname=$(basename $file)
	dname=$(dirname $file)
	uname=$(echo $dname |sed -e s/\\//_/)
	sdir="$storedir/$uname--$fname"
	cat "$sdir"/$fname-* > $dname/$fname
    done
fi
