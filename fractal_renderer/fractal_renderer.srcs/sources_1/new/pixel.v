`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 07:42:59 PM
// Design Name: 
// Module Name: pixel
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 07:42:59 PM
// Design Name: 
// Module Name: pixel
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

module pixel #(
    parameter integer FP_WIDTH = 25, // total fixed-point bits
    // (Q format = FP_INT.FP_FRAC)
    parameter integer FP_INT = 4, // integer bits 
    parameter integer FP_FRAC = 21,
    
    // max number of iterations
    parameter integer MAX_ITERATION = 255 // for 8 bits
    )(
    input wire clk,
    input wire reset,
    input wire start, // high to begin for current (re,im)
    input wire signed [FP_WIDTH-1:0] re, // real part
    input wire signed [FP_WIDTH-1:0] im, // complex part
    output reg [7:0] value, // grayscale
    output reg calculating,
    output reg finished // high when finished
    );

    // multiply function for Q
    function [FP_WIDTH-1:0] qmul;
        input signed [FP_WIDTH-1:0] a;
        input signed [FP_WIDTH-1:0] b;
        reg signed [(2*FP_WIDTH)-1:0] p;
        begin
            p = a * b;
            qmul = p >>> FP_FRAC; // arithmetic shift, discard lower bits
        end
    endfunction

    // math
    localparam signed [FP_WIDTH-1:0] FOUR = (4 << FP_FRAC); // 4.0 in Q format

    // symbolic state declaration
    reg [1:0] state_reg, state_next;
    localparam [1:0]
        idle      = 2'b00,
        calculate = 2'b01,
        done      = 2'b10;

    // math registers
    reg signed [FP_WIDTH-1:0] x_reg, x_next;
    reg signed [FP_WIDTH-1:0] y_reg, y_next;
    reg [9:0] iteration_reg, iteration_next;

    // intermediate symbols
    wire signed [FP_WIDTH-1:0] x2 = qmul(x_reg, x_reg);
    wire signed [FP_WIDTH-1:0] y2 = qmul(y_reg, y_reg);
    wire signed [FP_WIDTH-1:0] magnitude2 = x2 + y2;    
    wire signed [FP_WIDTH-1:0] two_x_y = qmul((x_reg + x_reg), y_reg);

    // next-value registers
    reg calculating_next;
    reg finished_next;
    reg [7:0] value_next;
    
    // state and registers
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= idle;
            x_reg <= {FP_WIDTH{1'b0}};
            y_reg <= {FP_WIDTH{1'b0}};
            iteration_reg <= 10'd0;
            value <= 8'd0;
            calculating <= 1'b0;
            finished <= 1'b0;
        end else begin
            state_reg <= state_next;
            x_reg <= x_next;
            y_reg <= y_next;
            iteration_reg <= iteration_next;
            value <= value_next;
            calculating <= calculating_next;
            finished <= finished_next;
        end
    end
    
    // next-state logic
    always @* begin
        // defaults
        state_next = state_reg;
        x_next = x_reg;
        y_next = y_reg;
        iteration_next = iteration_reg;
        calculating_next = calculating;
        finished_next = 1'b0; // high when finished (1-cycle)
        value_next = value;

        case (state_reg)

            idle: begin
                calculating_next = 1'b0; 
                if (start) begin
                    // upon expansion, it turns out this update is appropriate
                    x_next = {FP_WIDTH{1'b0}};
                    y_next = {FP_WIDTH{1'b0}};
                    iteration_next = 8'd0;
                    calculating_next = 1'b1;
                    state_next = calculate;
                end
            end

            calculate: begin
                // escape if |z|^2 > 4 or if the max number of iterations is reached
                if (magnitude2 > FOUR || iteration_reg == MAX_ITERATION) begin
                    value_next = (iteration_reg == MAX_ITERATION) ? 8'd0 : iteration_reg;
                    finished_next = 1'b1;
                    calculating_next = 1'b0;
                    state_next = done;
                end else begin
                    // z_{n+1} = z_n^2 + c
                    // c = re + im
                    // upon expansion, it turns out this update is appropriate
                    x_next = x2 - y2 + re;
                    y_next = two_x_y + im;
                    iteration_next = iteration_reg + 10'd1;
                end
            end

            done: begin
                calculating_next = 1'b0;
                finished_next = 1'b1;
                state_next = idle;
            end

            default: state_next = idle;
        endcase
    end

endmodule
