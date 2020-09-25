# * vim: syntax=tcl

mkdir -p modelsim/libraries
cd modelsim
vlib work
vlog -sv ../safe.sv ../tb.sv
vsim -voptargs="+acc=rn+testbench +acc=rn+safe" testbench -L work

set broken 0
onbreak {
 set broken 1
 resume
}

log -r /*
add wave sim:/testbench/*

run -all

if [batch_mode] {
  exit -code 0
}
