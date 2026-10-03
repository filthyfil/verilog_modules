`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2025 02:49:35 PM
// Design Name: 
// Module Name: 
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

// computes grayscale = iteration count (0 if reached ITER_MAX => "inside").

`default_nettype none

module mandelbrot_pixel #(
    parameter integer FP_WIDTH = 25,   // total fixed-point bits
    parameter integer FP_INT   = 4,    // integer bits (Q format = FP_INT.FP_FRAC)
    parameter integer ITER_MAX = 255   // 8 bits
)(
    input  wire                         clk,
    input  wire                         rst,       // async reset, active high
    input  wire                         start,     // pulse/high to begin for current (re,im)
    input  wire signed [FP_WIDTH-1:0]   re,        // c.real (x)
    input  wire signed [FP_WIDTH-1:0]   im,        // c.imag (y)
    output reg        [7:0]             gray,      // grayscale
    output reg                          calculating,
    output reg                          done       // 1-cycle pulse when finished
);
    // Fixed-point format helpers
    localparam integer FP_FRAC  = FP_WIDTH - FP_INT;
    localparam signed [FP_WIDTH-1:0] ESCAPE4 = (4 << FP_FRAC); // 4.0 in Q format

    // State machine
    localparam [1:0] S_IDLE = 2'd0,
                     S_RUN  = 2'd1,
                     S_DONE = 2'd2;
    reg [1:0] state;

    // z = zx + j*zy
    reg  signed [FP_WIDTH-1:0] zx, zy;
    reg  [7:0]                 iter;

    // Intermediate math
    reg  signed [FP_WIDTH-1:0] zx2, zy2, mag2, two_zx_zy;

    // Fixed-point multiply: (a*b) >> FP_FRAC, return FP_WIDTH signed
    function [FP_WIDTH-1:0] qmul;
        input signed [FP_WIDTH-1:0] a;
        input signed [FP_WIDTH-1:0] b;
        reg   signed [(2*FP_WIDTH)-1:0] p;
    begin
        p    = a * b;
        qmul = p >>> FP_FRAC; // arithmetic shift preserves sign
    end
    endfunction

    // Combinational math for current zx,zy
    always @* begin
        zx2       = qmul(zx, zx);
        zy2       = qmul(zy, zy);
        mag2      = zx2 + zy2;
        two_zx_zy = qmul(zx <<< 1, zy); // 2*zx*zy
    end

    // Sequential control
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= S_IDLE;
            zx           <= {FP_WIDTH{1'b0}};
            zy           <= {FP_WIDTH{1'b0}};
            iter         <= 8'd0;
            gray         <= 8'd0;
            calculating  <= 1'b0;
            done         <= 1'b0;
        end else begin
            done <= 1'b0; // default (pulse)

            case (state)
                S_IDLE: begin
                    calculating <= 1'b0;
                    if (start) begin
                        zx          <= {FP_WIDTH{1'b0}}; // z0 = 0
                        zy          <= {FP_WIDTH{1'b0}};
                        iter        <= 8'd0;
                        calculating <= 1'b1;
                        state       <= S_RUN;
                    end
                end

                S_RUN: begin
                    // escape if |z|^2 > 4, or stop at ITER_MAX
                    if (mag2 > ESCAPE4 || iter == ITER_MAX) begin
                        gray   <= (iter == ITER_MAX) ? 8'd0 : iter;
                        done   <= 1'b1;
                        state  <= S_DONE;
                    end else begin
                        // z_{n+1} = z_n^2 + c
                        zx   <= zx2 - zy2 + re;
                        zy   <= two_zx_zy + im;
                        iter <= iter + 8'd1;
                    end
                end

                S_DONE: begin
                    calculating <= 1'b0;
                    state <= S_IDLE;
                end

                default: state <= S_IDLE;
            endcase
        end
    end
endmodule

`default_nettype wire
