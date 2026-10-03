`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2025 05:13:39 AM
// Design Name: 
// Module Name: square_wave
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


module square_wave(
    input wire CLK100MHZ,
    input wire switch,
    output wire square_wave_out
    );

    // Input clock is 100MHz
	localparam CLOCK_FREQUENCY = 100000000;
    localparam TARGET_FREQUENCY = 1000000; // 1 Hz
    localparam DIVISOR = CLOCK_FREQUENCY / TARGET_FREQUENCY;

    reg square_wave_state = 0;    
    integer counter = 0;

    always @(posedge CLK100MHZ) begin
        if (switch) begin
            if (counter == 0) begin
                square_wave_state <= ~square_wave_state;
                counter <= (DIVISOR / 2) - 1;
            end

            else begin
                counter <= counter - 1;
            end
        end
        else begin
            square_wave_state <= 0; 
            counter <= 0;
        end
    end

    assign square_wave_out = square_wave_state;
    
endmodule