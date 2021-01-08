//Sw[7:0] data_in

//KEY[0] synchronous reset when pressed
//KEY[1] go signal

//LEDR displays result
//HEX0 & HEX1 also displays result

module fpga_top(SW, KEY, CLOCK_50, LEDR, HEX0, HEX1);
    input [9:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1;

    wire resetn;
    wire go;

    wire [8:0] data_result;
    assign go = ~KEY[1];
    assign resetn = KEY[0];

    part2 u0(
        .clk(CLOCK_50),
        .resetn(resetn),
        .go(go),
        .data_in(SW[8:0]),
        .data_result(data_result)
    );
      
    assign LEDR[9:0] = {2'b00, data_result};

    hex_decoder H0(
        .hex_digit(data_result[3:0]), 
        .segments(HEX0)
        );
        
    hex_decoder H1(
        .hex_digit(data_result[7:4]), 
        .segments(HEX1)
        );

endmodule

module part2(
    input clk,
    input resetn,
    input go,
    input [8:0] data_in,
    output [8:0] data_result
    );

    // lots of wires to connect our datapath and controlDetermine a sequence of steps similar to the datapath example shown in lecture that controls your
	//datapath to perform the required computation. You should draw a table that shows the state of
	//the Registers and control signals for each cycle of your computation. Include this table in your
	//prelab
    wire ld_divisor, ld_dividend, ld_a, ld_r, ld_q;
	 wire  alu_select_a, alu_select_b;
    wire ld_alu_out;
    wire [1:0]alu_op;

    control C0(
        .clk(clk),
        .resetn(resetn),
        
        .go(go),
         
        .ld_divisor(ld_divisor),
        .ld_dividend(ld_dividend),
		  .ld_a(ld_a),
		  .ld_r(ld_r),
		  .ld_q(ld_q),
		  
		  .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),
		  .ld_alu_out(ld_alu_out),
        
		 
        .alu_op(alu_op)
    );

    datapath D0(
        .clk(clk),
        .resetn(resetn),

        .ld_alu_out(ld_alu_out), 
        .ld_divisor(ld_divisor),
        .ld_dividend(ld_dividend), 
		  .ld_a(ld_a),
		  .ld_r(ld_r),
		  .ld_q(ld_q),

		  .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),
        .alu_op(alu_op),

        .data_in(data_in),
        .data_result(data_result)
    );
                
 endmodule        
                

