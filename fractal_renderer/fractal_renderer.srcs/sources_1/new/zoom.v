`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: zoom
// Description: Reticle movement and view (re_start, im_start, step) registers.
//
//   The view maps compute pixel (px, py) to c = (re_start + px*step) + i(im_start - py*step),
//   i.e. row 0 is the top of the image (largest imaginary part).
//
//   On zoom_tick the step is halved and the start corner moved so that the point
//   under the reticle stays fixed:
//       start' = start + r * (step - step')   (re, and mirrored for im)
//   The offsets are computed over a short pipeline (the 64-bit products are not
//   needed in a single cycle), and view_changed pulses once the new view is in place.
//////////////////////////////////////////////////////////////////////////////////

module zoom #(
    parameter FP_WIDTH = 64,
    parameter signed [63:0] X_START = 64'hFFFC_C000_0000_0000, // -3.25
    parameter signed [63:0] Y_START = 64'h0001_E000_0000_0000, // +1.875
    parameter signed [63:0] STEP_START = 64'h0000_0400_0000_0000, // 1/64
    parameter H_COMPUTE = 320,
    parameter V_COMPUTE = 240,
    parameter M = 2_000_000 // clocks per reticle step (20 ms at 100 MHz)
)(
    input wire clk,
    input wire reset,
    input wire zoom_tick, // debounced 1-cycle pulse
    input wire up, down, left, right, // synchronized buttons
    output reg signed [FP_WIDTH-1:0] re_start,
    output reg signed [FP_WIDTH-1:0] im_start,
    output reg signed [FP_WIDTH-1:0] step,
    output reg [8:0] x_reticle, // compute-pixel coordinates
    output reg [7:0] y_reticle,
    output reg view_changed // 1-cycle pulse after the view updates
);

    //----------------------------------------------------------------------
    // zoom sequencer: tick -> products valid -> apply
    //----------------------------------------------------------------------
    reg [2:0] zoom_pipe; // zoom in progress (freezes reticle and view inputs)
    wire zooming = |zoom_pipe;
    wire can_zoom = (step > 1); // stop once the step is one LSB

    always @(posedge clk or posedge reset) begin
        if (reset)
            zoom_pipe <= 3'b000;
        else
            zoom_pipe <= {zoom_pipe[1:0], zoom_tick & can_zoom & ~zooming};
    end

    //----------------------------------------------------------------------
    // reticle movement
    //----------------------------------------------------------------------
    reg [31:0] modm_reg;
    wire move_tick = (modm_reg == M-1);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_reticle <= H_COMPUTE / 2;
            y_reticle <= V_COMPUTE / 2;
            modm_reg <= 0;
        end
        else begin
            modm_reg <= move_tick ? 0 : modm_reg + 1;
            if (move_tick && !zooming) begin
                if (right && !left && x_reticle < H_COMPUTE - 1) x_reticle <= x_reticle + 1;
                if (left && !right && x_reticle > 0) x_reticle <= x_reticle - 1;
                if (down && !up && y_reticle < V_COMPUTE - 1) y_reticle <= y_reticle + 1;
                if (up && !down && y_reticle > 0) y_reticle <= y_reticle - 1;
            end
        end
    end

    //----------------------------------------------------------------------
    // zoom computation (2 product stages)
    //----------------------------------------------------------------------
    wire signed [FP_WIDTH-1:0] step_zoomed = step >>> 1;
    wire signed [FP_WIDTH-1:0] step_delta = step - step_zoomed;

    reg signed [FP_WIDTH-1:0] re_off_p, im_off_p, re_off, im_off;
    always @(posedge clk) begin
        re_off_p <= $signed({1'b0, x_reticle}) * step_delta;
        im_off_p <= $signed({1'b0, y_reticle}) * step_delta;
        re_off <= re_off_p;
        im_off <= im_off_p;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            re_start <= X_START;
            im_start <= Y_START;
            step <= STEP_START;
            view_changed <= 1'b0;
        end
        else begin
            view_changed <= zoom_pipe[2];
            if (zoom_pipe[2]) begin
                re_start <= re_start + re_off;
                im_start <= im_start - im_off;
                step <= step_zoomed;
            end
        end
    end

endmodule
