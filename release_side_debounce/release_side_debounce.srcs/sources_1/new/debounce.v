`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2025 01:56:37 PM
// Design Name: 
// Module Name: debounce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debounce (
	input wire clk, reset,
	input wire sw,
	output wire sw_raw,
	output reg db
	);
	
	// FSM state declaration
	localparam [2:0]
		zero = 3'b000,
		wait1_1 = 3'b001,
		wait1_2 = 3'b010,
		wait1_3 = 3'b011,
		one = 3'b100,
		wait0_1 = 3'b101,
		wait0_2 = 3'b110,
		wait0_3 = 3'b111;
		
	// number of bits for the counter
	localparam N = 20;
	
	// signal declaration
	reg [N-1:0] q_reg;
	wire [N-1:0] q_next;
	wire m_tick;
	reg [2:0] state_reg, state_next;
	assign sw_raw = sw;
	
	// body
	
	//===================================================
	// counter for 10 ms tick, checks for stabilization
	//===================================================
	// increment counter on each clock cycle, on overflow 
	// to zero, generate the tick.
	always @(posedge clk)
		q_reg <= q_next;
	assign q_next = q_reg + 1;
	assign m_tick = (q_reg == 0) ? 1'b1 : 1'b0;
	
	//===================================================
	// debouncing FSM implementation
	//===================================================
	// state register
	always @(posedge clk, posedge reset)
		if (reset)
			state_reg <= zero;
		else
			state_reg <= state_next;
			
	// next state logic and output logic
	always @*
		begin
			state_next = state_reg;
			db = 1'b0;
			case (state_reg)
			
			zero:
				begin
					if (sw)
						state_next = one;
				end
			one:
				begin
					db = 1'b1;
					if (~sw)
						state_next = wait0_1;
				end
			wait0_1:
				begin
				    db = 1'b1;
					if (sw)
						state_next = one;
					else
						if (m_tick)
							state_next = wait0_2;
				end
			wait0_2:
				begin
				    db = 1'b1;
					if (sw)
						state_next = one;
					else
						if (m_tick)
							state_next = wait0_3;
				end
			wait0_3:
				begin
				    db = 1'b1;
					if (sw)
						state_next = one;
					else
						if (m_tick)
							state_next = zero;
				end
			default: state_next = zero;
		endcase
	end
endmodule
	
	
	