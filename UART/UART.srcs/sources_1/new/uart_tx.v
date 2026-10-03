`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2025 04:11:15 AM
// Design Name: 
// Module Name: uart_tx
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


module uart_tx
    #(
    parameter DBIT = 8, // data bits
    SB_TICK = 16, // ticks for stop bits
    parameter [1:0] PARITY = 2'b00 // 00=none, 01=even, 10=odd
    )(
    // I/O
    input wire clk, reset,
    input wire tx_start, s_tick,
    input wire [7:0] din,
    output reg tx_done_tick,
    output wire tx
    );

    // symbolic state declaration
    localparam [2:0]
        idle = 3'b000,
        start = 3'b001, 
        data = 3'b010,
        parity = 3'b011,
        stop = 3'b100;

    // signal declaration
    reg [2:0] state_reg, state_next; // FSM control
    reg [3:0] s_reg, s_next; // sample register
    reg [2:0] n_reg, n_next;  // n-th bit register
    reg [DBIT-1:0] b_reg, b_next; // data bit register
    reg tx_reg, tx_next;
    reg tx_parity_bit, tx_parity_bit_next;

    // body
    // FSMD state and data registers
    always @(posedge clk, posedge reset)
        if (reset) 
            begin
                state_reg <= idle;
                s_reg <= 0;
                n_reg <= 0;
                b_reg <= 0;
                tx_reg <= 1'b1;
                tx_parity_bit <= 0;
            end
        else
            begin
                state_reg <= state_next;
                s_reg <= s_next;
                n_reg <= n_next;
                b_reg <= b_next;
                tx_reg <= tx_next; 
                tx_parity_bit <= tx_parity_bit_next;
            end

    // FSMD next-state logic and functional units
    always @*
        begin
            state_next = state_reg;
            tx_done_tick = 1'b0;
            s_next = s_reg;
            n_next = n_reg;
            b_next = b_reg;
            tx_next = tx_reg;
            tx_parity_bit_next = tx_parity_bit;
            case (state_reg)
                idle:
                    begin
                        tx_next = 1'b1;
                        if (tx_start)
                            begin
                                state_next = start;
                                s_next = 0;
                                b_next = din;
                                case (PARITY)
                                    2'b01: tx_parity_bit_next = ~(^din); // even
                                    2'b10: tx_parity_bit_next = (^din); // odd
                                    default: tx_parity_bit_next = 1'b1;  // unused (no parity)
                                endcase                 
                            end
                    end
                start:
                    begin
                        tx_next = 1'b0;
                        if (s_tick)
                            if (s_reg == 15)
                                begin
                                    state_next = data;
                                    s_next = 0;
                                    n_next = 0;
                                end
                            else 
                                s_next = s_reg + 1;
                    end
                data:
                    begin
                        tx_next = b_reg[0];
                        if (s_tick)
                            if (s_reg == 15)
                                begin
                                    s_next = 0;
                                    b_next = b_reg >> 1;
                                    if (n_reg == (DBIT-1))
                                        // is parity enabled?
                                        if (PARITY != 2'b00)
                                            state_next = parity;
                                        else
                                            state_next = stop;
                                    else
                                        n_next = n_reg + 1;
                                end
                            else
                                s_next = s_reg + 1;
                    end
                parity:
                    begin
                        tx_next = tx_parity_bit;
                        if (s_tick)
                            if (s_reg == 15)
                                begin
                                    s_next = 0;
                                    state_next = stop;
                                end                 
                            else
                                s_next = s_reg + 1;                         
                    end
                stop:
                    begin
                        tx_next = 1'b1;
                        if (s_tick)
                            if (s_reg == (SB_TICK-1))
                                begin
                                    state_next = idle;
                                    tx_done_tick = 1'b1;
                                end
                            else
                                s_next = s_reg + 1;
                    end
            endcase
        end            
                
        // output
        assign tx = tx_reg;

endmodule
