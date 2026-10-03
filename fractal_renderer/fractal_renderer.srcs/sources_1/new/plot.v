`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2025 03:12:37 PM
// Design Name: 
// Module Name: plot
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


module plot(
    input wire clk, // 100 MHz
    input wire reset,     
    output wire hsync,
    output wire vsync,
    output wire [3:0] vga_r,
    output wire [3:0] vga_g,
    output wire [3:0] vga_b
    );
    
    // fixed point parameters
    localparam FP_WIDTH = 25;
    localparam FP_INT = 4;
    localparam FP_FRAC_WIDTH = 21;
    
    // max number of iterations
    localparam ITER_MAX = 255;
    
    // starting coordinates (width must match FP_WIDTH)
    localparam X_START = 25'b1100_1000_0000_0000_0000_0000_0;  // starting left: -3.5
    localparam Y_START = 25'b1110_1000_0000_0000_0000_0000_0;  // starting top:  -1.5i
    localparam STEP    = 25'b0000_0000_0100_0000_0000_0000_0;  // step: 1/64 (320x180)
    
    // state machine (5)
    reg [2:0] state;
    reg [2:0] state_next;

    // idle, write (pixel), jump_x, jump_y, done
    localparam [2:0]
        idle = 3'b000,
        write = 3'b001,
        jmp_x = 3'b010,
        jmp_y = 3'b011,
        done = 3'b100;
    
    always @(posedge clk, posedge reset)
        if (reset) begin
            state_reg <= idle;
            write_counter <= 0
        end
        else begin
            state_reg <= state_next;
        end

    reg signed [FP_WIDTH-1:0] re; // real part 
    reg signed [FP_WIDTH-1:0] im; // complex part
    reg signed [7:0] d_reg; // value calc'd

    reg [7:0] write_counter = 319; // from 320x180

    always @* begin
        case (state)
        idle: begin
            state <= WRITE;
        end
        write: begin
            // for this pixel, call the mandelbrot pixel module to compute the value of this pixel
            // check counter, 
            // if < 319, goto jmp_x
            // if = 319, goto jmp_y
        end

        jmp_x:
            // step the pixel
            // goto done
        jmp_y:
            // when we hit the 319-th pixel, reset the real part, step the complex part
            // goto done
        done:
            // assign the value (in greyscale) to a pixel in RAM
        endcase
    end
    
    wire [9:0] x, y;
    wire p_tick;
    wire video_on;

    reg                      mb_start;
    wire                     mb_done;
    wire                     mb_calc;
    reg  signed [FP_WIDTH-1:0] mb_re, mb_im;
    wire [7:0]               mb_gray;

    memory #(
        .ADDR_WIDTH(ADDR_WIDTH), // 16 for 320x180
        .DATA_WIDTH(DATA_WIDTH) // 8
    ) memory_unit (
        .clk(clk),
        .we(we), // do we want to write?
        .addr_a(compute_addr),
        .addr_b(display_addr),
        .din_a(compute_port),
        .dout_b(display_port)
    )

    mandelbrot_pixel #(
        .FP_WIDTH (FP_WIDTH),
        .FP_INT   (FP_INT),
        .ITER_MAX (ITER_MAX)
    ) mbpix_i (
        .clk          (clk),
        .rst          (reset),
        .start        (mb_start),
        .re           (mb_re),
        .im           (mb_im),
        .gray         (mb_gray),
        .calculating  (mb_calc),
        .done         (mb_done)
    );

    vga_sync vga_sync_i (
        .clk       (clk),
        .reset     (reset),
        .hsync     (hsync),
        .vsync     (vsync),
        .video_on  (video_on),
        .p_tick    (p_tick),
        .pixel_x   (x),
        .pixel_y   (y)
    );
    
    
endmodule
