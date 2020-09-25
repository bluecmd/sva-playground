.PHONY: sby wave lint modelsim

sby:
	sby -f backdoor.sby -d yosys || echo "!!!\nOh oh! Seems there is a backdoor! Run 'make wave' to inspect it."

lint:
	vlog -work .linttmp -lint -sv safe.sv tb.sv

wave: yosys/engine_0/trace.vcd
	gtkwave --save backdoor.gtkw --dump=$<
	sed -i '/^\[dumpfile/d' backdoor.gtkw
	sed -i '/^\[savefile/d' backdoor.gtkw
	sed -i '/^\[\*]/d' backdoor.gtkw
