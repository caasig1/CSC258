module mux(SW, LEDR);
	input [9:0] SW;
	output [9:0] LEDR;
	
	rippleAdder4bit r0(
		.a(SW[3:0]),
		.b(SW[7:4]),
		.cin(SW[8]),
		.cout(LEDR[9]),
		.s(LEDR[3:0])
	);
endmodule

module rippleAdder4bit(a, b, cin, cout, s);
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

module fullAdder(one, two, cin, cout, s);
	input one, two, cin;
	output cout, s;
	
	assign s = ~cin & (one^two) | cin & ~(one ^ two);
	assign cout = cin & (one|two) | ~cin & (one&two);
endmodule
