`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2025 10:46:31 AM
// Design Name: 
// Module Name: uart_test
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


module uart_test(
    output wire led0_r, led0_g, led0_b,
    output wire led1_r, led1_g, led1_b,


    input wire CLK100MHZ, reset,
    input wire uart_rxd_out,
    input wire btn,
    output wire uart_txd_in,
    output wire [5:2] led 
    );
    
    

    // signal declaration
    wire tx_full, rx_empty, btn_tick;
    wire [7:0] rec_data, rec_data1;
    wire tick, rx_done_tick;
    
    
    
    // body
    // instantiate uart
    uart uart_unit
        (.clk(CLK100MHZ), 
         .reset(reset), 
         .rd_uart(btn_tick),
         .wr_uart(btn_tick), 
         .rx(uart_rxd_out), 
         .w_data(rec_data1),
         .tx_full(tx_full), 
         .rx_empty(rx_empty),
         .r_data(rec_data), 
         .tx(uart_txd_in));
        
    // instantiate debounce circuit
    debounce btn_db_unit
        (.clk(CLK100MHZ), 
         .reset(reset), 
         .sw(btn),
         .db(btn_tick));
        
    // incremented data loops back
    assign rec_data1 = rec_data + 1;
    
    // led display 
    assign led = rec_data[3:0];
    
    assign led0_r = ~rx_empty;         // ON = FIFO has data
    assign led0_g = tick;              // Blinks at baud rate
    assign led0_b = uart_rxd_out;      // Mirrors raw RX input line

    assign led1_r = btn_tick;          // ON when button debounced
    assign led1_g = rx_done_tick;      // Pulse when full byte received
    assign led1_b = rec_data[0];       // LSB of last received byte

endmodule
