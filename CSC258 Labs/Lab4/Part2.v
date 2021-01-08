module alu(SW, KEY, LEDR, HEX0, HEX4, HEX5);
	input [9:0] SW;
	input [1:0] KEY;
	output [7:0] LEDR;
	output [6:0] HEX0, HEX4, HEX5;

	wire [7:0] reg_out;
	wire [7:0] no_reg_out;
	
	aluOut alu0 (
		.A(SW[3:0]),
		.B(reg_out[3:0]),
		.func(SW[7:5]),
		.out(no_reg_out)
	);
	
	register reg0 (
		.clk(KEY[0]),
		.reset_n(SW[9]),
		.d(no_reg_out),
		.q(reg_out)
	);
	
	assign LEDR[7:0] = reg_out;
	
	seven_seg hx0 (SW[3:0], HEX0);
	
	seven_seg hx4 (LEDR[3:0], HEX4);
	
	seven_seg hx5 (LEDR[7:4], HEX5);
	
endmodule

module register(clk, reset_n, d, q);
	input clk; // clock
	input reset_n; // reset
	input [7:0] d; // input of 8 from ALU
	output [7:0] q; 
	
	reg [7:0] q;
	
	always @(posedge clk)
	
	begin
		if (reset_n == 1'b0)
			q <= 0;
		else
			q <= d;
	end
endmodule

module aluOut(A, B, func, out);
	input [3:0] A;
	input [3:0] B;
	input [2:0] func;
	output [7:0]out;
	wire carry_AB;
	wire [3:0]sum_AB;
	rippleAdder4bit r1(A, B, 1'b0, carry_AB, sum_AB);
	
	wire carry_A1;
	wire [3:0]sum_A1;
	rippleAdder4bit r2(A, 4'b0001, 1'b0, carry_A1, sum_A1);
	
	reg [7:0]out;
	
	always @(*)
	begin
		case(func)
			3'b000: out = {3'b000, carry_A1, sum_A1};
			3'b001: out = {3'b000, carry_AB, sum_AB};
			3'b010: out = {4'b0000, A + B};
			3'b011: out = {A | B, A ^ B};
			3'b100: out = (A | B != 4'b0000) ? 8'b00000001 : 8'b00000000; 
			3'b101: out = (B << A);
			3'b110: out = (B >> A);
			3'b111: out = (A*B);
			default: out = 8'b00000000;
		endcase
	end

endmodule

module seven_seg(bin, seg);
	input[3:0] bin;
	output[0:6] seg;
	
	reg [0:6] seg;
	always @(bin)
		begin
			case(bin)
				0: seg = 7'b0000001;
				1: seg = 7'b1001111;
				2: seg = 7'b0010010;
				3: seg = 7'b0000110;
				4: seg = 7'b1001100;
				5: seg = 7'b0100100;
				6: seg = 7'b0100000;
				7: seg = 7'b0001111;
				8: seg = 7'b0000000;
				9: seg = 7'b0000100;
				10: seg = 7'b0001000;
				11: seg = 7'b1100000;
				12: seg = 7'b0110001;
				13: seg = 7'b1000010;
				14: seg = 7'b0110000;
				15: seg = 7'b0111000;
				default: seg = 7'b1111111;
			endcase
		end
endmodule

module rippleAdder4bit(a, b, cin, cout, s); // FROM LAB3 PART2
	input [3:0] a;
	input [3:0] b;
	input cin;
	output cout;
	output [3:0] s;
	wire c1, c2, c3;
	
	fullAdder f0(
		.one(a[0]),
		.two(b[0]),
		.cin(cin),
		.cout(c1),
		.s(s[0])
	);
	
	fullAdder f1(
		.one(a[1]),
		.two(b[1]),
		.cin(c1),
		.cout(c2),
		.s(s[1])
	);
	
	fullAdder f2(
		.one(a[2]),
		.two(b[2]),
		.cin(c2),
		.cout(c3),
		.s(s[2])
	);
	
	fullAdder f3(
		.one(a[3]),
		.two(b[3]),
		.cin(c3),
		.cout(cout),
		.s(s[3])
	);
	
endmodule

module fullAdder(one, two, cin, cout, s); // FROM LAB3 PART2
	input one, two, cin;
	output cout, s;
	
	assign s = ~cin & (one^two) | cin & ~(one ^ two);
	assign cout = cin & (one|two) | ~cin & (one&two);
endmodule