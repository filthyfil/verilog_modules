`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2025
// Design Name: UART Loopback Testbench
// Module Name: testbench
// Description: Functional testbench for uart_experiment. Verifies TX→RX loopback
//              and LED output display of received data.
// 
//////////////////////////////////////////////////////////////////////////////////

module testbench;

    // Clock and control
    reg CLK100MHZ = 0;
    reg reset = 0;
    reg send_btn = 0;
    reg [3:0] sw = 4'h3;

    // DUT outputs
    wire [5:2] led;
    wire ja1;  // TX
    wire ja0;  // RX (looped back)

    // Instantiate the UART experiment module
    uart_experiment dut (
        .CLK100MHZ(CLK100MHZ),
        .reset(reset),
        .ja0(ja0),
        .ja1(ja1),
        .sw(sw),
        .send_btn(send_btn),
        .led(led)
    );

    // Generate 100 MHz clock (period = 10 ns)
    always #5 CLK100MHZ = ~CLK100MHZ;

    // Internal UART loopback
    assign ja0 = ja1;

    // Monitor LED output
    initial begin
        $display("Time (ns)\tLED[5:2]\tSW\tTX\tRX");
        $monitor("%0t\t%b\t%h\t%b\t%b", $time, led, sw, ja1, ja0);
    end

    // Test sequence
    initial begin
        // Apply reset
        reset = 1;
        #200;
        reset = 0;
        #1000;  // allow UART to stabilize

        // ---- Send first nibble (3) ----
        sw = 4'h3;
        @(posedge CLK100MHZ); send_btn = 1;
        @(posedge CLK100MHZ); send_btn = 0;
        #600000;  // wait one UART frame (~520 µs)

        // ---- Send second nibble (A) ----
        sw = 4'hA;
        @(posedge CLK100MHZ); send_btn = 1;
        @(posedge CLK100MHZ); send_btn = 0;
        #600000;

        // ---- Send third nibble (B) ----
        sw = 4'hB;
        @(posedge CLK100MHZ); send_btn = 1;
        @(posedge CLK100MHZ); send_btn = 0;
        #600000;

        // End simulation
        $finish;
    end

endmodule
