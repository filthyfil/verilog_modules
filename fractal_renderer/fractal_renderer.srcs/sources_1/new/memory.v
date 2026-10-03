`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 06:40:16 PM
// Design Name: dual-port RAM with synchronous read
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
    parameter ADDR_WIDTH = 16,
              DATA_WIDTH = 8
    ) (
    // I/O
    input wire clk,
    input wire we,
    input wire [ADDR_WIDTH-1:0] addr_a, addr_b,
    input wire [DATA_WIDTH-1:0] din_a,
    output wire [DATA_WIDTH-1:0] dout_b
    );
    
    // signal declaration
    reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
    reg [ADDR_WIDTH-1:0] addr_a_reg, addr_b_reg;
    
    // body
    always @(posedge clk) begin
        if (we) // write op
            ram[addr_a] <= din_a;
        addr_a_reg <= addr_a;
        addr_b_reg <= addr_b;
    end
    // read only on display bus    
    assign dout_b = ram[addr_b_reg];
endmodule
