`timescale 1ns / 1ps

module zoom #(
    parameter FP_WIDTH = 25,
    parameter signed [63:0] X_START = 64'hFFFC_8000_0000_0000, // -3.5
    parameter signed [63:0] Y_START = 64'hFFFE_8000_0000_0000, // -1.5
    parameter signed [63:0] STEP_START  = 64'h0000_0400_0000_0000, // 1/64
    parameter M = 2_000_000
)(
    input wire clk,
    input wire reset,
    input wire zoom_btn, // raw button input
    input wire [3:0] reticle_sw,
    input wire [FP_WIDTH-1:0] re_start_reg, im_start_reg,
    input wire [FP_WIDTH-1:0] step_reg,
    output reg [FP_WIDTH-1:0] re_start_next, im_start_next,
    output reg [FP_WIDTH-1:0] step_next,
    output reg [15:0] x_reticle_reg, y_reticle_reg
);

    //----------------------------------------------------------------------
    // Minimal debounce + rising-edge detect
    //----------------------------------------------------------------------
    reg db_reg, db_next;
    reg [19:0] db_cnt_reg, db_cnt_next;
    wire db_tick = (db_cnt_reg == 0);

    // debounce counter
    always @(posedge clk or posedge reset) begin
        if (reset)
            db_cnt_reg <= 0;
        else 
            db_cnt_reg <= db_cnt_next;
    end

    always @* begin
        db_cnt_next = db_cnt_reg + 1;
        db_next = db_reg;

        if (zoom_btn != db_reg) begin
            if (db_tick)
                db_next = zoom_btn;
        end else begin
            db_cnt_next = 0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            db_reg <= 1'b0;
        else
            db_reg <= db_next;
    end

    // rising edge
    reg db_reg_d;
    always @(posedge clk)
        db_reg_d <= db_reg;

    wire zoom_pulse = db_reg & ~db_reg_d;

    //----------------------------------------------------------------------
    // Reticle movement logic
    //----------------------------------------------------------------------
    reg [15:0] x_reticle_next, y_reticle_next;

    reg [31:0] modm_reg, modm_next;
    wire tick = (modm_reg == M-1);

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            x_reticle_reg <= 16'd160;
            y_reticle_reg <= 16'd120;
            modm_reg <= 0;
        end else begin
            x_reticle_reg <= x_reticle_next;
            y_reticle_reg <= y_reticle_next;
            modm_reg <= modm_next;
        end
    end

    always @* begin
        x_reticle_next = x_reticle_reg;
        y_reticle_next = y_reticle_reg;
        modm_next = modm_reg + 1;

        if (tick) begin
            case (reticle_sw)
                4'b0001: if (x_reticle_reg > 0) x_reticle_next = x_reticle_reg + 1;
                4'b0010: if (x_reticle_reg < 319) x_reticle_next = x_reticle_reg - 1;
                4'b0100: if (y_reticle_reg > 0) y_reticle_next = y_reticle_reg - 1;
                4'b1000: if (y_reticle_reg < 239) y_reticle_next = y_reticle_reg + 1;
            endcase
            modm_next = 0;
        end
    end

    //----------------------------------------------------------------------
    // zoom computation
    //----------------------------------------------------------------------
    wire signed [FP_WIDTH-1:0] x_world = re_start_reg + (x_reticle_reg * step_reg);
    wire signed [FP_WIDTH-1:0] y_world = im_start_reg + (y_reticle_reg * step_reg);

    wire signed [FP_WIDTH-1:0] step_zoomed =
        zoom_pulse ? (step_reg >>> 1) : step_reg;

    wire signed [FP_WIDTH-1:0] re_start_zoomed =
        re_start_reg + x_reticle_reg*(step_reg - step_zoomed);

    wire signed [FP_WIDTH-1:0] im_start_zoomed =
        im_start_reg + y_reticle_reg*(step_reg - step_zoomed);

    always @* begin
        re_start_next = re_start_reg;
        im_start_next = im_start_reg;
        step_next = step_reg;

        if (zoom_pulse) begin
            re_start_next = re_start_zoomed;
            im_start_next = im_start_zoomed;
            step_next = step_zoomed;
        end
    end

endmodule
