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


module full_uart #(
    // --------------- PARAMETERS --------------- 
    
    // BAUD RATE - 4 CONTROL SIGNALS
    //parameter baud_rate = 2'b00; // 4800 baud
    parameter baud_rate = 2'b01, // 9600 baud
    //parameter baud_rate = 2'b10; // 19200 baud
    //parameter baud_rate = 2'b11; // 115200 baud
    
    // NUMBER OF DATA BITS - 1 CONTROL SIGNAL
    //parameter data_num = 1'b0; // SEVEN DATA BITS
    parameter data_num = 1'b1, // EIGHT DATA BITS
    
    // NUMBER OF STOP BITS - 1 CONTROL SIGNAL
    parameter stop_num = 1'b0, // ONE STOP BIT
    //parameter stop_num = 1'b1; // TWO STOP BITS
    
    // TYPE OF PARITY 
    parameter parity = 2'b00, // NO PARITY
    //parameter parity = 2'b01; // EVEN PARITY
    //parameter parity = 2'b10; // ODD PARITY
    
    // MISCELLANEOUS
    // IO buffer
    FIFO_W = 2 // address bits for buffer
    
    // ------------- END PARAMETERS ------------- 
    )(
    input wire clk, reset,
    input wire rd_uart, wr_uart, 
    input wire rx,
    input wire [DBIT-1:0] w_data,
    output wire tx_full, rx_empty, rx_full,
    output wire tx,
    output wire [DBIT-1:0] r_data,
    output wire [2:0] err
    );
    
    // ---- BAUD RATE (for 100 MHZ clock) ---- 
    parameter DVSR_BIT = 11; // number N : 2^N > 1302
    parameter DVSR    = (baud_rate == 2'b00) ? 1302 :   // 4800 baud
                        (baud_rate == 2'b01) ? 651  :   // 9600 baud
                        (baud_rate == 2'b10) ? 326  :   // 19200 baud
                        (baud_rate == 2'b11) ? 54   :   // 115200 baud
                        326;     // default 9600 bauds
                         
    parameter DBIT    = (data_num == 1'b0) ? 7 : 
                        8;       // default 8 data bits
    
    parameter SB_TICK = (stop_num == 1'b0) ? 16 :
                        (stop_num == 1'b1) ? 32 :
                        16;      // default 1 stop bit
    

    // signal declaration
    wire tick, rx_done_tick, tx_done_tick;
    wire tx_empty, tx_fifo_not_empty;
    wire [DBIT-1:0] tx_fifo_out, rx_data_out;

    // body
    mod_m_counter #(.M(DVSR), .N(DVSR_BIT)) baud_gen_unit 
        (.clk(clk), .reset(reset), .q(), .max_tick(tick));

    uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK), .PARITY(parity)) uart_rx_unit
        (.clk(clk), .reset(reset), .rx(rx), .s_tick(tick),
         .rx_done_tick(rx_done_tick), .dout(rx_data_out),
         .parity_err(err[2]), .frame_err(err[1]));

    fifo #(.B(DBIT), .W(FIFO_W)) fifo_rx_unit
        (.clk(clk), .reset(reset), .rd(rd_uart),
         .wr(rx_done_tick), .w_data(rx_data_out),
         .empty(rx_empty), .full(rx_full), .r_data(r_data));     

    fifo #(.B(DBIT), .W(FIFO_W)) fifo_tx_unit
        (.clk(clk), .reset(reset), .rd(tx_done_tick),
         .wr(wr_uart), .w_data(w_data), .empty(tx_empty), 
         .full(tx_full), .r_data(tx_fifo_out));

    uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK), .PARITY(parity)) uart_tx_unit
        (.clk(clk), .reset(reset), .tx_start(tx_fifo_not_empty),
         .s_tick(tick), .din(tx_fifo_out),
         .tx_done_tick(tx_done_tick), .tx(tx));

    assign err[0] = rx_full & rx_done_tick; 
    assign tx_fifo_not_empty = ~tx_empty;

endmodule

