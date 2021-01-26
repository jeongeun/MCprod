#!/bin/bash


TopDir=`pwd`
masses="200 400 600 800 1000 1200 1400 1600 1800 2000 2200 2400 2600 2800 3000 3200 3400 3600 3800 4000 4200 4400 4600 4800 5000 5200 5400 5600 5800 6000 6200 6400 6600 6800 7000 7200 7400 7600 7800 8000"

for mass in $masses
do
	COM=14
	fragmentPY=WprimeToENu_M_${mass}_TuneCP5_${COM}TeV_pythia8_cfi.py
	echo $fragmentPY

cat << EOF > $fragmentPY
import FWCore.ParameterSet.Config as cms

from Configuration.Generator.Pythia8CommonSettings_cfi import *
from Configuration.Generator.MCTunes2017.PythiaCP5Settings_cfi import *

generator = cms.EDFilter("Pythia8GeneratorFilter",
        comEnergy = cms.double(${COM}000.0),
        crossSection = cms.untracked.double(1),
        filterEfficiency = cms.untracked.double(1),
        maxEventsToPrint = cms.untracked.int32(1),
        pythiaHepMCVerbosity = cms.untracked.bool(False),
        pythiaPylistVerbosity = cms.untracked.int32(1),
        PythiaParameters = cms.PSet(
              pythia8CommonSettingsBlock,
              pythia8CP5SettingsBlock,
              
              processParameters = cms.vstring(
                  'NewGaugeBoson:ffbar2Wprime = on',
                  '34:m0 = ${mass}',
                  '34:onMode = off',
                  '34:onIfAny = 11,12',
                  ),
             parameterSets = cms.vstring('pythia8CommonSettings',
                                            'pythia8CP5Settings',
                                            'processParameters')
             )
)

ProductionFilterSequence = cms.Sequence(generator)
EOF

chmod +x ${fragmentPY}

done

scram b -j4
