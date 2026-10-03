`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2025 04:54:15 AM
// Design Name: 
// Module Name: dut_sq_wave
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


module dut_sq_wave;
    reg  clk = 0;
    reg  sw  = 0;
    wire y;
    
    always #5 clk = ~clk; // 10 ns period
    
    square_wave dut (.CLK100MHZ(clk), .switch(sw), .square_wave_out(y));
    
    
    initial begin
        sw = 1'b1;
        #2000000000;
        end;
endmodule
