`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Mandelbrot Set Generator with VGA Display
// Uses calc module to compute Mandelbrot iterations
// Stores results in dual-port RAM
// VGA reads from RAM to display grayscale image
//////////////////////////////////////////////////////////////////////////////////
module mandelbrot(
    input wire clk,           // 100 MHz system clock
    input wire reset,         // Reset signal
    output wire hsync,        // VGA horizontal sync
    output wire vsync,        // VGA vertical sync
    output reg [3:0] vga_r, vga_g, vga_b 
    );
    
    // Screen dimensions
    localparam SCREEN_WIDTH = 640;
    localparam SCREEN_HEIGHT = 480;
    localparam PIXEL_COUNT = SCREEN_WIDTH * SCREEN_HEIGHT;
    
    // State machine for filling framebuffer
    localparam IDLE = 2'd0;
    localparam CALC = 2'd1;
    localparam WAIT = 2'd2;
    localparam NEXT = 2'd3;
    
    reg [1:0] state;
    reg [18:0] pixel_addr;      // Address counter (0 to 307199)
    reg [9:0] calc_x, calc_y;   // Current pixel being calculated
    reg calc_start;
    wire calc_done;
    wire [7:0] calc_val;
    
    // VGA signals
    wire video_on, p_tick;
    wire [9:0] pixel_x, pixel_y;
    wire [18:0] display_addr;
    wire [7:0] display_val;
    
    // Dual-port RAM signals
    reg we_a;                   // Write enable for port A (calculator)
    reg [18:0] addr_a;          // Address for port A
    reg [7:0] din_a;            // Data in for port A
    wire [18:0] addr_b;         // Address for port B (VGA)
    wire [7:0] dout_b;          // Data out for port B
    
    // Calculate display address from pixel coordinates
    assign display_addr = pixel_y * SCREEN_WIDTH + pixel_x;
    assign addr_b = display_addr;
    assign display_val = dout_b;
    
    //=========================================================================
    // VGA Sync Module
    //=========================================================================
    vga_sync vga_unit (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .p_tick(p_tick),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );
    
    //=========================================================================
    // Mandelbrot Calculator
    //=========================================================================
    calc mandelbrot_calc (
        .clk(clk),
        .rst(reset),
        .start(calc_start),
        .pixel_x(calc_x),
        .pixel_y(calc_y),
        .val(calc_val),
        .done(calc_done)
    );
    
    //=========================================================================
    // Dual-Port RAM (True Dual Port)
    // Port A: Write from calculator
    // Port B: Read for VGA display
    //=========================================================================
    tdp_bram #(.DATA_WIDTH(8), .DEPTH(640*480), .ADDR_WIDTH(19)) framebuffer (
      .clk(clk),
      .we_a(we_a), .addr_a(addr_a), .din_a(din_a), .dout_a(),
      .we_b(1'b0), .addr_b(addr_b), .din_b(8'h00), .dout_b(dout_b)
    );
    
    //=========================================================================
    // Framebuffer Fill State Machine
    //=========================================================================
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pixel_addr <= 19'd0;
            calc_x <= 10'd0;
            calc_y <= 10'd0;
            calc_start <= 1'b0;
            we_a <= 1'b0;
            addr_a <= 19'd0;
            din_a <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    // Start filling framebuffer
                    pixel_addr <= 19'd0;
                    calc_x <= 10'd0;
                    calc_y <= 10'd0;
                    state <= CALC;
                end
                
                CALC: begin
                    // Start calculation for current pixel
                    calc_start <= 1'b1;
                    we_a <= 1'b0;
                    state <= WAIT;
                end
                
                WAIT: begin
                    calc_start <= 1'b0;
                    // Wait for calculation to complete
                    if (calc_done) begin
                        // Write result to RAM
                        we_a <= 1'b1;
                        addr_a <= pixel_addr;
                        din_a <= calc_val;
                        state <= NEXT;
                    end
                end
                
                NEXT: begin
                    we_a <= 1'b0;
                    
                    // Move to next pixel
                    if (pixel_addr < PIXEL_COUNT - 1) begin
                        pixel_addr <= pixel_addr + 1;
                        
                        // Update x, y coordinates
                        if (calc_x < SCREEN_WIDTH - 1) begin
                            calc_x <= calc_x + 1;
                        end else begin
                            calc_x <= 10'd0;
                            calc_y <= calc_y + 1;
                        end
                        
                        state <= CALC;
                    end else begin
                        // Finished one complete frame, start over
                        pixel_addr <= 19'd0;
                        calc_x <= 10'd0;
                        calc_y <= 10'd0;
                        state <= CALC;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end
    
     //=========================================================================
     // VGA Color Output - Grayscale (MSB only)
     //=========================================================================
     
    always @(posedge clk) begin
        if (video_on) begin
            // use MSB of display_val as brightness
            vga_r[3:0] <= display_val[7:4];;
            vga_g[3:0] <= display_val[7:4];;
            vga_b[3:0] <= display_val[7:4];;
        end else begin
            vga_r <= 1'b0;
            vga_g <= 1'b0;
            vga_b <= 1'b0;
        end
    end
endmodule