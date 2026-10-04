`timescale 1ns / 1ps
/*
 * Testbench for tt_um_filthyfil_mandelbrot.
 *
 * Captures 640x480 frames from the TinyVGA pins only (active-low syncs:
 * visible line 0 follows the 33rd hsync pulse after vsync, visible pixel 0
 * starts 48 pixels after an hsync pulse ends) while exercising the controls:
 *
 *   frame0, frame1   forward, speed 0      -> phase +1 per frame
 *   frame2, frame3   reverse               -> phase -1 per frame
 *   frame4, frame5   paused                -> phase unchanged
 *
 * Writes frameN.ppm (P3, maxval 3). check.py compares every frame against
 * the bit-level model and checks the phase sequence.
 */

`default_nettype none

module tb;

    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg [7:0] ui_in = 8'd0;
    wire [7:0] uo_out, uio_out, uio_oe;

    always #9.93 clk = ~clk; // 50.35 MHz

    tt_um_filthyfil_mandelbrot dut (
        .ui_in   (ui_in),
        .uo_out  (uo_out),
        .uio_in  (8'd0),
        .uio_out (uio_out),
        .uio_oe  (uio_oe),
        .ena     (1'b1),
        .clk     (clk),
        .rst_n   (rst_n)
    );

    // TinyVGA PMOD
    wire hsync_n = uo_out[7];
    wire vsync_n = uo_out[3];
    wire [1:0] r = {uo_out[0], uo_out[4]};
    wire [1:0] g = {uo_out[1], uo_out[5]};
    wire [1:0] b = {uo_out[2], uo_out[6]};

    task capture_frame(input [8*16-1:0] name);
        integer f, line, px, k;
        begin
            f = $fopen(name, "w");
            $fwrite(f, "P3\n640 480\n3\n");
            @(posedge vsync_n); // end of vsync pulse (start of line 492)
            for (k = 0; k < 32; k = k + 1)
                @(posedge hsync_n);
            for (line = 0; line < 480; line = line + 1) begin
                @(posedge hsync_n); // 33rd hsync for line 0
                repeat (48*2 + 1) @(negedge clk); // into pixel 0 (2 clocks/pixel)
                for (px = 0; px < 640; px = px + 1) begin
                    $fwrite(f, "%0d %0d %0d\n", r, g, b);
                    repeat (2) @(negedge clk);
                end
            end
            $fclose(f);
            $display("[%0t] captured %0s", $time, name);
        end
    endtask

    initial begin
        repeat (10) @(posedge clk);
        rst_n = 1'b1;
        @(negedge vsync_n); // skip the first (partial) frame

        capture_frame("frame0.ppm");
        capture_frame("frame1.ppm");

        ui_in[2] = 1'b1; // reverse (takes effect at the next frame tick)
        capture_frame("frame2.ppm");
        capture_frame("frame3.ppm");

        ui_in[3] = 1'b1; // pause
        capture_frame("frame4.ppm");
        capture_frame("frame5.ppm");

        if (uio_oe !== 8'd0 || uio_out !== 8'd0)
            $display("ERROR: uio driven");
        $display("TB DONE");
        $finish;
    end

endmodule
