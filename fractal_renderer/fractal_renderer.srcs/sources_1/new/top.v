`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/11/2025 03:12:37 PM
// Design Name:
// Module Name: top
// Project Name:
// Target Devices: Arty S7-50
// Tool Versions:
// Description: Mandelbrot renderer: raster generator -> pipelined iteration
//              engine -> dual-port frame buffer -> 2x scaled VGA output
//
// Dependencies: vga_sync, pixel, memory, zoom, debounce_edge
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Completed FSM and memory/VGA logic
// Revision 0.03 - Converted control/datapath to FSMD style
// Revision 0.04 - Pipelined engine, debounced zoom, 2x display, palette
// Additional Comments:
//   The frame is rendered once after reset and after every zoom.
//////////////////////////////////////////////////////////////////////////////////

module top #(
    // max number of iterations
    parameter MAX_ITERATION = 1000,
    // multiplier pipeline depth inside the iteration engine
    parameter MUL_LAT = 8,
    // clocks per reticle step (20 ms)
    parameter RETICLE_M = 2_000_000,
    // debounce tick counter bits (2^20 clocks = 10 ms)
    parameter DB_N = 20
    )(
    input wire clk, // 100 MHz
    input wire reset,
    input wire up, down, left, right,
    input wire zoom_btn,
    output reg hsync,
    output reg vsync,
    output reg [3:0] vga_r,
    output reg [3:0] vga_g,
    output reg [3:0] vga_b
    );

    // fixed point parameters
    localparam FP_WIDTH = 64;
    localparam FP_FRAC  = 48;

    // compute resolution (displayed at 2x on 640x480)
    localparam H_COMPUTE = 320;
    localparam V_COMPUTE = 240;

    // ---------------------------------------------------------
    // starting view, Q16.48 (centred on -0.75 + 0i)
    // X_START: left edge:   -3.25
    // Y_START: top edge:    +1.875i
    // STEP:    pixel pitch:  1/64
    // ---------------------------------------------------------
    localparam signed [63:0] X_START    = 64'hFFFC_C000_0000_0000; // -3.25
    localparam signed [63:0] Y_START    = 64'h0001_E000_0000_0000; // +1.875
    localparam signed [63:0] STEP_START = 64'h0000_0400_0000_0000; // 1/64

    // memory parameters
    localparam ADDR_WIDTH = 17; // 2^17 = 131072, fits 320*240 = 76800
    localparam DATA_WIDTH = 8;

    // =========================================================
    // button synchronizers (async inputs -> clk domain)
    // =========================================================
    reg [4:0] btn_meta, btn_sync;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            btn_meta <= 5'b0;
            btn_sync <= 5'b0;
        end
        else begin
            btn_meta <= {zoom_btn, up, down, left, right};
            btn_sync <= btn_meta;
        end
    end
    wire zoom_sync = btn_sync[4];
    wire up_sync = btn_sync[3];
    wire down_sync = btn_sync[2];
    wire left_sync = btn_sync[1];
    wire right_sync = btn_sync[0];

    // =========================================================
    // zoom button debounce
    // =========================================================
    wire zoom_tick;

    debounce_edge #(
        .N (DB_N)
    ) zoom_db (
        .clk (clk),
        .reset (reset),
        .sw (zoom_sync),
        .db_level (),
        .db_tick (zoom_tick)
    );

    // =========================================================
    // zoom unit (reticle + view registers)
    // =========================================================
    wire signed [FP_WIDTH-1:0] re_start, im_start, step;
    wire [8:0] x_reticle;
    wire [7:0] y_reticle;
    wire view_changed;

    zoom #(
        .FP_WIDTH (FP_WIDTH),
        .X_START (X_START),
        .Y_START (Y_START),
        .STEP_START (STEP_START),
        .H_COMPUTE (H_COMPUTE),
        .V_COMPUTE (V_COMPUTE),
        .M (RETICLE_M)
    ) zoom_unit (
        .clk (clk),
        .reset (reset),
        .zoom_tick (zoom_tick),
        .up (up_sync),
        .down (down_sync),
        .left (left_sync),
        .right (right_sync),
        .re_start (re_start),
        .im_start (im_start),
        .step (step),
        .x_reticle (x_reticle),
        .y_reticle (y_reticle),
        .view_changed (view_changed)
    );

    // =========================================================
    // raster generator: feeds one c per accepted pixel
    // =========================================================
    reg start_pending; // render after reset
    reg gen_active;
    reg [8:0] gen_x;
    reg [7:0] gen_y;
    reg [ADDR_WIDTH-1:0] gen_addr;
    reg signed [FP_WIDTH-1:0] gen_re, gen_im;

    wire restart = start_pending | view_changed;

    wire engine_ready;
    wire engine_busy;
    wire result_valid;
    wire [ADDR_WIDTH-1:0] result_addr;
    wire [7:0] result_value;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            start_pending <= 1'b1;
            gen_active <= 1'b0;
            gen_x <= 0;
            gen_y <= 0;
            gen_addr <= 0;
            gen_re <= X_START;
            gen_im <= Y_START;
        end
        else if (restart) begin
            start_pending <= 1'b0;
            gen_active <= 1'b1;
            gen_x <= 0;
            gen_y <= 0;
            gen_addr <= 0;
            gen_re <= re_start;
            gen_im <= im_start;
        end
        else if (gen_active && engine_ready) begin
            gen_addr <= gen_addr + 1;
            if (gen_x == H_COMPUTE - 1) begin
                // next row
                gen_x <= 0;
                gen_y <= gen_y + 1;
                gen_re <= re_start;
                gen_im <= gen_im - step;
                if (gen_y == V_COMPUTE - 1)
                    gen_active <= 1'b0; // last pixel issued
            end
            else begin
                gen_x <= gen_x + 1;
                gen_re <= gen_re + step;
            end
        end
    end

    // frame fully written to memory
    wire render_done = ~start_pending & ~gen_active & ~engine_busy;

    // =========================================================
    // iteration engine
    // =========================================================
    pixel #(
        .FP_WIDTH      (FP_WIDTH),
        .FP_FRAC       (FP_FRAC),
        .MAX_ITERATION (MAX_ITERATION),
        .MUL_LAT       (MUL_LAT),
        .TAG_WIDTH     (ADDR_WIDTH)
    ) pixel_unit (
        .clk       (clk),
        .reset     (reset),
        .flush     (restart),
        .in_valid  (gen_active),
        .in_ready  (engine_ready),
        .in_re     (gen_re),
        .in_im     (gen_im),
        .in_tag    (gen_addr),
        .out_valid (result_valid),
        .out_tag   (result_addr),
        .out_value (result_value),
        .busy      (engine_busy)
    );

    // =========================================================
    // VGA sync unit
    // =========================================================
    wire [9:0] vga_x, vga_y;
    wire vga_p_tick;
    wire vga_video_on;
    wire vga_hsync, vga_vsync;

    vga_sync vga_unit (
        .clk      (clk),
        .reset    (reset),
        .hsync    (vga_hsync),
        .vsync    (vga_vsync),
        .video_on (vga_video_on),
        .p_tick   (vga_p_tick),
        .p_x      (vga_x),
        .p_y      (vga_y)
    );

    // read address for VGA, 640x480 -> 320x240 (each pixel shown 2x2)
    wire [ADDR_WIDTH-1:0] mem_display_addr =
        (vga_y[9:1] * H_COMPUTE) + vga_x[9:1];

    // =========================================================
    // dual-port memory unit
    // =========================================================
    wire [DATA_WIDTH-1:0] mem_display_port;

    memory #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH),
        .DEPTH      (H_COMPUTE * V_COMPUTE)
    ) memory_unit (
        .clk    (clk),
        .we     (result_valid), // write enable from engine
        .addr_a (result_addr), // write address
        .addr_b (mem_display_addr), // read address
        .din_a  (result_value), // write data
        .dout_b (mem_display_port) // read data
    );

    // =========================================================
    // colour output
    // stage 0: counters -> address, crosshair
    // stage 1: memory data
    // stage 2: palette -> output registers (with delayed syncs)
    // =========================================================
    // reticle crosshair, centred on the compute pixel, arms +/-8 screen pixels
    wire signed [10:0] dx = $signed({1'b0, vga_x}) - $signed({1'b0, x_reticle, 1'b0});
    wire signed [10:0] dy = $signed({1'b0, vga_y}) - $signed({1'b0, y_reticle, 1'b0});

    wire crosshair =
        ((dy == 0) && (dx >= -8 && dx <= 8)) || // horizontal arm
        ((dx == 0) && (dy >= -8 && dy <= 8)); // vertical arm

    reg video_on_d1, crosshair_d1;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            video_on_d1 <= 1'b0;
            crosshair_d1 <= 1'b0;
        end
        else begin
            video_on_d1 <= vga_video_on;
            crosshair_d1 <= crosshair;
        end
    end

    // 32-entry cyclic palette, 4 bits per channel
    function [11:0] palette;
        input [4:0] idx;
        begin
            case (idx)
                5'd0 : palette = 12'h006;
                5'd1 : palette = 12'h027;
                5'd2 : palette = 12'h138;
                5'd3 : palette = 12'h149;
                5'd4 : palette = 12'h15B;
                5'd5 : palette = 12'h26C;
                5'd6 : palette = 12'h37C;
                5'd7 : palette = 12'h58D;
                5'd8 : palette = 12'h69D;
                5'd9 : palette = 12'h8AD;
                5'd10: palette = 12'h9BE;
                5'd11: palette = 12'hACE;
                5'd12: palette = 12'hCDE;
                5'd13: palette = 12'hDFF;
                5'd14: palette = 12'hEFE;
                5'd15: palette = 12'hEEC;
                5'd16: palette = 12'hEDA;
                5'd17: palette = 12'hEC7;
                5'd18: palette = 12'hFC5;
                5'd19: palette = 12'hFB3;
                5'd20: palette = 12'hFA1;
                5'd21: palette = 12'hE90;
                5'd22: palette = 12'hC80;
                5'd23: palette = 12'hA60;
                5'd24: palette = 12'h850;
                5'd25: palette = 12'h540;
                5'd26: palette = 12'h320;
                5'd27: palette = 12'h110;
                5'd28: palette = 12'h001;
                5'd29: palette = 12'h002;
                5'd30: palette = 12'h003;
                default: palette = 12'h005;
            endcase
        end
    endfunction

    // stored value: {escaped, iteration[6:0]}, 0 = inside the set (black)
    wire [11:0] pixel_rgb = mem_display_port[7] ? palette(mem_display_port[4:0]) : 12'h000;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            {vga_r, vga_g, vga_b} <= 12'h000;
            hsync <= 1'b0;
            vsync <= 1'b0;
        end
        else begin
            // vga_sync's syncs are already registered (1 cycle behind the
            // counters); one more register matches the colour pipeline
            hsync <= vga_hsync;
            vsync <= vga_vsync;
            if (crosshair_d1 && video_on_d1)
                {vga_r, vga_g, vga_b} <= 12'hFFF;
            else if (video_on_d1)
                {vga_r, vga_g, vga_b} <= pixel_rgb;
            else
                {vga_r, vga_g, vga_b} <= 12'h000;
        end
    end

endmodule
