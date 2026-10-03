`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2025 03:08:11 PM
// Design Name: 
// Module Name: uart_experiment
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


module uart_experiment(
    input wire CLK100MHZ, reset,
    input wire ja0,
    output wire ja1,
    input wire [3:0] sw,
    input wire send_btn,     
    output wire [5:2] led    
    );
    
    // signal declaration
    wire wr_uart, rd_uart;
    wire tx_full, rx_empty;
    wire [7:0] w_data, r_data;
        
    // send
    assign w_data = {sw[3:0], sw[3:0]};
    assign wr_uart = send_btn;
    
    // receive
    assign rd_uart = ~rx_empty;
    assign led = r_data[3:0];
    
    uart  
    #(
        .DBIT(8),
        .SB_TICK(16),
        .DVSR(326),      // 19200 baud @ 100 MHz clock
        .DVSR_BIT(9),
        .FIFO_W(2)
    ) dut (
        .clk(CLK100MHZ),
        .reset(reset),
        .rd_uart(rd_uart),
        .wr_uart(wr_uart),
        .rx(ja0),
        .w_data(w_data),
        .tx_full(tx_full),
        .rx_empty(rx_empty),
        .tx(ja1),
        .r_data(r_data)
    );

endmodule
