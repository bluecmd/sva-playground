workspace.open safecracker.rwsp

design.compile safecracker
design.simulation.initialize testbench

fsm.list.view.activate
fsm.list.tree.expandall

log -recursive /*
run -all

if [batch_mode] {
  exit -code 0
}

# GUI mode
fsm.list.tree.focus state
fsm.list.showgraph
