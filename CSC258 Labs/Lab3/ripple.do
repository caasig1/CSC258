vlib work

vlog -timescale 1ns/1ns rippleAdder4bit.v

vsim mux

log {/*}

add wave {/*}

# Two test cases presented here
#    1. First full adder carry into second full adder
#		Output should be 0010 cout=0
#    2. Second full adder carry into third full adder
#		Output should be 0100 cout=0
force {SW[0]} 1 0, 0 5
force {SW[1]} 0 0, 1 5
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 1 0, 0 5
force {SW[5]} 0 0, 1 5
force {SW[6]} 0
force {SW[7]} 0
force {SW[8]} 0 
run 10ns
# Two test cases presented here
#    1. Third full adder carry into fourth full adder
#		Output should be 1000 cout=0
#    2. Fourth full adder carry to cout
#		Output should be 0000 cout=1
force {SW[0]} 0
force {SW[1]} 0 
force {SW[2]} 1 0, 0 5
force {SW[3]} 0 0, 1 5
force {SW[4]} 0
force {SW[5]} 0 
force {SW[6]} 1 0, 0 5
force {SW[7]} 0 0, 1 5
force {SW[8]} 0 
run 10ns
# Two test cases presented here
#    1. Input passed into cin for an initial carry
#		Output should be 0111 cout=0
#    2. All carries are used except for cin
#		Output should be 1110 cout=1
force {SW[0]} 0 0, 1 5
force {SW[1]} 0 0, 1 5
force {SW[2]} 1 
force {SW[3]} 0 0, 1 5
force {SW[4]} 0 0, 1 5
force {SW[5]} 1 
force {SW[6]} 0 0, 1 5
force {SW[7]} 0 0, 1 5
force {SW[8]} 1 0, 0 5
run 10ns

# Test if everything set to 1 produces the correct output
# Everything should output as 1 cout=1
force {SW[0]} 1
force {SW[1]} 1 
force {SW[2]} 1 
force {SW[3]} 1
force {SW[4]} 1 
force {SW[5]} 1 
force {SW[6]} 1
force {SW[7]} 1
force {SW[8]} 1
run 10ns