module control(
    input clk,
    input resetn,
    input go,

    output reg  ld_divisor, ld_dividend, ld_a, ld_r, ld_q,
    output reg  ld_alu_out,
	 output reg  alu_select_a, alu_select_b,
    output reg [1:0]alu_op
    );

    reg [4:0] current_state, next_state; 
    
    localparam  S_LOAD_Divisor  			= 5'd0,
                S_LOAD_Divisor_WAIT    = 5'd1,
                S_LOAD_Dividend        = 5'd2,
                S_LOAD_Dividend_WAIT   = 5'd3,
                S_CYCLE_0       			= 5'd4,
                S_CYCLE_1      			= 5'd5,
					 S_CYCLE_2       			= 5'd6,
                S_CYCLE_3      			= 5'd7,
					 S_CYCLE_4       			= 5'd8,
                S_CYCLE_5      			= 5'd9,
					 S_CYCLE_6       			= 5'd10,
                S_CYCLE_7      			= 5'd11,
					 S_CYCLE_8       			= 5'd12,
                S_CYCLE_9      			= 5'd13,
					 S_CYCLE_10       		= 5'd14,
                S_CYCLE_11      			= 5'd15,
					 S_CYCLE_12       		= 5'd16,
                S_CYCLE_13      			= 5'd17,
					 S_CYCLE_14       		= 5'd18,
                S_CYCLE_15      			= 5'd19;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_LOAD_Divisor: next_state = go ? S_LOAD_Divisor_WAIT : S_LOAD_Divisor; // Loop in current state until value is input
                S_LOAD_Divisor_WAIT: next_state = go ? S_LOAD_Divisor_WAIT : S_LOAD_Dividend; // Loop in current state until go signal goes low
                S_LOAD_Dividend: next_state = go ? S_LOAD_Dividend_WAIT : S_LOAD_Dividend; // Loop in current state until value is input
                S_LOAD_Dividend_WAIT: next_state = go ? S_LOAD_Dividend_WAIT : S_CYCLE_0; // Loop in current state until go signal goes low
                S_CYCLE_0: next_state = S_CYCLE_1;
                S_CYCLE_1: next_state = S_CYCLE_2;
					 S_CYCLE_2: next_state = S_CYCLE_3;
                S_CYCLE_3: next_state = S_CYCLE_4;
					 S_CYCLE_4: next_state = S_CYCLE_5;
                S_CYCLE_5: next_state = S_CYCLE_6;
					 S_CYCLE_6: next_state = S_CYCLE_7;
                S_CYCLE_7: next_state = S_CYCLE_8;
					 S_CYCLE_8: next_state = S_CYCLE_9;
                S_CYCLE_9: next_state = S_CYCLE_10;
					 S_CYCLE_10: next_state = S_CYCLE_11;
                S_CYCLE_11: next_state = S_CYCLE_12;
					 S_CYCLE_12: next_state = S_CYCLE_13;
                S_CYCLE_13: next_state = S_CYCLE_14;
					 S_CYCLE_14: next_state = S_CYCLE_15;
                S_CYCLE_15: next_state = S_LOAD_Divisor;
            default:     next_state = S_LOAD_Divisor;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_alu_out = 1'b0;
        ld_divisor = 1'b0;
        ld_dividend = 1'b0;
		  ld_a = 1'b0;
		  ld_r = 1'b0;
		  ld_q = 1'b0;
		  alu_select_a = 1'b0;
        alu_select_b = 1'b0;
        alu_op       = 2'b00;

        case (current_state)
            S_LOAD_Divisor: begin
                ld_divisor = 1'b1;
                end
            S_LOAD_Dividend: begin
                ld_dividend = 1'b1;
                end
					 
            S_CYCLE_0: begin // leftshift the values	
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1;
					 alu_select_a = 1'b1; // Dividend
					 alu_select_b = 1'b0; // a
                alu_op = 2'b00; // Do shift operation
            end
            S_CYCLE_1: begin // subtraction + change
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1; ld_q = 1'b1;
					 alu_select_a = 1'b0; // Divisor
					 alu_select_b = 1'b0; // a
                alu_op = 2'b01; // Do other operation
            end
				S_CYCLE_2: begin // leftshift the values	
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1;
					 alu_select_a = 1'b0; // Divisor
					 alu_select_b = 1'b0; // a
                alu_op = 2'b10; // Do shift operation
            end
            S_CYCLE_3: begin // subtraction + change
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1;
					 alu_select_a = 1'b1; // Dividend
					 alu_select_b = 1'b1; // q0
                alu_op = 2'b11; // Do other operation
            end
				
				S_CYCLE_4: begin // leftshift the values	
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1;
					 alu_select_a = 1'b1; // Dividend
					 alu_select_b = 1'b0; // a
                alu_op = 2'b00; // Do shift operation
            end
            S_CYCLE_5: begin // subtraction + change
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1; ld_q = 1'b1;
					 alu_select_a = 1'b0; // Divisor
					 alu_select_b = 1'b0; // a
                alu_op = 2'b01; // Do other operation
            end
				S_CYCLE_6: begin // leftshift the values	
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1; 
					 alu_select_a = 1'b0; // Divisor
					 alu_select_b = 1'b0; // a
                alu_op = 2'b10; // Do shift operation
            end
            S_CYCLE_7: begin // subtraction + change
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1; 
					 alu_select_a = 1'b1; // Dividend
					 alu_select_b = 1'b1; // q0
                alu_op = 2'b11; // Do other operation
            end
				
				S_CYCLE_8: begin // leftshift the values	
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1;
					 alu_select_a = 1'b1; // Dividend
					 alu_select_b = 1'b0; // a
                alu_op = 2'b00; // Do shift operation
            end
            S_CYCLE_9: begin // subtraction + change
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1; ld_q = 1'b1;
					 alu_select_a = 1'b0; // Divisor
					 alu_select_b = 1'b0; // a
                alu_op = 2'b01; // Do other operation
            end
				S_CYCLE_10: begin // leftshift the values	
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1;
					 alu_select_a = 1'b0; // Divisor
					 alu_select_b = 1'b0; // a
                alu_op = 2'b10; // Do shift operation
            end
            S_CYCLE_11: begin // subtraction + change
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1;
					 alu_select_a = 1'b1; // Dividend
					 alu_select_b = 1'b1; // q0
                alu_op = 2'b11; // Do other operation
            end
				
				S_CYCLE_12: begin // leftshift the values	
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1;
					 alu_select_a = 1'b1; // Dividend
					 alu_select_b = 1'b0; // a
                alu_op = 2'b00; // Do shift operation
            end
            S_CYCLE_13: begin // subtraction + change
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1; ld_q = 1'b1;
					 alu_select_a = 1'b0; // Divisor
					 alu_select_b = 1'b0; // a
                alu_op = 2'b01; // Do other operation
            end
				S_CYCLE_14: begin // leftshift the values	
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1;
					 alu_select_a = 1'b0; // Divisor
					 alu_select_b = 1'b0; // a
                alu_op = 2'b10; // Do shift operation
            end
            S_CYCLE_15: begin // subtraction + change
                ld_alu_out = 1'b1; ld_a = 1'b1; ld_dividend = 1'b1; ld_r = 1'b1;
					 alu_select_a = 1'b1; // Dividend
					 alu_select_b = 1'b1; // q0
                alu_op = 2'b11; // Do other operation
            end
				
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_Divisor;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath(
    input clk,
    input resetn,
    input [8:0] data_in,
    input ld_alu_out, 
    input ld_divisor, ld_dividend, ld_a,
    input ld_r, ld_q,
	 input alu_select_a, alu_select_b,
    input [1:0] alu_op, 
    output reg [8:0] data_result
    );
    
    // input registers
    reg [3:0] divisor; // can do if subtract == <0 then change the index value or something
	 reg [3:0] dividend;
	 reg [3:0] a;
	 reg q0;
    // output of the alu
    reg [8:0] alu_out;
    // alu input muxes
    reg [3:0] alu_a, alu_b;
	 
    // Registers a, b, c, x with respective input logic
    always @ (posedge clk) begin
        if (!resetn) begin
            divisor <= 4'd0; 
            dividend <= 4'd0;
				a <= 4'd0;
				q0 <= 1'b0;
        end
        else begin
            if (ld_divisor)
                divisor <= data_in; // load alu_out if load_alu_out signal is high, otherwise load from data_in
            if (ld_dividend)
                dividend <= ld_alu_out ? alu_out[3:0] : data_in[3:0]; // load alu_out if load_alu_out signal is high, otherwise load from data_in
				if (ld_a)
					a <= ld_alu_out ? alu_out[7:4] : data_in[7:4];
				if (ld_q)
					q0 <= ld_alu_out ? ~alu_out[8] : ~data_in[8];
        end
    end
 
    // Output result register
    always @ (posedge clk) begin
        if (!resetn) begin
            data_result <= 9'd0; 
        end
        else 
            if(ld_r)
                data_result <= alu_out;
    end
	 
	     // The ALU input multiplexers
    always @(*)
    begin
        case (alu_select_a)
            1'b0:
                alu_a = divisor;
            1'b1:
                alu_a = dividend;
            default: alu_a = 4'd0;
        endcase

        case (alu_select_b)
            1'b0:
                alu_b = a;
            1'b1:
                alu_b = {3'b0, q0};
            default: alu_b = 4'd0;
        endcase
    end

    // The ALU 
    always @(*)
    begin : ALU
        // alu
        case (alu_op)
            0: begin
                   alu_out = {alu_b, alu_a, 1'b0}; //performs left shift
               end
            1: begin
					if (alu_a > alu_b) begin
						alu_out = {1'b1, alu_b - alu_a, alu_out[3:0]};
						end
					else begin
						alu_out = {1'b0, alu_b - alu_a, alu_out[3:0]};
						end
					end
				2: begin
					if (alu_out[8] == 1)
						alu_out = {1'b0, alu_b + alu_a, alu_out[3:0]};
					else
						alu_out = alu_out[8:0];
					end
				3: begin
						alu_out = {1'b0, alu_out[7:4], alu_a[3:1], alu_b[0]};
               end
            default: alu_out = 9'd0;
        endcase
    end
    
endmodule


module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule