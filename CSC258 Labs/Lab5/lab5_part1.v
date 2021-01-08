`timescale 1ns / 1ns
module eightbit(SW, KEY, HEX0, HEX1);
	input [1:0] SW;
	input [1:0] KEY;
	output [6:0] HEX0, HEX1;

	wire q0out, q1out,q2out,q3out,q4out,q5out,q6out,q7out;
	wire q1in, q2in, q3in, q4in, q5in, q6in, q7in;
	wire [3:0] first, second;
	
	tflip t0(SW[1], q0out, KEY[0], SW[0]);
	assign q1in = SW[1] & q0out;
	
	tflip t1(q1in, q1out, KEY[0], SW[0]);
	assign q2in = q1in & q1out;
	
	tflip t2(q2in, q2out, KEY[0], SW[0]);
	assign q3in = q2in & q2out;
	
	tflip t3(q3in, q3out, KEY[0], SW[0]);
	assign q4in = q3in & q3out;
	
	tflip t4(q4in, q4out, KEY[0], SW[0]);
	assign q5in = q4in & q4out;
	
	tflip t5(q5in, q5out, KEY[0], SW[0]);
	assign q6in = q5in & q5out;
	
	tflip t6(q6in, q6out, KEY[0], SW[0]);
	assign q7in = q6in & q6out;
	
	tflip t7(q7in, q7out, KEY[0], SW[0]);
	
	assign first = {{{q7out, q6out}, q5out}, q4out};
	assign second = {{{q3out, q2out}, q1out}, q0out};
	seven_seg s0(first, HEX0);
	seven_seg s1(second, HEX1);
endmodule

module tflip(T,Q,Clock,Clear);
	input T;
	output Q;
	input Clock;
	input Clear;
	
	reg Q;
	
	always @(posedge Clock, negedge Clear)
		begin
			if (Clear == 1'b0)
				Q <= 1'b0;
			else
				if (T == 1'b1)
					Q <= ~Q;
				else
					Q <= Q;
		end
endmodule

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
