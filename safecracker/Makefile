.PHONY: sby wave lint modelsim

sby:
	sby -f safecracker.sby -d yosys

lint:
	vlog -work .linttmp -lint -sv safe.sv tb.sv

wave: yosys/engine_0/trace0.vcd
	gtkwave --save safecracker.gtkw --dump=$<
	sed -i '/^\[dumpfile/d' safecracker.gtkw
	sed -i '/^\[savefile/d' safecracker.gtkw
	sed -i '/^\[\*]/d' safecracker.gtkw

modelsim:
	vsim -c -do msim.do
