`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2025 07:01:26 PM
// Design Name: 
// Module Name: barrel_shifter
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

module rotate_right #(
    // signal is `width` bits wide
    parameter width = 8
) (
    input wire [width-1:0] d,
    output wire [width-1:0] d_out
);
    // reassign the rightmost bit to the leftmost side via 
    // the concatenation operator { }.
    assign d_out = { d[0], d[width-1:1] };
endmodule

module rotate_left #(
    // signal is `width` bits wide
    parameter width = 8
) (
    input wire [width-1:0] d,
    output wire [width-1:0] d_out
);
    // reassign the leftmost bit to the right most side via 
    // the concatenation operator { }.
    assign d_out = { d[width-2:0], d[width-1] };
endmodule

module two_to_one_mux #(
    parameter width = 8
) (
    input wire [width-1:0] d,
    input wire sel,
    output wire [width-1:0] d_out
);
    // two wires going into mux
    wire [width-1:0] ror, rol;
    
    // 2-to-1 mux
    rotate_right #(width) rotate_right_inst (.d(d), .d_out(ror));
    rotate_left #(width) rotate_left_inst (.d(d), .d_out(rol));
    
    // output dependent on sel: 1->ror, 0->rol
    assign d_out = sel ? ror : rol;
endmodule


module barrel_shifter #(
    parameter width = 8
) (
    input wire [width-1:0] d,
    input wire sel,
    output wire [width-1:0] d_out
);

    two_to_one_mux #(width) lr_rotator_inst (.d(d), .sel(sel), .d_out(d_out));
endmodule
