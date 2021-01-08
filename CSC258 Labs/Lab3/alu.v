module alu(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [7:0] SW;
	input [2:0] KEY;
	output [7:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	aluOut alu0 (
		.A(SW[7:4]),
		.B(SW[3:0]),
		.func(KEY[2:0]),
		.out(LEDR[7:0])
	);
	
	wire [3:0] B;
	assign B = SW[3:0];
	wire [3:0] A;
	assign A = SW[7:4];
	wire [3:0] Aout30;
	assign Aout30 = LEDR[3:0];
	wire [3:0] Aout74;
	assign Aout74 = LEDR[7:4];
	
	seven_seg_decoder hx0 (B, HEX0);
	
	seven_seg_decoder hx1 (4'b0000, HEX1);
	
	seven_seg_decoder hx2 (A, HEX2);
	
	seven_seg_decoder hx3 (4'b0000, HEX3);
	
	seven_seg_decoder hx4 (Aout30, HEX4);
	
	seven_seg_decoder hx5 (Aout74, HEX5);
	
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
			3'b101: out = {A, B};
			default: out = 8'b00000000;
		endcase
	end

endmodule

module seven_seg_decoder(S,HEX0); // FROM LAB2
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
