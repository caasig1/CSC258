module shifter(SW, KEY, LEDR);
	input [9:0] SW;
	input [3:0] KEY;
	output [7:0] LEDR;

	shifting s0(
			.load_val(SW[7:0]),
			.shift(KEY[2]),
			.load_n(KEY[1]),
			.clk(KEY[0]),
			.reset_n(SW[9]),
			.ASR(KEY[3]),
			.out(LEDR[7:0])
	);
endmodule

module shifting(load_val, shift, load_n, clk, reset_n, ASR, out);
	input [7:0] load_val;
	input shift, load_n, clk, reset_n, ASR;
	output [7:0] out;
	
	wire in_wire;
	
	mux2 m0(0, load_val[7], ASR, in_wire);
	one_bit_shifter o7(load_val[7], in_wire, shift, load_n, clk, reset_n, out[7]);
	one_bit_shifter o6(load_val[6], out[7], shift, load_n, clk, reset_n, out[6]);
	one_bit_shifter o5(load_val[5], out[6], shift, load_n, clk, reset_n, out[5]);
	one_bit_shifter o4(load_val[4], out[5], shift, load_n, clk, reset_n, out[4]);
	one_bit_shifter o3(load_val[3], out[4], shift, load_n, clk, reset_n, out[3]);
	one_bit_shifter o2(load_val[2], out[3], shift, load_n, clk, reset_n, out[2]);
	one_bit_shifter o1(load_val[1], out[2], shift, load_n, clk, reset_n, out[1]);
	one_bit_shifter o0(load_val[0], out[1], shift, load_n, clk, reset_n, out[0]);
endmodule

module one_bit_shifter(load_val, in, shift, load_n, clk, reset_n, out);
	input load_val, in, shift, load_n, clk, reset_n;
	output out;
	
	wire shift_to_loadn;
	wire loadn_to_d;
	
	mux2 m1(out, in, shift, shift_to_loadn);
	mux2 m2(load_val, shift_to_loadn, load_n, loadn_to_d);
	
	dFF d1(clk, reset_n, loadn_to_d, out);
endmodule

module dFF(clk, reset_n, d, q);
	input clk; // clock
	input reset_n; // reset
	input d; // input of 8 from ALU
	output q; 
	
	reg [7:0] q;
	
	always @(posedge clk)
	
	begin
		if (reset_n == 1'b0)
			q <= 0;
		else
			q <= d;
	end
endmodule

module mux2(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;

endmodule