vlib work

vlog -timescale 1ns/1ns mux7to1.v

vsim mux

log {/*}

add wave {/*}

force {SW[7]} 0 0, 1 40 -repeat 80
force {SW[8]} 0 0, 1 80 -repeat 160
force {SW[9]} 0 0, 1 160 -r 320

force {SW[0]} 0 0, 1 20, 0 40
force {SW[1]} 0 0, 1 60, 0 80
force {SW[2]} 0 0, 1 100, 0 120
force {SW[3]} 0 0, 1 140, 0 160
force {SW[4]} 0 0, 1 180, 0 200
force {SW[5]} 0 0, 1 220, 0 240
force {SW[6]} 0 0, 1 260, 0 280

run 320 ns
