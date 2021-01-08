 # Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog -timescale 1ns/1ns poly_function.v

# Load simulation using mux as the top level simulation module.
vsim fpga_top

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}
# Set input values using the force command, signal names need to be in {} brackets.
force {CLOCK_50} 0 0 ns, 1 1 ns -r 2
force {KEY[0]} 0 0 ns, 1 4 ns 
force {KEY[1]} 1 0 ns, 0 8 ns, 1 10 ns, 0 12 ns, 1 14 ns, 0 16 ns, 1 18 ns, 0 20 ns, 1 22 ns
force {SW[7:0]} 00000011 0 ns, 000000100 11 ns, 00000101 15 ns, 00000010 19 ns
#A = 3, B = 4, C = 5, x = 2
#Cx^2 + Bx + A = 20 + 8 + 3 = 31 (11111)
# Run simulation for a few ns.
run 55 ns
