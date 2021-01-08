module MorseCode(CLOCK_50, LEDR, SW, KEY);
	input CLOCK_50;
	input [2:0] SW;
	input [1:0] KEY;	
	output [0:0] LEDR;

	wire [27:0] Q;
	wire clk;
	
	wire [13:0] morse_code;
	wire out;
	LUT lut(SW[2:0], morse_code);
	rate rd0(CLOCK_50, KEY[0], 28'b0001011111010111100000111111, Q);
	
	assign clk = (Q == 0 ? 1 : 0);
	shifting s0(morse_code, 1'b1, KEY[1], clk, KEY[0], out);
	
	assign LEDR[0] = out;
endmodule

module LUT(letter, morse_code);
	input [2:0] letter;
	output reg [13:0] morse_code;

	always @(letter)
	begin
	case(letter)
		3'b000: morse_code = 14'b00000000010101;
		3'b001: morse_code = 14'b00000000000111;
		3'b010: morse_code = 14'b00000001110101;
		3'b011: morse_code = 14'b00000111010101;
		3'b100: morse_code = 14'b00000111011101;
		3'b101: morse_code = 14'b00011101010111;
		3'b110: morse_code = 14'b01110111010111;
		3'b111: morse_code = 14'b00010101110111;
	endcase
	end
endmodule

module rate(clk, clear, timer, Q);
	input clk, enable, clear, ParLoad;
	input [27:0] timer;
	output [27:0] Q;
	reg [27:0] Q;
	always @(posedge clk)
	begin
		//if we want to clear values
		if(clear == 1'b0)
			Q <= 0;
		//if the value has reached 0 (load the original)
		else if(Q == 28'b0000000000000000000000000000)
			Q <= timer;
		//if enable is 1, then count down
		else
			Q <= Q - 1'b1;
	end
endmodule

// asr is 1'b0 and last is the output
module shifting(load_val, shift, load_n, clk, reset_n, last);
	input [13:0] load_val;
	input shift, load_n, clk, reset_n;
	output last;
	wire [13:0] out;
	
	assign last = out[0];
	
	wire in_wire;
	in_wire = 1'b0;
	
	one_bit_shifter o13(load_val[13], in_wire, shift, load_n, clk, reset_n, out[13]);
	one_bit_shifter o12(load_val[12], out[13], shift, load_n, clk, reset_n, out[12]);
	one_bit_shifter o11(load_val[11], out[12], shift, load_n, clk, reset_n, out[11]);
	one_bit_shifter o10(load_val[10], out[11], shift, load_n, clk, reset_n, out[10]);
	one_bit_shifter o9(load_val[9], out[10], shift, load_n, clk, reset_n, out[9]);
	one_bit_shifter o8(load_val[8], out[9], shift, load_n, clk, reset_n, out[8]);
	one_bit_shifter o7(load_val[7], out[8], shift, load_n, clk, reset_n, out[7]);
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
	
	reg q;
	
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