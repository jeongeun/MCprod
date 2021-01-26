#!/bin/bash

TopDir=`pwd`
export SCRAM_ARCH=slc7_amd64_gcc820
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh
cd /x3/cms/jelee/MCProd/Run3Gen/CMSSW_11_0_3/src
eval `scram runtime -sh`

cd $TopDir
export X509_USER_PROXY=$TopDir/x509up_u521
echo "##Start !! voms-proxy-info "
voms-proxy-info

Mass=$1
RunN=$2
Idx=$3
nEvt=$4

echo "`pwd` `hostname` `uname -a`"

Name="wptoenu"
output_gs="step1_${Name}_${Mass}_gs_${RunN}_${Idx}.root"
output_dr="step2_${Name}_${Mass}_dr_${RunN}_${Idx}.root"
output_aod="step3_${Name}_${Mass}_aod_${RunN}_${Idx}.root"
output_mini="step3_${Name}_${Mass}_mini_${RunN}_${Idx}.root"
#output_nano="step4_${Name}_${Mass}_nano_${RunN}_${Idx}.root"

echo "### start step1 DDD `date` `hostname` `uname -a`"
./runStep1.sh $Mass $RunN $Idx $nEvt $output_gs
ls -alh
echo "Show me the space"
du -h
echo "Show me the left space"
df -h
s1ROOT=`find . -maxdepth 1 -type f -name "step1_*gs*.root"`

echo "### start step2 DDD `date` `hostname` `uname -a`"
echo " ### Show me the voms ### "
voms-proxy-info
echo " ### ################ ### "
./runStep23.sh $output_gs $output_dr $output_aod $output_mini
ls -alh
echo "Show me the space"
du -h
echo "Show me the left space"
df -h
s2ROOT=`find . -maxdepth 1 -type f -name "step2_*dr*.root"`
s3ROOT=`find . -maxdepth 1 -type f -name "step3_*mini*.root"`

#echo "### start step4 DDD `date` `hostname` `uname -a`"
#./runStep4.sh $ $output_mini $output_nano
#ls -alh
#echo "Show me the space"
#du -h
#echo "Show me the left space"
#df -h
#s4ROOT=`find . -maxdepth 1 -type f -name "step4_*nano*.root"`




mkdir condorOut/
mv *.log *_cfg.py ${s1ROOT} ${s2ROOT} ${s3ROOT} condorOut/
#${s4ROOT}  condorOut/

echo "### ENDJob ###"
cd condorOut/
ls 
pwd

