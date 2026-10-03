`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 06:40:16 PM
// Design Name: simple dual-port RAM (1 write port, 1 synchronous read port)
// Module Name: memory
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


module memory #(
    parameter ADDR_WIDTH = 17,
              DATA_WIDTH = 8,
              DEPTH = 320*240
    ) (
    // I/O
    input wire clk,
    input wire we,
    input wire [ADDR_WIDTH-1:0] addr_a, addr_b,
    input wire [DATA_WIDTH-1:0] din_a,
    output reg [DATA_WIDTH-1:0] dout_b
    );
    
    // signal declaration
    reg [DATA_WIDTH-1:0] ram [0:DEPTH-1];
    
    // body
    // write port (compute side)
    always @(posedge clk) begin
        if (we)
            ram[addr_a] <= din_a;
    end
    
    // read port (display side), 1-cycle latency
    always @(posedge clk) begin
        dout_b <= ram[addr_b];
    end
endmodule
