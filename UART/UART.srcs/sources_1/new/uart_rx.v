`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2025 11:29:49 AM
// Design Name: 
// Module Name: uart_rx
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


module uart_rx 
    #(
    parameter DBIT = 8, // data bits
    SB_TICK = 16, // stop bit ticks
    parameter [1:0] PARITY = 2'b00 // 00=none, 01=even, 10=odd
    )(
    // I/O
    input wire clk, reset, 
    input wire rx, s_tick,
    output reg rx_done_tick,
    output wire [DBIT-1:0] dout,
    output reg parity_err,
    output reg frame_err
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
    reg [2:0] n_reg, n_next; // n-th bit register
    reg [DBIT-1:0] b_reg, b_next; // data bit register
    reg parity_err_next, frame_err_next;
    reg rx_parity_bit;

    // body
    // FSMD state and data registers
    always @(posedge clk, posedge reset)
        if (reset)
            begin
                state_reg <= idle;
                s_reg <= 0;
                n_reg <= 0;
                b_reg <= 0;
                parity_err <= 0;
                frame_err <= 0;
            end
        else
            begin
                state_reg <= state_next;
                s_reg <= s_next;
                n_reg <= n_next;
                b_reg <= b_next;
                parity_err <= parity_err_next;
                frame_err <= frame_err_next;
            end
            
    // FSMD next-state logic
    always @*
        begin
            state_next = state_reg;
            rx_done_tick = 1'b0;
            s_next = s_reg;
            n_next = n_reg;
            b_next = b_reg;
            parity_err_next = parity_err;
            frame_err_next = frame_err;
            case (state_reg)
                idle:
                    if (~rx)
                        begin
                            state_next = start;
                            s_next = 0;
                        end
                start:
                    if (s_tick)
                        if (s_reg == 7) 
                            begin
                                state_next = data;
                                s_next = 0;
                                n_next = 0;
                                
                            end
                        else
                            s_next = s_reg + 1;
                data:
                    if (s_tick)
                            if (s_reg == 15)
                                begin
                                    s_next = 0;
                                    b_next = {rx, b_reg[DBIT-1:1]}; 
                                    if (n_reg == (DBIT-1))
                                        if (PARITY != 2'b00)
                                            state_next = parity;
                                        else                                  
                                            state_next = stop;
                                    else
                                        n_next = n_reg + 1;
                                end
                            else s_next = s_reg + 1;
                parity:
                    if (s_tick) 
                        if (s_reg == 15)
                            begin
                                rx_parity_bit = rx;
                                case (PARITY)
                                    2'b01: parity_err_next = (rx_parity_bit != ~(^b_reg)); // even
                                    2'b10: parity_err_next = (rx_parity_bit != (^b_reg)); // odd
                                    default: parity_err_next = 1'b0; // no parity     
                                endcase
                                s_next = 0;
                                state_next = stop;
                            end
                        else 
                            s_next = s_reg + 1;
                stop:
                    if (s_tick)
                        if (s_reg == SB_TICK-1)
                            begin
                                state_next = idle;
                                rx_done_tick = 1'b1;
                                if (rx != 1'b1)
                                    frame_err_next = 1'b1;
                                else
                                    frame_err_next = 1'b0;
                            end
                        else 
                            s_next = s_reg + 1;
            endcase
        end

        // output
        assign dout = b_reg;

endmodule
