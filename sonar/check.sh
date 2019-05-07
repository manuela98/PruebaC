#!/bin/bash
sonardir=sonar
qinstall=0

#Nosetests
cmd=""
if ! nosetests &> /dev/null
then
    thiscmd="sudo apt-get install -y python-nose"
    echo "Nosetests no installed. Run: $thiscmd"
    ((qinstall++))
    cmd="$thiscmd;$cmd"
fi

#Coverage
if ! python -m coverage &> /dev/null
then
    thiscmd="python -m pip install coverage"
    echo "Coverage no installed. Run: $thiscmd"
    ((qinstall++))
    cmd="$thiscmd;$cmd"
fi

#Sonar scanner
if ! sonar-scanner --help &> /dev/null
then
    thiscmd="echo"
    echo "Sonar scanner not installed. Run: download and install sonar"
    ((qinstall++))
    cmd="$thiscmd;$cmd"
fi

#Check proper configuration of sonar
if [ "x$(grep 'eg.' $sonardir/sonar.conf)" != "x" ]
then
    thiscmd="echo"
    echo "Sonar has not been configured yet. Run: edit $sonardir/sonar.conf"
    ((qinstall++))
    cmd="$thiscmd;$cmd"
fi    

#Evaluate dependencies
if [ $qinstall -gt 0 ]
then
    echo "You have $qinstall dependencies to be installed."
    echo -e "Run:\n\t$cmd"
    exit 1
fi
