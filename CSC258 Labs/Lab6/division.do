 # Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog -timescale 1ns/1ns division.v

# Load simulation using mux as the top level simulation module.
vsim fpga_top

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}
# Set input values using the force command, signal names need to be in {} brackets.
force {CLOCK_50} 0 0 ns, 1 1 ns -r 2
force {KEY[0]} 0 0 ns, 1 4 ns 
force {KEY[1]} 1 0 ns, 0 8 ns, 1 10 ns, 0 12 ns, 1 14 ns
force {SW[7:0]} 00000011 0 ns, 000000111 11 ns
#Divisor = 3, Dividend = 7
#7/3 = 2 R1 (0001 0010)
# Run simulation for a few ns.
run 55 ns 
