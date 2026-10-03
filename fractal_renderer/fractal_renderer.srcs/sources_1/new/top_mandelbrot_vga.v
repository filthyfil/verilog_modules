// Top: VGA Mandelbrot Visualizer (320x240 FB, 2x scale to 640x480)
// - Precompute framebuffer once using mandelbrot_pixel
// - Store 8-bit grayscale in BRAM
// - Read and display with 2x upscaling
`default_nettype none
`timescale 1ns/1ps

module top_mandelbrot_vga (
    input  wire        clk,          // 100 MHz
    input  wire        reset,        // async, active-high
    output wire        hsync,
    output wire        vsync,
    output wire [3:0]  vga_r,
    output wire [3:0]  vga_g,
    output wire [3:0]  vga_b
);
    //=====================================================================
    // Parameters
    //=====================================================================
    // VGA active area
    wire        video_on;
    localparam integer VGA_W = 640;
    localparam integer VGA_H = 480;

    // Framebuffer (compute at half-res => 320x240 => ~75 KB @ 8bpp)
    localparam integer FB_W = 320;
    localparam integer FB_H = 240;
    localparam integer FB_AW = 19;   // ceil(log2(320*240)) = 19
    localparam integer FB_SIZE = FB_W * FB_H;

    // Fixed-point format for Mandelbrot
    localparam integer FP_WIDTH = 25;
    localparam integer FP_INT   = 4;
    localparam integer ITER_MAX = 255;

    // View window (classic view)
    // X in [-2.5, 1.0], Y in [-1.25, 1.25]
    // You can tweak these to pan/zoom.
    localparam signed [FP_WIDTH-1:0] X_MIN = (-(25'sd40)  >>> 4); // -2.5 in Q4.21  (= -2.5 * 2^21)
    localparam signed [FP_WIDTH-1:0] X_MAX = (25'sd24 >>> 4); // ≈1.5
    localparam signed [FP_WIDTH-1:0] Y_MIN = (-(25'sd20)  >>> 4); // -1.25
    localparam signed [FP_WIDTH-1:0] Y_MAX = (  (25'sd20)  >>> 4); //  1.25

    // Helper: compute Q format constants precisely
    // Safer explicit construction: (real * (1<<FRAC)) using integers.
    localparam integer FRAC = FP_WIDTH - FP_INT;
    // Rebuild exact Q constants:
    // X_MIN = -2.5 -> -(2^FRAC*2 + 2^FRAC/2)
    // X_MAX =  1.0 ->  (2^FRAC)
    // Y_MIN = -1.25 -> -(2^FRAC + 2^FRAC/4)
    // Y_MAX =  1.25 ->  (2^FRAC + 2^FRAC/4)
    // (Override the quick approximations above with exact values)
    localparam signed [FP_WIDTH-1:0] ONE_Q = (1'sd1 <<< FRAC);
    localparam signed [FP_WIDTH-1:0] HALF_Q = (ONE_Q >>> 1);
    localparam signed [FP_WIDTH-1:0] QUART_Q = (ONE_Q >>> 2);
    // Exact bounds:
    localparam signed [FP_WIDTH-1:0] X_MIN_Q = -( (ONE_Q<<<1) + HALF_Q ); // -2.5
    localparam signed [FP_WIDTH-1:0] X_MAX_Q =   ( ONE_Q );               //  1.0
    localparam signed [FP_WIDTH-1:0] Y_MIN_Q = -( ONE_Q + QUART_Q );      // -1.25
    localparam signed [FP_WIDTH-1:0] Y_MAX_Q =   ( ONE_Q + QUART_Q );     //  1.25

    // Step sizes: dx = (X_MAX-X_MIN)/FB_W ; dy = (Y_MAX-Y_MIN)/FB_H
    // In Q: (delta_Q) / N  -> still Q
    localparam signed [FP_WIDTH-1:0] DX_Q = (X_MAX_Q - X_MIN_Q) / FB_W;
    localparam signed [FP_WIDTH-1:0] DY_Q = (Y_MAX_Q - Y_MIN_Q) / FB_H;

    //=====================================================================
    // VGA timing
    //=====================================================================
    wire [9:0]  pix_x, pix_y;
    wire        p_tick;

    vga_sync vga_sync_i (
        .clk       (clk),
        .reset     (reset),
        .hsync     (hsync),
        .vsync     (vsync),
        .video_on  (video_on),
        .p_tick    (p_tick),
        .pixel_x   (pix_x),
        .pixel_y   (pix_y)
    );

    //=====================================================================
    // Framebuffer BRAM (8-bit)
    // - A: write port (addr_a/din_a/we)
    // - B: read-only port (addr_b -> dout_b with 1-cycle latency)
    //=====================================================================
    wire                   fb_we;
    reg  [FB_AW-1:0]       fb_addr_a;
    reg  [7:0]             fb_din_a;
    reg  [FB_AW-1:0]       fb_addr_b;
    wire [7:0]             fb_dout_b;

    memory #(
        .ADDR_WIDTH(FB_AW),
        .DATA_WIDTH(8)
    ) fb_i (
        .clk     (clk),
        .we      (fb_we),
        .addr_a  (fb_addr_a),
        .addr_b  (fb_addr_b),
        .din_a   (fb_din_a),
        .dout_b  (fb_dout_b)
    );

    //=====================================================================
    // Compute engine: mandelbrot_pixel
    //=====================================================================
    reg                      mb_start;
    wire                     mb_done;
    wire                     mb_calc;
    reg  signed [FP_WIDTH-1:0] mb_re, mb_im;
    wire [7:0]               mb_gray;

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

    //=====================================================================
    // Writer FSM: sweep framebuffer once and fill with Mandelbrot
    //=====================================================================
    localparam [1:0] W_IDLE = 2'd0, W_KICK = 2'd1, W_WAIT = 2'd2, W_NEXT = 2'd3;
    reg [1:0]  w_state;
    reg [15:0] w_x;    // enough for 0..319
    reg [15:0] w_y;    // enough for 0..239
    reg        fb_done;

    // Current complex coord (Q format)
    // c.re = X_MIN_Q + w_x * DX_Q ; c.im = Y_MIN_Q + w_y * DY_Q
    // Implement with sequential assigns at each pixel.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            w_state   <= W_IDLE;
            w_x       <= 0;
            w_y       <= 0;
            mb_start  <= 1'b0;
            fb_done   <= 1'b0;
        end else begin
            mb_start <= 1'b0;
            case (w_state)
                W_IDLE: begin
                    w_x     <= 0;
                    w_y     <= 0;
                    fb_done <= 1'b0;
                    w_state <= W_KICK;
                end
                W_KICK: begin
                    // Load (re,im) and start engine
                    mb_re   <= X_MIN_Q + $signed(w_x) * DX_Q;
                    mb_im   <= Y_MIN_Q + $signed(w_y) * DY_Q;
                    mb_start <= 1'b1;
                    w_state <= W_WAIT;
                end
                W_WAIT: begin
                    if (mb_done) begin
                        // Write to FB
                        fb_addr_a <= w_y * FB_W + w_x;
                        fb_din_a  <= mb_gray;
                        // fb_we asserted for 1 cycle below
                        w_state   <= W_NEXT;
                    end
                end
                W_NEXT: begin
                    if (w_x == FB_W-1) begin
                        w_x <= 0;
                        if (w_y == FB_H-1) begin
                            w_y     <= 0;
                            fb_done <= 1'b1;     // finished full frame
                            w_state <= W_IDLE;   // (loop; or hold here if desired)
                        end else begin
                            w_y     <= w_y + 1;
                            w_state <= W_KICK;
                        end
                    end else begin
                        w_x     <= w_x + 1;
                        w_state <= W_KICK;
                    end
                end
            endcase
        end
    end

    // Write enable: pulse when we moved from WAIT->NEXT (i.e., right after mb_done)
    reg w_we_q;
    always @(posedge clk or posedge reset) begin
        if (reset) w_we_q <= 1'b0;
        else       w_we_q <= (w_state==W_WAIT && mb_done);
    end
    assign fb_we = w_we_q;

    //=====================================================================
    // VGA read path with 2x upscaling and 1-cycle BRAM latency alignment
    //=====================================================================
    // Scale VGA coords to FB coords: fb_x = pix_x>>1; fb_y = pix_y>>1
    wire [9:0] fb_x_rd = pix_x[9:1]; // divide by 2
    wire [9:0] fb_y_rd = pix_y[9:1];

    // Guard within FB size (when video_on=1 we're in 0..639/0..479, so ok)
    wire [FB_AW-1:0] fb_addr_b_next = fb_y_rd * FB_W + fb_x_rd;

    // Feed BRAM address; account for 1-cycle latency by registering video_on
    reg  video_on_d;
    reg  [7:0] gray_q;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fb_addr_b  <= {FB_AW{1'b0}};
            video_on_d <= 1'b0;
            gray_q     <= 8'd0;
        end else begin
            if (p_tick) begin
                fb_addr_b  <= fb_addr_b_next;
                video_on_d <= video_on;
                gray_q     <= fb_dout_b; // capture last cycle's pixel
            end
        end
    end

    // Map 8-bit grayscale to 4:4:4 RGB (simple)
    // Use delayed video_on_d to match FB read latency.
    reg [3:0] r_q, g_q, b_q;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_q <= 4'h0; g_q <= 4'h0; b_q <= 4'h0;
        end else if (p_tick) begin
            if (video_on_d) begin
                r_q <= gray_q[7:4];
                g_q <= gray_q[7:4];
                b_q <= gray_q[7:4];
            end else begin
                r_q <= 4'h0; g_q <= 4'h0; b_q <= 4'h0;
            end
        end
    end

    assign vga_r = r_q;
    assign vga_g = g_q;
    assign vga_b = b_q;

endmodule
`default_nettype wire
