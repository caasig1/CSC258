vlib work

vlog -timescale 1ns/1ns Part2.v

vsim alu

log {/*}

add wave {/*}

# A=5 case=0 reset = 0 (so B=0) expected:0
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0

force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 0 0, 1 20, 0 40
force {SW[9]} 0
run 40ns

# A=0101 case=0 reset = 1 (so B=0000) expected:0000_0110
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0

force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 0 0, 1 20, 0 40
force {SW[9]} 1
run 40ns

# A=0101 case=1 reset = 1 (so B=0110) expected:0000_1011
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0

force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 0

force {KEY[0]} 0 0, 1 20, 0 40
force {SW[9]} 1
run 40ns

# A=0101 case=2 reset = 1 (so B=1011) expected:0001_0000
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0

force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 0

force {KEY[0]} 0 0, 1 20, 0 40
force {SW[9]} 1
run 40ns

# A=0101 case=3 reset = 1 (so B=0000) expected:0101_0101
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0

force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 0

force {KEY[0]} 0 0, 1 20, 0 40
force {SW[9]} 1
run 40ns

# A=0101 case=4 reset = 1 (so B=0101) expected:0000_0001
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0

force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 1

force {KEY[0]} 0 0, 1 20
force {SW[9]} 1
run 40ns

# A=0010 case=5 reset = 1 (so B=0001) expected:0000_0100
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0

force {SW[5]} 1
force {SW[6]} 0
force {SW[7]} 1

force {KEY[0]} 0 0, 1 20
force {SW[9]} 1
run 40ns

# A=0001 case=6 reset = 1 (so B=0100) expected:0000_0010
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0

force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 1

force {KEY[0]} 0 0, 1 20
force {SW[9]} 1
run 40ns

# A=0111 (7) case=7 reset = 1 (so B=0010 (2)) expected:14 0000_1110
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 0

force {SW[5]} 1
force {SW[6]} 1
force {SW[7]} 1

force {KEY[0]} 0 0, 1 20
force {SW[9]} 1
run 40ns
