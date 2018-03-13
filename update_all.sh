#!/usr/local/bin/bash

#source $NUSTARSETUP
source ~/SOC_setup_FLT.sh

export TROOT=/disk/lif2/bwgref/git/nustar_check_complete
cd $TROOT

echo "Updating gap info." > update.log
echo >> update.log
now=`date`
echo $now >> update.log
./update_gaps.sh >> update.log 2>&1

./push_slack.sh update.log >> /dev/null
