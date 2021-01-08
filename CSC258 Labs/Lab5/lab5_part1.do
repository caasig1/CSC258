 # Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog lab5_part1.v

# Load simulation using mux as the top level simulation module.
vsim eightbit

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}
# nothing
force {SW[0]} 0
force {SW[1]} 0
force {KEY[0]} 0
run 5ns
# 1
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 5ns
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 5ns
# 2
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 5ns
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 5ns
#3
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 5ns
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 0
run 5ns
#4
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 5ns
#0
force {SW[0]} 0
force {SW[1]} 0
force {KEY[0]} 0
run 5ns
#1
force {SW[0]} 1
force {SW[1]} 1
force {KEY[0]} 1
run 5ns
#1
force {SW[0]} 1
force {SW[1]} 0
force {KEY[0]} 0
run 5ns
#1
force {SW[0]} 1
force {SW[1]} 0
force {KEY[0]} 1
run 5ns
