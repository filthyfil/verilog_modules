`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Mandelbrot Set Calculator (Centered & Scaled, Fixed-Point 4.12)
// Generates correct aspect ratio and smoother detail
//////////////////////////////////////////////////////////////////////////////////
module calc(
    input  wire clk,
    input  wire rst,
    input  wire start,              // Start calculation
    input  wire [9:0] pixel_x,      // 0-639 (assuming 640 width)
    input  wire [9:0] pixel_y,      // 0-479 (assuming 480 height)
    output reg  [7:0] val,          // Iteration count output
    output reg  done                // Calculation complete flag
    );

    //=========================================================================
    // Parameters
    //=========================================================================
    localparam SCREEN_WIDTH  = 640;
    localparam SCREEN_HEIGHT = 480;
    localparam MAX_ITER      = 255;

    // Fixed-point 4.12 (multiply by 4096)
    // Centered at (-0.5, 0), covers -1.5 → +0.5 (X) and -0.75 → +0.75 (Y)
    localparam signed [15:0] X_MIN = -16'sd6144;   // -1.5 * 4096
    localparam signed [15:0] X_MAX =  16'sd2048;   // +0.5 * 4096
    localparam signed [15:0] Y_MIN = -16'sd3072;   // -0.75 * 4096
    localparam signed [15:0] Y_MAX =  16'sd3072;   // +0.75 * 4096

    localparam signed [15:0] X_RANGE = X_MAX - X_MIN;  // 8192 (≈ 2.0)
    localparam signed [15:0] Y_RANGE = Y_MAX - Y_MIN;  // 6144 (≈ 1.5)

    // Escape radius squared = 4.0 → 4 * 2^12 = 16384
    localparam signed [31:0] ESCAPE_RADIUS_SQ = 32'd16384;

    //=========================================================================
    // Internal registers
    //=========================================================================
    localparam IDLE      = 2'd0;
    localparam INIT      = 2'd1;
    localparam ITERATE   = 2'd2;
    localparam COMPLETE  = 2'd3;

    reg [1:0] state;

    reg signed [15:0] x0, y0;      // Complex constant (mapped from pixel)
    reg signed [15:0] x, y;        // Current iteration values
    reg signed [31:0] x_sq, y_sq;  // Squares (Q8.24 intermediates)
    reg signed [31:0] x_next, y_next;
    reg [7:0] iteration;

    //=========================================================================
    // Mandelbrot Iteration FSM
    //=========================================================================
    always @(posedge clk) begin
        if (rst) begin
            state     <= IDLE;
            val       <= 8'd0;
            done      <= 1'b0;
            iteration <= 8'd0;
            x <= 0; y <= 0;
            x_sq <= 0; y_sq <= 0;
        end else begin
            case (state)
                //-----------------------------------------------------------------
                IDLE: begin
                    done <= 1'b0;
                    if (start)
                        state <= INIT;
                end

                //-----------------------------------------------------------------
                INIT: begin
                    // Map pixel coordinates to complex plane (Q4.12)
                    // Use fixed-point scaling for smoother detail
                    x0 <= X_MIN + ((X_RANGE * $signed({6'b0, pixel_x})) / SCREEN_WIDTH);
                    y0 <= Y_MIN + ((Y_RANGE * $signed({6'b0, pixel_y})) / SCREEN_HEIGHT);

                    x <= 0;
                    y <= 0;
                    iteration <= 0;
                    state <= ITERATE;
                end

                //-----------------------------------------------------------------
                ITERATE: begin
                    // Compute squares
                    x_sq <= ($signed(x) * $signed(x)) >>> 12;
                    y_sq <= ($signed(y) * $signed(y)) >>> 12;

                    // Escape or iteration limit
                    if (x_sq + y_sq > ESCAPE_RADIUS_SQ || iteration >= MAX_ITER) begin
                        val <= iteration;
                        state <= COMPLETE;
                    end else begin
                        // Mandelbrot iteration: z = z^2 + c
                        x_next <= x_sq - y_sq + $signed(x0);
                        y_next <= ((($signed(x) * $signed(y)) >>> 11) + $signed(y0));
                        x <= x_next[15:0];
                        y <= y_next[15:0];
                        iteration <= iteration + 1'b1;
                    end
                end

                //-----------------------------------------------------------------
                COMPLETE: begin
                    done  <= 1'b1;
                    state <= IDLE;
                end

                //-----------------------------------------------------------------
                default: state <= IDLE;
            endcase
        end
    end

endmodule
