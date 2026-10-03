`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2025 11:39:42 PM
// Design Name: 
// Module Name: debounce_edge
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


module debounce_edge #(
    parameter N = 20     // counter bits → 10ms at 100MHz
)(
    input  wire clk,
    input  wire reset,
    input  wire sw,          // raw switch
    output reg  db_level,    // stable debounced level
    output wire db_tick      // 1-clock pulse on rising edge
);

    //------------------------------------------------------
    // 10-ms tick generator (same behavior as your version)
    //------------------------------------------------------
    reg [N-1:0] q_reg;
    wire [N-1:0] q_next = q_reg + 1;
    wire m_tick = (q_reg == 0);

    always @(posedge clk, posedge reset)
        if (reset)
            q_reg <= 0;
        else
            q_reg <= q_next;

    //------------------------------------------------------
    // Debounce FSM (cleaned-up version)
    //------------------------------------------------------
    localparam [2:0]
        S_ZERO   = 3'b000,   // stable 0
        S_ONE    = 3'b001,   // stable 1
        W0_1     = 3'b010,
        W0_2     = 3'b011,
        W0_3     = 3'b100;

    reg [2:0] state_reg, state_next;

    // State register
    always @(posedge clk, posedge reset) begin
        if (reset)
            state_reg <= S_ZERO;
        else
            state_reg <= state_next;
    end

    // Next-state logic + debounced output
    always @* begin
        state_next = state_reg;
        db_level   = 1'b0;

        case (state_reg)
            //--------------------------------------------------
            S_ZERO: begin
                db_level = 1'b0;
                if (sw)
                    state_next = S_ONE;
            end

            //--------------------------------------------------
            S_ONE: begin
                db_level = 1'b1;
                if (~sw)
                    state_next = W0_1;
            end

            //--------------------------------------------------
            W0_1: begin
                db_level = 1'b1;
                if (sw)
                    state_next = S_ONE;
                else if (m_tick)
                    state_next = W0_2;
            end

            W0_2: begin
                db_level = 1'b1;
                if (sw)
                    state_next = S_ONE;
                else if (m_tick)
                    state_next = W0_3;
            end

            //--------------------------------------------------
            W0_3: begin
                db_level = 1'b1;
                if (sw)
                    state_next = S_ONE;
                else if (m_tick)
                    state_next = S_ZERO;
            end

            default: state_next = S_ZERO;
        endcase
    end

    //------------------------------------------------------
    // Rising edge detector (built-in)
    //------------------------------------------------------
    reg db_level_d;

    always @(posedge clk, posedge reset)
        if (reset)
            db_level_d <= 1'b0;
        else
            db_level_d <= db_level;

    assign db_tick = db_level & ~db_level_d;

endmodule

