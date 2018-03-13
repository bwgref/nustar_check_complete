#!/usr/local/bin/bash

# IDL startup for batch jobs
export IDL_STARTUP=$TROOT/setup/idl_lif.pro

#export IDL_STARTUP=$L1SCRIPTS/idl/startup/defb.pro
IDL_LOC=/usr/local/rsi/idl71/bin
${IDL_LOC}/idl -quiet update_gaps.bat

