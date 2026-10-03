`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2025 03:12:37 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Mandelbrot renderer with FSMD controller, dual-port memory, and VGA
// 
// Dependencies: vga_sync, pixel, memory
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Completed FSM and memory/VGA logic
// Revision 0.03 - Converted control/datapath to FSMD style
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
    input wire clk, // 100 MHz
    input wire reset,
    input wire up, down, left, right,
    input wire zoom_btn,
    output wire hsync,
    output wire vsync,
    output wire [3:0] vga_r,
    output wire [3:0] vga_g,
    output wire [3:0] vga_b
    );

    // fixed point parameters
    localparam FP_WIDTH = 64;
    localparam FP_INT   = 16;
    localparam FP_FRAC  = 48;
    
    // max number of iterations
    localparam MAX_ITERATION = 1000;
    
    // compute resolution
    localparam H_COMPUTE = 320;
    localparam V_COMPUTE = 240;
    
    // ---------------------------------------------------------
    // starting coordinates (width must match FP_WIDTH)
    // X_START: starting left:  -3.5
    // Y_START: starting top:   -1.5i
    // STEP:    step:           1/64
    // ---------------------------------------------------------
    // Q16.48 constants
    localparam signed [63:0] X_START = 64'hFFFC_8000_0000_0000; // -3.5
    localparam signed [63:0] Y_START = 64'hFFFE_8000_0000_0000; // -1.5
    localparam signed [63:0] STEP_START  = 64'h0000_0400_0000_0000; // 1/64
        
    // zoom control
    reg signed [FP_WIDTH-1:0] x_start_reg, y_start_reg;
    wire signed [FP_WIDTH-1:0] x_start_next, y_start_next;
    reg signed [FP_WIDTH-1:0] step_reg;
    wire signed [FP_WIDTH-1:0] step_next;
    
    // reticle
    wire [15:0] x_reticle_reg;
    wire [15:0] y_reticle_reg;
    
    // memory parameters
    localparam ADDR_WIDTH = 17; // 2^17 = 131072, fits 320*240 = 76800
    localparam DATA_WIDTH = 8; // 8-bits

    // dual-port memory unit signals
    wire [ADDR_WIDTH-1:0] mem_compute_addr; // write address for FSM
    wire [ADDR_WIDTH-1:0] mem_display_addr; // read address for VGA sync
    wire [DATA_WIDTH-1:0] mem_display_port; // read data (from memory to VGA)
    
    // pixel unit signals
    reg  pixel_start_reg, pixel_start_next; // start pulse to pixel calculator
    wire pixel_done; // pixel calculation done
    wire pixel_calc; //calculating flag
    reg signed [FP_WIDTH-1:0] pixel_re_reg, pixel_re_next; // latched re for module
    reg signed [FP_WIDTH-1:0] pixel_im_reg, pixel_im_next; // latched im for module
    wire [7:0] pixel_color; // 8-bit greyscale
    
    // VGA sync unit signals
    wire [9:0] vga_x, vga_y;
    wire vga_p_tick;
    wire vga_video_on;
    
    // registers for FSM and compute state
    reg signed [FP_WIDTH-1:0] re_reg, re_next; // real part 
    reg signed [FP_WIDTH-1:0] im_reg, im_next; // complex part
    reg [9:0] compute_x_reg, compute_x_next; // current X pixel (0-319)
    reg [9:0] compute_y_reg, compute_y_next; // current Y pixel (0-179)
    
    // state machine (5)
    // idle, write (pixel), jump_x, jump_y, done (write to RAM)
    localparam [2:0]
        idle  = 3'b000,
        write = 3'b001, // start/wait for pixel calculation
        jmp_x = 3'b010, // advance X coordinate
        jmp_y = 3'b011, // advance Y coordinate
        done  = 3'b100; // write result to RAM
    
    reg [2:0] state_reg; // FSM state register
    reg [2:0] state_next; // next-state register

    // memory interface control
    reg mem_we_reg, mem_we_next; // memory write enable (1-cycle pulse)

    // state and registers
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // reset coordinates
            state_reg <= idle;
            
            compute_x_reg <= 0;
            compute_y_reg <= 0;
            
            re_reg <= X_START;
            im_reg <= Y_START;
               
            x_start_reg <= X_START;
            y_start_reg <= Y_START;
            step_reg <= STEP_START;
                    
            pixel_start_reg <= 1'b0;
            
            mem_we_reg <= 1'b0;
            
            pixel_re_reg <= {FP_WIDTH{1'b0}};
            pixel_im_reg <= {FP_WIDTH{1'b0}};
        end
        else begin
            state_reg <= state_next;
            
            compute_x_reg <= compute_x_next;
            compute_y_reg <= compute_y_next;
            
            re_reg <= re_next;
            im_reg <= im_next;
            
            x_start_reg <= x_start_next;
            y_start_reg <= y_start_next;
            step_reg <= step_next;

            pixel_start_reg <= pixel_start_next;
            
            mem_we_reg <= mem_we_next;

            pixel_re_reg <= pixel_re_next;
            pixel_im_reg <= pixel_im_next;
        end
    end

    // next-state logic
    always @* begin
        state_next = state_reg;
        compute_x_next = compute_x_reg;
        compute_y_next = compute_y_reg;
        re_next = re_reg;
        im_next = im_reg;

        pixel_start_next = 1'b0;            
        mem_we_next = 1'b0;            

        pixel_re_next = pixel_re_reg;    
        pixel_im_next = pixel_im_reg;    

        // state machine
        case (state_reg)
            idle: begin
                // reset coordinates
                compute_x_next = 0;
                compute_y_next = 0;
                re_next = x_start_reg;
                im_next = y_start_reg;
                state_next = write; // start computing
            end

            write: begin
                // start/wait for pixel calculation
                pixel_start_next = 1'b1; // trigger calculation
                pixel_re_next = re_reg; // latch current coordinates for the module
                pixel_im_next = im_reg;

                // wait for mandelbrot pixel calculation to finish
                if (pixel_done) begin
                    state_next = done; // go to done (RAM write) state
                end
                // else, stay in write state
            end

            done: begin
                // write result to RAM
                mem_we_next = 1'b1; // enable write for one cycle

                // advance in raster order
                if (compute_x_reg < (H_COMPUTE - 1)) begin
                    state_next = jmp_x; // not end of row
                end
                else begin
                    state_next = jmp_y; // end of row, go to next row
                end
            end

            jmp_x: begin
                // advance to next pixel in row
                compute_x_next = compute_x_reg + 1;
                re_next = re_reg + step_reg;
                state_next = write;    // go back to compute
            end

            jmp_y: begin
                // advance to next row
                compute_x_next = 0;
                compute_y_next = compute_y_reg + 1;
                re_next = x_start_reg; // reset real part
                im_next = im_reg + step_reg;

                // end of compute frame (wrap around)
                if (compute_y_reg == (V_COMPUTE - 1)) begin
                    compute_y_next = 0; // wrap around
                    im_next = y_start_reg; // reset imaginary part
                end

                state_next = write; // go back to compute
            end

            default: begin
                state_next = idle;
            end
        endcase
        
        if (zoom_btn) begin
            state_next = idle;
            compute_x_next = 0;
            compute_y_next = 0;
            re_next = x_start_next; // new zoomed values
            im_next = y_start_next;
            mem_we_next = 1'b0; // avoid accidental RAM write
            pixel_start_next = 1'b0;
        end 
    end
    
    // write address for FSM
    assign mem_compute_addr = (compute_y_reg * H_COMPUTE) + compute_x_reg;
    
    // read address for VGA sync
    assign mem_display_addr =
        (vga_video_on && (vga_y < V_COMPUTE) && (vga_x < H_COMPUTE)) ?
            (vga_y * H_COMPUTE) + vga_x :
            16'd0;
            
    // =========================================================
    // VGA sync unit
    // =========================================================
    vga_sync vga_unit (
        .clk      (clk),
        .reset    (reset),
        .hsync    (hsync),
        .vsync    (vsync),
        .video_on (vga_video_on),
        .p_tick   (vga_p_tick),
        .p_x      (vga_x),
        .p_y      (vga_y)
    );

    // =========================================================
    // zoom unit
    // =========================================================
    zoom #(
        .FP_WIDTH (FP_WIDTH),
        .X_START (X_START),
        .Y_START (Y_START),
        .STEP_START (STEP_START)
    ) zoom_unit (
        .clk (clk),
        .reset (reset),
        .zoom_btn (zoom_btn),
        .reticle_sw ({up,down,left,right}),
        .re_start_reg (x_start_reg),
        .im_start_reg (y_start_reg),
        .step_reg (step_reg),
        .re_start_next (x_start_next),
        .im_start_next (y_start_next),
        .step_next (step_next),
        .x_reticle_reg (x_reticle_reg),
        .y_reticle_reg (y_reticle_reg)
    );

    // =========================================================
    // pixel unit
    // =========================================================
    pixel #(
        .FP_WIDTH      (FP_WIDTH),
        .FP_INT        (FP_INT),
        .FP_FRAC       (FP_FRAC),
        .MAX_ITERATION (MAX_ITERATION)
    ) pixel_unit (
        .clk         (clk),
        .reset       (reset),
        .start       (pixel_start_reg),
        .re          (pixel_re_reg),
        .im          (pixel_im_reg),
        .value       (pixel_color),
        .calculating (pixel_calc),
        .finished    (pixel_done)
    );
    
    // =========================================================
    // dual-port memory unit
    // =========================================================
    memory #(
        .ADDR_WIDTH (ADDR_WIDTH), 
        .DATA_WIDTH (DATA_WIDTH) 
    ) memory_unit (
        .clk    (clk),
        .we     (mem_we_reg), // write enable from FSM
        .addr_a (mem_compute_addr), // write address
        .addr_b (mem_display_addr), // read address
        .din_a  (pixel_color), // write data
        .dout_b (mem_display_port) // read data
    );
    
    // VGA color outputs
    // display 8-bit greyscale with the 4 MSBs
    wire signed [10:0] dx = vga_x - x_reticle_reg[9:0];
    wire signed [10:0] dy = vga_y - y_reticle_reg[9:0];
    
    wire crosshair =
        vga_video_on &&
        (
            ((dy == 0) && (dx >= -4 && dx <= 4)) || // horizontal arm
            ((dx == 0) && (dy >= -4 && dy <= 4)) // vertical arm
        );
    
    assign vga_r =
        crosshair ? 4'hF :
        (vga_video_on && (vga_y < V_COMPUTE) && (vga_x < H_COMPUTE))
            ? mem_display_port[7:5] : 4'h0;
    
    assign vga_g =
        crosshair ? 4'hF :
        (vga_video_on && (vga_y < V_COMPUTE) && (vga_x < H_COMPUTE))
            ? mem_display_port[6:4] : 4'h0;
    
    assign vga_b =
        crosshair ? 4'hF :
        (vga_video_on && (vga_y < V_COMPUTE) && (vga_x < H_COMPUTE))
            ? mem_display_port[5:3] : 4'h0;

endmodule
