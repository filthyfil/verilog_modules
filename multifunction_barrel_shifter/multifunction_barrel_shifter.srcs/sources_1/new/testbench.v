`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2025 10:42:45 PM
// Design Name: 
// Module Name: testbench
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


module testbench
    #(parameter width=8 ); 
  
    // instantiate signals  
    reg [width-1:0] d_test;
    reg sel_test;
    wire [width-1:0] d_out_test;  
      
    // instantiate circuit
    barrel_shifter #(width) uut (.d(d_test), .sel(sel_test), .d_out(d_out_test));    
    
    // test vectors
    initial begin 
        // test 1: 0000 0001 -> ror ->  1000 0000
        d_test = 8'b0000_0001;
        sel_test = 1'b1;       
        #100; 
        
        // test 2: 1000 0000 -> lor -> 0000 0001
        d_test = 8'b1000_0000;
        sel_test = 1'b0;
        #100;      
        
        $stop;
    end
   
endmodule
