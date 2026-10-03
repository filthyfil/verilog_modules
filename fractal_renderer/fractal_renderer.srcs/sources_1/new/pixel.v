`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 11/13/2025 07:42:59 PM
// Module Name: pixel
// Description: Pipelined, multi-pixel Mandelbrot iteration engine.
//
//   One iteration z <- z^2 + c is spread over a loop of LOOP_DEPTH pipeline
//   stages. Instead of one pixel waiting LOOP_DEPTH cycles per iteration,
//   LOOP_DEPTH pixels are kept in flight (one per stage), so the engine still
//   completes one iteration per clock while every stage has a short path.
//
//   Loop:  A (operand regs) -> MUL_LAT multiplier stages -> B (add) -> C (compare)
//          C feeds back into A: a finished slot is retired (out_valid) and may
//          be refilled with a new pixel in the same cycle (in_valid & in_ready).
//
//   Each pixel carries its own c (re, im), iteration count and tag (the frame
//   buffer address), so results may complete out of order.
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Rewritten as pipelined multi-pixel engine (timing closure)
//////////////////////////////////////////////////////////////////////////////////

module pixel #(
    parameter integer FP_WIDTH = 64, // total fixed-point bits
    parameter integer FP_FRAC = 48, // fractional bits (Q format = (FP_WIDTH-FP_FRAC).FP_FRAC)
    parameter integer MAX_ITERATION = 1000,
    parameter integer MUL_LAT = 8, // multiplier pipeline stages (absorbed into DSP cascade)
    parameter integer TAG_WIDTH = 17
    )(
    input wire clk,
    input wire reset,
    input wire flush, // drop every pixel in flight
    // new pixel
    input wire in_valid,
    output wire in_ready,
    input wire signed [FP_WIDTH-1:0] in_re,
    input wire signed [FP_WIDTH-1:0] in_im,
    input wire [TAG_WIDTH-1:0] in_tag,
    // finished pixel
    output wire out_valid,
    output wire [TAG_WIDTH-1:0] out_tag,
    output wire [7:0] out_value, // {escaped, iteration[6:0]}, 0 = inside the set
    output wire busy // any pixel in flight
    );

    localparam integer ITER_W = $clog2(MAX_ITERATION + 1);
    localparam integer SIDE_DEPTH = MUL_LAT + 1; // stage A + multiplier stages

    // 4.0 in Q format
    localparam signed [FP_WIDTH-1:0] FOUR = 64'sd4 <<< FP_FRAC;

    // ---------------------------------------------------------
    // stage C (loop exit) registers
    // ---------------------------------------------------------
    reg c_valid;
    reg signed [FP_WIDTH-1:0] c_x, c_y; // z_{n+1}
    reg signed [FP_WIDTH-1:0] c_re, c_im;
    reg [ITER_W-1:0] c_iter; // n
    reg [TAG_WIDTH-1:0] c_tag;
    reg c_escaped; // |z_n|^2 > 4
    reg c_max; // n == MAX_ITERATION

    wire c_finished = c_valid & (c_escaped | c_max);
    wire recirculate = c_valid & ~c_finished;

    assign in_ready = ~flush & ~recirculate;
    assign out_valid = c_finished & ~flush;
    assign out_tag = c_tag;
    wire [ITER_W+6:0] c_iter_ext = c_iter; // zero-extend: ITER_W may be < 7
    assign out_value = c_max ? 8'd0 : {1'b1, c_iter_ext[6:0]};

    wire inject = in_valid & in_ready;

    // ---------------------------------------------------------
    // stage A: operand registers (loop entry)
    // ---------------------------------------------------------
    reg signed [FP_WIDTH-1:0] a_x, a_y;
    reg [SIDE_DEPTH-1:0] side_valid; // bit k = stage k of the side pipeline
    // side data travelling alongside the multiplier: {re, im, iter, tag}
    // kept as one shift-register vector, newest entry in the low bits
    localparam integer SIDE_W = 2*FP_WIDTH + ITER_W + TAG_WIDTH;
    reg [SIDE_W-1:0] side_in;
    reg [SIDE_DEPTH*SIDE_W-1:0] side_pipe;

    always @* begin
        if (recirculate)
            side_in = {c_re, c_im, c_iter + 1'b1, c_tag};
        else
            side_in = {in_re, in_im, {ITER_W{1'b0}}, in_tag};
    end

    always @(posedge clk) begin
        if (recirculate) begin
            a_x <= c_x;
            a_y <= c_y;
        end
        else begin
            a_x <= {FP_WIDTH{1'b0}}; // z_0 = 0
            a_y <= {FP_WIDTH{1'b0}};
        end
        side_pipe <= (side_pipe << SIDE_W) | side_in;
    end

    wire signed [FP_WIDTH-1:0] s_re, s_im;
    wire [ITER_W-1:0] s_iter;
    wire [TAG_WIDTH-1:0] s_tag;
    assign {s_re, s_im, s_iter, s_tag} = side_pipe[SIDE_DEPTH*SIDE_W-1 -: SIDE_W];

    // ---------------------------------------------------------
    // multiplier pipeline: x*x, y*y, x*y
    // registered operands + MUL_LAT product registers lets synthesis
    // fold the stages into the DSP48 cascade
    // (shift-register vectors, newest product in the low bits)
    // ---------------------------------------------------------
    localparam integer P_W = 2*FP_WIDTH;
    wire signed [P_W-1:0] p_xx = a_x * a_x;
    wire signed [P_W-1:0] p_yy = a_y * a_y;
    wire signed [P_W-1:0] p_xy = a_x * a_y;
    reg [MUL_LAT*P_W-1:0] m_xx, m_yy, m_xy;

    always @(posedge clk) begin
        m_xx <= (m_xx << P_W) | p_xx;
        m_yy <= (m_yy << P_W) | p_yy;
        m_xy <= (m_xy << P_W) | p_xy;
    end

    wire [P_W-1:0] q_xx = m_xx[MUL_LAT*P_W-1 -: P_W];
    wire [P_W-1:0] q_yy = m_yy[MUL_LAT*P_W-1 -: P_W];
    wire [P_W-1:0] q_xy = m_xy[MUL_LAT*P_W-1 -: P_W];

    // back to Q format (2xy = xy shifted one less)
    wire signed [FP_WIDTH-1:0] x2 = q_xx[FP_FRAC +: FP_WIDTH];
    wire signed [FP_WIDTH-1:0] y2 = q_yy[FP_FRAC +: FP_WIDTH];
    wire signed [FP_WIDTH-1:0] two_x_y = q_xy[FP_FRAC-1 +: FP_WIDTH];

    // ---------------------------------------------------------
    // stage B: z_{n+1} = z_n^2 + c, |z_n|^2
    // ---------------------------------------------------------
    reg b_valid;
    reg signed [FP_WIDTH-1:0] b_x, b_y, b_mag2;
    reg signed [FP_WIDTH-1:0] b_re, b_im;
    reg [ITER_W-1:0] b_iter;
    reg [TAG_WIDTH-1:0] b_tag;

    always @(posedge clk) begin
        b_x <= x2 - y2 + s_re;
        b_y <= two_x_y + s_im;
        b_mag2 <= x2 + y2;
        b_re <= s_re;
        b_im <= s_im;
        b_iter <= s_iter;
        b_tag <= s_tag;
    end

    // ---------------------------------------------------------
    // stage C: escape test
    // ---------------------------------------------------------
    always @(posedge clk) begin
        c_x <= b_x;
        c_y <= b_y;
        c_re <= b_re;
        c_im <= b_im;
        c_iter <= b_iter;
        c_tag <= b_tag;
        c_escaped <= (b_mag2 > FOUR);
        c_max <= (b_iter == MAX_ITERATION);
    end

    // ---------------------------------------------------------
    // valid bits (the only state that needs reset/flush)
    // ---------------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            side_valid <= {SIDE_DEPTH{1'b0}};
            b_valid <= 1'b0;
            c_valid <= 1'b0;
        end
        else if (flush) begin
            side_valid <= {SIDE_DEPTH{1'b0}};
            b_valid <= 1'b0;
            c_valid <= 1'b0;
        end
        else begin
            side_valid <= {side_valid[SIDE_DEPTH-2:0], recirculate | inject};
            b_valid <= side_valid[SIDE_DEPTH-1];
            c_valid <= b_valid;
        end
    end

    assign busy = |side_valid | b_valid | c_valid;

endmodule
