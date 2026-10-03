`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_top
// Description: Frame-level testbench for the Mandelbrot renderer.
//
//   1. render the reset view, capture one VGA frame from hsync/vsync/rgb
//   2. reticle bounds: hold each direction past the edge, no wrap-around
//   3. zoom NUM_ZOOMS times toward TARGET, pressing the zoom button with
//      contact bounce; check the step halves exactly once per press and the
//      point under the reticle stays fixed
//   4. render the zoomed view, capture another VGA frame
//
//   Writes (in the working directory):
//     frameN.ppm  640x480 VGA capture (P3, maxval 15)
//     fbN.hex     frame buffer contents ($writememh)
//     viewN.txt   re_start im_start step x_reticle y_reticle (decimal, Q16.48 raw)
//   sim/check.py compares fbN against a bit-exact model and frameN against fbN.
//////////////////////////////////////////////////////////////////////////////////

module tb_top;

    parameter MAX_ITERATION = 256;
    parameter NUM_ZOOMS = 8;
    // target point (seahorse valley)
    parameter real TARGET_RE = -0.743643887037151;
    parameter real TARGET_IM = 0.131825904205330;

    localparam RETICLE_M = 16;
    localparam DB_N = 6; // debounce tick every 64 clocks
    localparam real ONE = 281474976710656.0; // 2^48

    reg clk = 0;
    reg reset = 1;
    reg up = 0, down = 0, left = 0, right = 0, zoom_btn = 0;
    wire hsync, vsync;
    wire [3:0] vga_r, vga_g, vga_b;

    always #5 clk = ~clk; // 100 MHz

    top #(
        .MAX_ITERATION (MAX_ITERATION),
        .RETICLE_M (RETICLE_M),
        .DB_N (DB_N)
    ) dut (
        .clk (clk),
        .reset (reset),
        .up (up),
        .down (down),
        .left (left),
        .right (right),
        .zoom_btn (zoom_btn),
        .hsync (hsync),
        .vsync (vsync),
        .vga_r (vga_r),
        .vga_g (vga_g),
        .vga_b (vga_b)
    );

    integer errors = 0;
    integer zooms_seen = 0;

    always @(posedge clk)
        if (dut.view_changed)
            zooms_seen = zooms_seen + 1;

    // ---------------------------------------------------------
    // helpers
    // ---------------------------------------------------------
    task wait_render;
        integer t;
        begin
            t = 0;
            @(posedge clk);
            while (!dut.render_done) begin
                @(posedge clk);
                t = t + 1;
                if (t > 200_000_000) begin
                    $display("ERROR: render timeout");
                    $finish;
                end
            end
            $display("[%0t] render done", $time);
        end
    endtask

    // capture one 640x480 frame by decoding the sync outputs
    // (active-high pulses: visible line 0 follows the 33rd hsync after vsync,
    //  visible pixel 0 starts 48 pixel clocks after the hsync pulse ends)
    task capture_frame(input [8*32-1:0] name);
        integer f, line, px, k;
        begin
            f = $fopen(name, "w");
            $fwrite(f, "P3\n640 480\n15\n");
            @(negedge vsync);
            for (k = 0; k < 32; k = k + 1)
                @(negedge hsync);
            for (line = 0; line < 480; line = line + 1) begin
                @(negedge hsync); // 33rd hsync for line 0
                repeat (48*4 + 2) @(negedge clk); // to the middle of pixel 0
                for (px = 0; px < 640; px = px + 1) begin
                    $fwrite(f, "%0d %0d %0d\n", vga_r, vga_g, vga_b);
                    repeat (4) @(negedge clk);
                end
            end
            $fclose(f);
            $display("[%0t] captured %0s", $time, name);
        end
    endtask

    task dump_state(input [8*32-1:0] fb_name, input [8*32-1:0] view_name);
        integer f;
        begin
            $writememh(fb_name, dut.memory_unit.ram);
            f = $fopen(view_name, "w");
            $fwrite(f, "%0d %0d %0d %0d %0d %0d\n",
                $signed(dut.re_start), $signed(dut.im_start), $signed(dut.step),
                dut.x_reticle, dut.y_reticle, MAX_ITERATION);
            $fclose(f);
        end
    endtask

    // hold a direction button until the reticle reaches (tx, ty)
    task move_reticle(input integer tx, input integer ty);
        integer t;
        begin
            t = 0;
            while ((dut.x_reticle != tx || dut.y_reticle != ty) && t < 2_000_000) begin
                right = (dut.x_reticle < tx);
                left = (dut.x_reticle > tx);
                down = (dut.y_reticle < ty);
                up = (dut.y_reticle > ty);
                @(posedge clk);
                t = t + 1;
            end
            {up, down, left, right} = 4'b0000;
            if (dut.x_reticle != tx || dut.y_reticle != ty) begin
                $display("ERROR: reticle stuck at (%0d,%0d), wanted (%0d,%0d)",
                    dut.x_reticle, dut.y_reticle, tx, ty);
                errors = errors + 1;
            end
        end
    endtask

    // hold one direction for n reticle steps
    task hold(input [3:0] dir, input integer steps);
        begin
            {up, down, left, right} = dir;
            repeat (steps * RETICLE_M) @(posedge clk);
            {up, down, left, right} = 4'b0000;
            repeat (4) @(posedge clk);
        end
    endtask

    task expect_reticle(input integer ex, input integer ey);
        begin
            if (dut.x_reticle !== ex || dut.y_reticle !== ey) begin
                $display("ERROR: reticle (%0d,%0d), expected (%0d,%0d)",
                    dut.x_reticle, dut.y_reticle, ex, ey);
                errors = errors + 1;
            end
        end
    endtask

    // a bouncy button press: chatter, hold, chatter, release
    task press_zoom;
        integer b;
        begin
            for (b = 0; b < 6; b = b + 1) begin
                zoom_btn = 1; repeat (3 + b) @(posedge clk);
                zoom_btn = 0; repeat (2 + b) @(posedge clk);
            end
            zoom_btn = 1;
            repeat (20 * (1 << DB_N)) @(posedge clk);
            for (b = 0; b < 6; b = b + 1) begin
                zoom_btn = 0; repeat (4 + b) @(posedge clk);
                zoom_btn = 1; repeat (2 + b) @(posedge clk);
            end
            zoom_btn = 0;
            repeat (6 * (1 << DB_N)) @(posedge clk); // debouncer back to idle
        end
    endtask

    // ---------------------------------------------------------
    // test sequence
    // ---------------------------------------------------------
    reg signed [63:0] re0, im0, step0, re_world0, im_world0;
    integer z, tx, ty, zooms_before;
    real rx, ry;

    initial begin
        repeat (10) @(posedge clk);
        reset = 0;

        // ---- 1. reset view
        wait_render;
        dump_state("fb0.hex", "view0.txt");
        capture_frame("frame0.ppm");

        // ---- 2. reticle bounds (starts at 160,120)
        expect_reticle(160, 120);
        hold(4'b0010, 200); expect_reticle(0, 120); // left past the edge
        hold(4'b0001, 400); expect_reticle(319, 120); // right past the edge
        hold(4'b1000, 200); expect_reticle(319, 0); // up past the edge
        hold(4'b0100, 300); expect_reticle(319, 239); // down past the edge
        hold(4'b1001, 10); expect_reticle(319, 229); // up+right: x clamped, y moves
        hold(4'b0011, 10); expect_reticle(319, 229); // left+right cancel
        $display("[%0t] reticle bounds checked", $time);

        // ---- 3. zoom toward the target
        for (z = 0; z < NUM_ZOOMS; z = z + 1) begin
            rx = (TARGET_RE - $signed(dut.re_start) / ONE) / ($signed(dut.step) / ONE);
            ry = ($signed(dut.im_start) / ONE - TARGET_IM) / ($signed(dut.step) / ONE);
            tx = $rtoi(rx + 0.5);
            ty = $rtoi(ry + 0.5);
            move_reticle(tx, ty);

            re0 = dut.re_start;
            im0 = dut.im_start;
            step0 = dut.step;
            re_world0 = dut.re_start + tx * dut.step;
            im_world0 = dut.im_start - ty * dut.step;
            zooms_before = zooms_seen;

            press_zoom;

            if (zooms_seen != zooms_before + 1) begin
                $display("ERROR: zoom %0d: %0d view updates for one press", z, zooms_seen - zooms_before);
                errors = errors + 1;
            end
            if (dut.step !== (step0 >>> 1)) begin
                $display("ERROR: zoom %0d: step %h, expected %h", z, dut.step, step0 >>> 1);
                errors = errors + 1;
            end
            if (dut.re_start + tx * dut.step !== re_world0 ||
                dut.im_start - ty * dut.step !== im_world0) begin
                $display("ERROR: zoom %0d: point under the reticle moved", z);
                errors = errors + 1;
            end
            $display("[%0t] zoom %0d at reticle (%0d,%0d), step = 2^-%0d",
                $time, z + 1, tx, ty, 6 + z + 1);
        end

        // leave the reticle on the target for the picture
        rx = (TARGET_RE - $signed(dut.re_start) / ONE) / ($signed(dut.step) / ONE);
        ry = ($signed(dut.im_start) / ONE - TARGET_IM) / ($signed(dut.step) / ONE);
        move_reticle($rtoi(rx + 0.5), $rtoi(ry + 0.5));

        // ---- 4. zoomed view
        wait_render;
        dump_state("fb1.hex", "view1.txt");
        capture_frame("frame1.ppm");

        if (errors == 0)
            $display("TB PASS");
        else
            $display("TB FAIL: %0d errors", errors);
        $finish;
    end

endmodule
