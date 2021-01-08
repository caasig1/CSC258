`timescale 1ns / 1ns

module counter(SW, HEX0, CLOCK_50);
	input [3:0] SW;
	output [6:0] HEX0;
	input CLOCK_50;
	wire [27:0] rd0_out, rd1_out, rd2_out, rd3_out;
	reg Enable;
	wire [3:0] dc0_out;
	
	//Counter, 00 counts every tick (make it 0)
	// 01 counts 1 hz, so 49,999,999 times before it goes
	// 10 and 11 are 2x and 3x 50,000,000 - 1 times before it ticks
	rate rd00(CLOCK_50, rd0_out, SW[2], 1'b1, 28'b0000000000000000000000000000, SW[3]);
	rate rd01(CLOCK_50, rd1_out, SW[2], 1'b1, 28'b0010111110101111000001111111, SW[3]);
	rate rd10(CLOCK_50, rd2_out, SW[2], 1'b1, 28'b0101111101011110000011111111, SW[3]);
	rate rd11(CLOCK_50, rd3_out, SW[2], 1'b1, 28'b1011111010111100000111111111, SW[3]);
	
	// If the output of these clocks have reached 0, then make the enable 1
	always @(*)
	begin
		case(SW[1:0])
			2'b00: Enable = (rd0_out == 28'b0000000000000000000000000000) ? 1'b1 : 1'b0;
			2'b01: Enable = (rd1_out == 28'b0000000000000000000000000000) ? 1'b1 : 1'b0;
			2'b10: Enable = (rd2_out == 28'b0000000000000000000000000000) ? 1'b1 : 1'b0;
			2'b11: Enable = (rd3_out == 28'b0000000000000000000000000000) ? 1'b1 : 1'b0;
			default: Enable = 1'b0;
		endcase
	end
	
	dCounter dc0(CLOCK_50, dc0_out, SW[2], Enable);
	seven_seg s0(dc0_out, HEX0);
endmodule

module rate(clk, Q, clear, enable, d, ParLoad);
	input clk, enable, clear, ParLoad;
	input [27:0] d;
	output [27:0] Q;
	reg [27:0] Q;
	always @(posedge clk)
	begin
		//if we want to clear values
		if(clear == 1'b0)
			Q <= 0;
		//if we want to load a value
		else if(ParLoad == 1'b1)
			Q <= d;
		//if the value has reached 0 (load the original)
		else if(Q == 28'b0000000000000000000000000000)
			Q <= d;
		//if enable is 1, then count down
		else if(enable == 1'b1)
			Q <= Q - 1'b1;
	end
endmodule

// counter for the display, each time the timer is enabled, the display counter changes
module dCounter(clk, Q, clear, enable);
	input clk, enable, clear;
	output [3:0] Q;
	reg [3:0] Q;
	always @(posedge clk)
	begin
		if(clear == 1'b0)
			Q <= 0;
		else if(enable == 1'b1)
			Q <= Q + 1'b1;
		else if(enable == 1'b0)
			Q <= Q;
	end
endmodule

// seven segment decoder
module seven_seg(S,HEX0); // FROM LAB2
	input [3:0]S;
	output [6:0]HEX0;
	
	assign HEX0[0] = (~S[3]&~S[2]&~S[1]&S[0])|(~S[3]&S[2]&~S[1]&~S[0])|(S[3]&S[2]&~S[1]&S[0])|(S[3]&~S[2]&S[1]&S[0]);
	assign HEX0[1] = (S[3]&S[2]&~S[0])|(~S[3]&S[2]&~S[1]&S[0])|(S[3]&S[1]&S[0])|(S[2]&S[1]&~S[0]);
	assign HEX0[2] = (~S[3]&~S[2]&S[1]&~S[0])|(S[3]&S[2]&S[1])|(S[3]&S[2]&~S[0]);
	assign HEX0[3] = (~S[3]&~S[2]&~S[1]&S[0])|(~S[3]&S[2]&~S[1]&~S[0])|(S[3]&~S[2]&S[1]&~S[0])|(S[2]&S[1]&S[0]);
	assign HEX0[4] = (~S[3]&S[0])|(~S[3]&S[2]&~S[1])|(~S[2]&~S[1]&S[0]);
	assign HEX0[5] = (~S[3]&~S[2]&S[0])|(~S[3]&~S[2]&S[1])|(~S[3]&S[1]&S[0])|(S[3]&S[2]&~S[1]&S[0]);
	assign HEX0[6] = (~S[3]&~S[2]&~S[1])|(~S[3]&S[2]&S[1]&S[0])|(S[3]&S[2]&~S[1]&~S[0]);
endmodule