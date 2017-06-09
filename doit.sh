#!/bin/bash

if [ ! -d "work" ]; then
	echo "******Making Work Directory...******"
  vlib work
fi

if [ -s "tas.sv" ]; then
	echo "******Compiling tas.sv******"
  vlog tas.sv
fi

if [ -s "dv_script" ]; then
	echo "******Synthesizing to gate level file gate.v******"
  dc_shell-xg-t -f dv_script
fi

	echo "******Compiling gate.v******"
	vlog tas.gate.v

	echo "******Running vsim with gate.v using x.do******"
	vsim -novopt tas
