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

run 10us

if [batch_mode] {
  if [expr {!$broken}] {
    puts "Failed: test reached deadline"
    exit -code 1
  }
  exit -code [expr [assertion count -fails -r /] > 0]
}
