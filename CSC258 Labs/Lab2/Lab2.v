//SW[4:0] data inputs
//SW[9,8] select signal

//LEDR[0] output display

module Lab2(HEX0, SW);
    input [9:0] SW;
    //output [9:0] LEDR;
	 output [6:0] HEX0;
	 
    //mux4to1 u4(SW[0], SW[1], SW[2], SW[3], SW[8], SW[9], LEDR[0]);
	seven_seg_decoder u5(SW, HEX0);
endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;

endmodule

module mux4to1(a, b, c, d, r, s, out);
	input a, b, c, d, r, s;
	output out;
	wire connection1, connection2;
	mux2to1 u1(c, d, r, connection2);
	mux2to1 u0(a, b, r, connection1);
	mux2to1 u2(connection1, connection2, s, out);
endmodule

module seven_seg_decoder(S,HEX0);
	input [3:0]S;
	output [6:0]HEX0;
	
	assign HEX0[0] = (~S[3]&~S[2]&~S[1]&S[0])|(~S[3]&S[2]&~S[1]&~S[0])|(S[3]&S[2]&~S[1]&S[0])|(S[3]&~S[2]&S[1]&S[0]);
	assign HEX0[1] = (S[3]&S[2]&~S[1]&~S[0])|(~S[3]&S[2]&~S[1]&S[0])|(S[3]&S[1]&S[0])|(S[2]&S[1]&~S[0]);
	assign HEX0[2] = (~S[3]&~S[2]&S[1]&~S[0])|(S[3]&S[2]&S[1])|(S[3]&S[2]&~S[0]);
	assign HEX0[3] = (~S[3]&~S[2]&~S[1]&S[0])|(~S[3]&S[2]&~S[1]&~S[0])|(S[3]&~S[2]&S[1]&~S[0])|(S[2]&S[1]&S[0]);
	assign HEX0[4] = (~S[3]&S[0])|(~S[3]&S[2]&~S[1])|(~S[2]&~S[1]&S[0]);
	assign HEX0[5] = (~S[3]&~S[2]&S[0])|(~S[3]&~S[2]&S[1])|(~S[3]&S[1]&S[0])|(S[3]&S[2]&~S[1]&S[0]);
	assign HEX0[6] = (~S[3]&~S[2]&~S[1])|(~S[3]&S[2]&S[1]&S[0])|(S[3]&S[2]&~S[1]&~S[0]);
endmodule
