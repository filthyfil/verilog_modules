`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2025 11:47:27 AM
// Design Name: 
// Module Name: edge_detector
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


module edge_detector(
    input wire clk,
    input wire in,
    output wire out
    );
    
    // signal declaration
    reg rising_tick;
    
    always @(posedge clk) begin
        rising_tick <= in;
    end
    
    assign out = in & ~rising_tick;
endmodule
