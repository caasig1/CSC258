 vlib work

vlog -timescale 1ns/1ns Part3.v

vsim shifter

log {/*}

add wave {/*}

# A=0101_1101=93 reset = 1, just loading n so output should be A
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 1
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 0

force {KEY[0]} 0 0, 1 20 -repeat 40
force {KEY[1]} 0
force {KEY[2]} 0
force {KEY[3]} 0
force {SW[9]} 1

run 40ns

# A=0101_1101=93 reset = 1, no ASR output should be 0010_1110 then 0001_0111

force {KEY[0]} 0 0, 1 20 -repeat 40
force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 0
force {SW[9]} 1

run 80ns

# A=1101_1101=93 reset = 1, just loading n so output should be A
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 1
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 1

force {KEY[0]} 0 0, 1 20 -repeat 40
force {KEY[1]} 0
force {KEY[2]} 0
force {KEY[3]} 0
force {SW[9]} 1

run 40ns

# A=1101_1101=93 reset = 1, no ASR output should be 1110_1110 then 1111_0111
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 1
force {SW[4]} 1
force {SW[5]} 0
force {SW[6]} 1
force {SW[7]} 1

force {KEY[0]} 0 0, 1 20 -repeat 40
force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 1
force {SW[9]} 1

run 80ns

