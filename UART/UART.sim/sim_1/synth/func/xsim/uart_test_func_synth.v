// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
// Date        : Tue Oct 28 12:50:32 2025
// Host        : computer running 64-bit Ubuntu 22.04.5 LTS
// Command     : write_verilog -mode funcsim -nolib -force -file
//               /home/filthyfil/FPGA/UART/UART.sim/sim_1/synth/func/xsim/uart_test_func_synth.v
// Design      : uart_test
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s50csga324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module debounce
   (\FSM_sequential_state_reg_reg[2]_0 ,
    state_reg,
    \FSM_sequential_state_reg_reg[0]_0 ,
    \FSM_sequential_state_reg_reg[2]_1 ,
    full_reg_reg,
    CLK100MHZ_IBUF_BUFG,
    rx_done_tick,
    rx_empty,
    r_ptr_reg,
    \w_ptr_reg_reg[0] ,
    tx_full,
    w_ptr_reg,
    btn_IBUF,
    AR);
  output \FSM_sequential_state_reg_reg[2]_0 ;
  output [2:0]state_reg;
  output \FSM_sequential_state_reg_reg[0]_0 ;
  output \FSM_sequential_state_reg_reg[2]_1 ;
  output full_reg_reg;
  input CLK100MHZ_IBUF_BUFG;
  input rx_done_tick;
  input rx_empty;
  input [0:0]r_ptr_reg;
  input \w_ptr_reg_reg[0] ;
  input tx_full;
  input [0:0]w_ptr_reg;
  input [0:0]btn_IBUF;
  input [0:0]AR;

  wire [0:0]AR;
  wire CLK100MHZ_IBUF_BUFG;
  wire \FSM_sequential_state_reg[0]_i_1__1_n_0 ;
  wire \FSM_sequential_state_reg[1]_i_1__1_n_0 ;
  wire \FSM_sequential_state_reg[2]_i_1_n_0 ;
  wire \FSM_sequential_state_reg[2]_i_2_n_0 ;
  wire \FSM_sequential_state_reg[2]_i_3_n_0 ;
  wire \FSM_sequential_state_reg[2]_i_4_n_0 ;
  wire \FSM_sequential_state_reg[2]_i_5_n_0 ;
  wire \FSM_sequential_state_reg[2]_i_6_n_0 ;
  wire \FSM_sequential_state_reg[2]_i_7_n_0 ;
  wire \FSM_sequential_state_reg[2]_i_8_n_0 ;
  wire \FSM_sequential_state_reg_reg[0]_0 ;
  wire \FSM_sequential_state_reg_reg[2]_0 ;
  wire \FSM_sequential_state_reg_reg[2]_1 ;
  wire [0:0]btn_IBUF;
  wire full_reg_reg;
  wire \q_reg[0]_i_2_n_0 ;
  wire [19:0]q_reg_reg;
  wire \q_reg_reg[0]_i_1_n_0 ;
  wire \q_reg_reg[0]_i_1_n_1 ;
  wire \q_reg_reg[0]_i_1_n_2 ;
  wire \q_reg_reg[0]_i_1_n_3 ;
  wire \q_reg_reg[0]_i_1_n_4 ;
  wire \q_reg_reg[0]_i_1_n_5 ;
  wire \q_reg_reg[0]_i_1_n_6 ;
  wire \q_reg_reg[0]_i_1_n_7 ;
  wire \q_reg_reg[12]_i_1_n_0 ;
  wire \q_reg_reg[12]_i_1_n_1 ;
  wire \q_reg_reg[12]_i_1_n_2 ;
  wire \q_reg_reg[12]_i_1_n_3 ;
  wire \q_reg_reg[12]_i_1_n_4 ;
  wire \q_reg_reg[12]_i_1_n_5 ;
  wire \q_reg_reg[12]_i_1_n_6 ;
  wire \q_reg_reg[12]_i_1_n_7 ;
  wire \q_reg_reg[16]_i_1_n_1 ;
  wire \q_reg_reg[16]_i_1_n_2 ;
  wire \q_reg_reg[16]_i_1_n_3 ;
  wire \q_reg_reg[16]_i_1_n_4 ;
  wire \q_reg_reg[16]_i_1_n_5 ;
  wire \q_reg_reg[16]_i_1_n_6 ;
  wire \q_reg_reg[16]_i_1_n_7 ;
  wire \q_reg_reg[4]_i_1_n_0 ;
  wire \q_reg_reg[4]_i_1_n_1 ;
  wire \q_reg_reg[4]_i_1_n_2 ;
  wire \q_reg_reg[4]_i_1_n_3 ;
  wire \q_reg_reg[4]_i_1_n_4 ;
  wire \q_reg_reg[4]_i_1_n_5 ;
  wire \q_reg_reg[4]_i_1_n_6 ;
  wire \q_reg_reg[4]_i_1_n_7 ;
  wire \q_reg_reg[8]_i_1_n_0 ;
  wire \q_reg_reg[8]_i_1_n_1 ;
  wire \q_reg_reg[8]_i_1_n_2 ;
  wire \q_reg_reg[8]_i_1_n_3 ;
  wire \q_reg_reg[8]_i_1_n_4 ;
  wire \q_reg_reg[8]_i_1_n_5 ;
  wire \q_reg_reg[8]_i_1_n_6 ;
  wire \q_reg_reg[8]_i_1_n_7 ;
  wire [0:0]r_ptr_reg;
  wire rx_done_tick;
  wire rx_empty;
  wire [2:0]state_reg;
  wire tx_full;
  wire [0:0]w_ptr_reg;
  wire \w_ptr_reg_reg[0] ;
  wire [3:3]\NLW_q_reg_reg[16]_i_1_CO_UNCONNECTED ;

  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hF3FFD2C0)) 
    \FSM_sequential_state_reg[0]_i_1__1 
       (.I0(\FSM_sequential_state_reg[2]_i_2_n_0 ),
        .I1(state_reg[2]),
        .I2(state_reg[0]),
        .I3(state_reg[1]),
        .I4(btn_IBUF),
        .O(\FSM_sequential_state_reg[0]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hCC00DF30)) 
    \FSM_sequential_state_reg[1]_i_1__1 
       (.I0(\FSM_sequential_state_reg[2]_i_2_n_0 ),
        .I1(state_reg[2]),
        .I2(state_reg[0]),
        .I3(state_reg[1]),
        .I4(btn_IBUF),
        .O(\FSM_sequential_state_reg[1]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hCCC0ECC4)) 
    \FSM_sequential_state_reg[2]_i_1 
       (.I0(\FSM_sequential_state_reg[2]_i_2_n_0 ),
        .I1(state_reg[2]),
        .I2(state_reg[0]),
        .I3(state_reg[1]),
        .I4(btn_IBUF),
        .O(\FSM_sequential_state_reg[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \FSM_sequential_state_reg[2]_i_2 
       (.I0(\FSM_sequential_state_reg[2]_i_3_n_0 ),
        .I1(\FSM_sequential_state_reg[2]_i_4_n_0 ),
        .I2(\FSM_sequential_state_reg[2]_i_5_n_0 ),
        .I3(\FSM_sequential_state_reg[2]_i_6_n_0 ),
        .I4(\FSM_sequential_state_reg[2]_i_7_n_0 ),
        .I5(\FSM_sequential_state_reg[2]_i_8_n_0 ),
        .O(\FSM_sequential_state_reg[2]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_sequential_state_reg[2]_i_3 
       (.I0(q_reg_reg[11]),
        .I1(q_reg_reg[12]),
        .I2(q_reg_reg[10]),
        .I3(q_reg_reg[13]),
        .O(\FSM_sequential_state_reg[2]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_sequential_state_reg[2]_i_4 
       (.I0(q_reg_reg[14]),
        .I1(q_reg_reg[19]),
        .I2(q_reg_reg[16]),
        .I3(q_reg_reg[17]),
        .O(\FSM_sequential_state_reg[2]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \FSM_sequential_state_reg[2]_i_5 
       (.I0(q_reg_reg[18]),
        .I1(q_reg_reg[15]),
        .O(\FSM_sequential_state_reg[2]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_sequential_state_reg[2]_i_6 
       (.I0(q_reg_reg[2]),
        .I1(q_reg_reg[3]),
        .I2(q_reg_reg[1]),
        .I3(q_reg_reg[0]),
        .O(\FSM_sequential_state_reg[2]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_sequential_state_reg[2]_i_7 
       (.I0(q_reg_reg[5]),
        .I1(q_reg_reg[8]),
        .I2(q_reg_reg[6]),
        .I3(q_reg_reg[9]),
        .O(\FSM_sequential_state_reg[2]_i_7_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \FSM_sequential_state_reg[2]_i_8 
       (.I0(q_reg_reg[4]),
        .I1(q_reg_reg[7]),
        .O(\FSM_sequential_state_reg[2]_i_8_n_0 ));
  (* FSM_ENCODED_STATES = "wait0_1:010,wait0_2:011,wait0_3:100,zero:000,one:001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\FSM_sequential_state_reg[0]_i_1__1_n_0 ),
        .Q(state_reg[0]));
  (* FSM_ENCODED_STATES = "wait0_1:010,wait0_2:011,wait0_3:100,zero:000,one:001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\FSM_sequential_state_reg[1]_i_1__1_n_0 ),
        .Q(state_reg[1]));
  (* FSM_ENCODED_STATES = "wait0_1:010,wait0_2:011,wait0_3:100,zero:000,one:001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg_reg[2] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\FSM_sequential_state_reg[2]_i_1_n_0 ),
        .Q(state_reg[2]));
  LUT4 #(
    .INIT(16'h0154)) 
    array_reg_reg_0_3_0_5_i_1__0
       (.I0(tx_full),
        .I1(state_reg[0]),
        .I2(state_reg[1]),
        .I3(state_reg[2]),
        .O(full_reg_reg));
  LUT1 #(
    .INIT(2'h1)) 
    \q_reg[0]_i_2 
       (.I0(q_reg_reg[0]),
        .O(\q_reg[0]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[0]_i_1_n_7 ),
        .Q(q_reg_reg[0]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "11" *) 
  CARRY4 \q_reg_reg[0]_i_1 
       (.CI(1'b0),
        .CO({\q_reg_reg[0]_i_1_n_0 ,\q_reg_reg[0]_i_1_n_1 ,\q_reg_reg[0]_i_1_n_2 ,\q_reg_reg[0]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\q_reg_reg[0]_i_1_n_4 ,\q_reg_reg[0]_i_1_n_5 ,\q_reg_reg[0]_i_1_n_6 ,\q_reg_reg[0]_i_1_n_7 }),
        .S({q_reg_reg[3:1],\q_reg[0]_i_2_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[10] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[8]_i_1_n_5 ),
        .Q(q_reg_reg[10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[11] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[8]_i_1_n_4 ),
        .Q(q_reg_reg[11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[12] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[12]_i_1_n_7 ),
        .Q(q_reg_reg[12]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "11" *) 
  CARRY4 \q_reg_reg[12]_i_1 
       (.CI(\q_reg_reg[8]_i_1_n_0 ),
        .CO({\q_reg_reg[12]_i_1_n_0 ,\q_reg_reg[12]_i_1_n_1 ,\q_reg_reg[12]_i_1_n_2 ,\q_reg_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\q_reg_reg[12]_i_1_n_4 ,\q_reg_reg[12]_i_1_n_5 ,\q_reg_reg[12]_i_1_n_6 ,\q_reg_reg[12]_i_1_n_7 }),
        .S(q_reg_reg[15:12]));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[13] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[12]_i_1_n_6 ),
        .Q(q_reg_reg[13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[14] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[12]_i_1_n_5 ),
        .Q(q_reg_reg[14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[15] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[12]_i_1_n_4 ),
        .Q(q_reg_reg[15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[16] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[16]_i_1_n_7 ),
        .Q(q_reg_reg[16]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "11" *) 
  CARRY4 \q_reg_reg[16]_i_1 
       (.CI(\q_reg_reg[12]_i_1_n_0 ),
        .CO({\NLW_q_reg_reg[16]_i_1_CO_UNCONNECTED [3],\q_reg_reg[16]_i_1_n_1 ,\q_reg_reg[16]_i_1_n_2 ,\q_reg_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\q_reg_reg[16]_i_1_n_4 ,\q_reg_reg[16]_i_1_n_5 ,\q_reg_reg[16]_i_1_n_6 ,\q_reg_reg[16]_i_1_n_7 }),
        .S(q_reg_reg[19:16]));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[17] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[16]_i_1_n_6 ),
        .Q(q_reg_reg[17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[18] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[16]_i_1_n_5 ),
        .Q(q_reg_reg[18]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[19] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[16]_i_1_n_4 ),
        .Q(q_reg_reg[19]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[0]_i_1_n_6 ),
        .Q(q_reg_reg[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[2] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[0]_i_1_n_5 ),
        .Q(q_reg_reg[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[3] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[0]_i_1_n_4 ),
        .Q(q_reg_reg[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[4] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[4]_i_1_n_7 ),
        .Q(q_reg_reg[4]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "11" *) 
  CARRY4 \q_reg_reg[4]_i_1 
       (.CI(\q_reg_reg[0]_i_1_n_0 ),
        .CO({\q_reg_reg[4]_i_1_n_0 ,\q_reg_reg[4]_i_1_n_1 ,\q_reg_reg[4]_i_1_n_2 ,\q_reg_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\q_reg_reg[4]_i_1_n_4 ,\q_reg_reg[4]_i_1_n_5 ,\q_reg_reg[4]_i_1_n_6 ,\q_reg_reg[4]_i_1_n_7 }),
        .S(q_reg_reg[7:4]));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[5] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[4]_i_1_n_6 ),
        .Q(q_reg_reg[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[6] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[4]_i_1_n_5 ),
        .Q(q_reg_reg[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[7] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[4]_i_1_n_4 ),
        .Q(q_reg_reg[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[8] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[8]_i_1_n_7 ),
        .Q(q_reg_reg[8]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "11" *) 
  CARRY4 \q_reg_reg[8]_i_1 
       (.CI(\q_reg_reg[4]_i_1_n_0 ),
        .CO({\q_reg_reg[8]_i_1_n_0 ,\q_reg_reg[8]_i_1_n_1 ,\q_reg_reg[8]_i_1_n_2 ,\q_reg_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\q_reg_reg[8]_i_1_n_4 ,\q_reg_reg[8]_i_1_n_5 ,\q_reg_reg[8]_i_1_n_6 ,\q_reg_reg[8]_i_1_n_7 }),
        .S(q_reg_reg[11:8]));
  FDRE #(
    .INIT(1'b0)) 
    \q_reg_reg[9] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(\q_reg_reg[8]_i_1_n_6 ),
        .Q(q_reg_reg[9]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hA9FFA9A956005656)) 
    \r_ptr_reg[0]_i_1 
       (.I0(state_reg[2]),
        .I1(state_reg[1]),
        .I2(state_reg[0]),
        .I3(rx_done_tick),
        .I4(rx_empty),
        .I5(r_ptr_reg),
        .O(\FSM_sequential_state_reg_reg[2]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hA9)) 
    \r_ptr_reg[1]_i_2__0 
       (.I0(state_reg[2]),
        .I1(state_reg[1]),
        .I2(state_reg[0]),
        .O(\FSM_sequential_state_reg_reg[2]_1 ));
  LUT6 #(
    .INIT(64'hFFE1E1E1001E1E1E)) 
    \w_ptr_reg[0]_i_1__0 
       (.I0(state_reg[0]),
        .I1(state_reg[1]),
        .I2(state_reg[2]),
        .I3(\w_ptr_reg_reg[0] ),
        .I4(tx_full),
        .I5(w_ptr_reg),
        .O(\FSM_sequential_state_reg_reg[0]_0 ));
endmodule

module fifo
   (ADDRC,
    empty_reg_reg_0,
    full_reg_reg_0,
    led_OBUF,
    sseg_OBUF,
    w_data,
    CLK100MHZ_IBUF_BUFG,
    AR,
    \r_ptr_reg_reg[0]_0 ,
    Q,
    \led[1] ,
    state_reg_0,
    \r_ptr_reg_reg[1]_0 ,
    full_reg_reg_1,
    full_reg_reg_2,
    empty_reg_reg_1,
    state_reg);
  output [0:0]ADDRC;
  output empty_reg_reg_0;
  output full_reg_reg_0;
  output [7:0]led_OBUF;
  output [0:0]sseg_OBUF;
  output [7:0]w_data;
  input CLK100MHZ_IBUF_BUFG;
  input [0:0]AR;
  input \r_ptr_reg_reg[0]_0 ;
  input [7:0]Q;
  input \led[1] ;
  input [0:0]state_reg_0;
  input \r_ptr_reg_reg[1]_0 ;
  input full_reg_reg_1;
  input full_reg_reg_2;
  input empty_reg_reg_1;
  input [2:0]state_reg;

  wire [0:0]ADDRC;
  wire [0:0]AR;
  wire CLK100MHZ_IBUF_BUFG;
  wire [7:0]Q;
  wire array_reg_reg_0_3_6_7_i_2_n_0;
  wire empty_reg_i_1_n_0;
  wire empty_reg_i_3_n_0;
  wire empty_reg_reg_0;
  wire empty_reg_reg_1;
  wire full_reg_i_1_n_0;
  wire full_reg_i_2_n_0;
  wire full_reg_reg_0;
  wire full_reg_reg_1;
  wire full_reg_reg_2;
  wire \led[1] ;
  wire [7:0]led_OBUF;
  wire [1:1]r_ptr_reg;
  wire \r_ptr_reg[1]_i_1_n_0 ;
  wire \r_ptr_reg_reg[0]_0 ;
  wire \r_ptr_reg_reg[1]_0 ;
  wire [0:0]sseg_OBUF;
  wire [2:0]state_reg;
  wire [0:0]state_reg_0;
  wire [7:0]w_data;
  wire [1:0]w_ptr_reg;
  wire \w_ptr_reg[0]_i_1_n_0 ;
  wire \w_ptr_reg[1]_i_1_n_0 ;
  wire [1:0]NLW_array_reg_reg_0_3_0_5_DOD_UNCONNECTED;
  wire NLW_array_reg_reg_0_3_6_7_SPO_UNCONNECTED;
  wire NLW_array_reg_reg_0_3_6_7__0_SPO_UNCONNECTED;

  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "32" *) 
  (* RTL_RAM_NAME = "uart_test/uart_unit/fifo_rx_unit/array_reg_reg" *) 
  (* RTL_RAM_STYLE = "auto" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "3" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "5" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    array_reg_reg_0_3_0_5
       (.ADDRA({1'b0,1'b0,1'b0,r_ptr_reg,ADDRC}),
        .ADDRB({1'b0,1'b0,1'b0,r_ptr_reg,ADDRC}),
        .ADDRC({1'b0,1'b0,1'b0,r_ptr_reg,ADDRC}),
        .ADDRD({1'b0,1'b0,1'b0,w_ptr_reg}),
        .DIA(Q[1:0]),
        .DIB(Q[3:2]),
        .DIC(Q[5:4]),
        .DID({1'b0,1'b0}),
        .DOA(led_OBUF[1:0]),
        .DOB(led_OBUF[3:2]),
        .DOC(led_OBUF[5:4]),
        .DOD(NLW_array_reg_reg_0_3_0_5_DOD_UNCONNECTED[1:0]),
        .WCLK(CLK100MHZ_IBUF_BUFG),
        .WE(\led[1] ));
  LUT2 #(
    .INIT(4'h6)) 
    array_reg_reg_0_3_0_5_i_2
       (.I0(led_OBUF[0]),
        .I1(led_OBUF[1]),
        .O(w_data[1]));
  LUT1 #(
    .INIT(2'h1)) 
    array_reg_reg_0_3_0_5_i_3
       (.I0(led_OBUF[0]),
        .O(w_data[0]));
  LUT4 #(
    .INIT(16'h7F80)) 
    array_reg_reg_0_3_0_5_i_4
       (.I0(led_OBUF[1]),
        .I1(led_OBUF[0]),
        .I2(led_OBUF[2]),
        .I3(led_OBUF[3]),
        .O(w_data[3]));
  LUT3 #(
    .INIT(8'h78)) 
    array_reg_reg_0_3_0_5_i_5
       (.I0(led_OBUF[0]),
        .I1(led_OBUF[1]),
        .I2(led_OBUF[2]),
        .O(w_data[2]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    array_reg_reg_0_3_0_5_i_6
       (.I0(led_OBUF[3]),
        .I1(led_OBUF[1]),
        .I2(led_OBUF[0]),
        .I3(led_OBUF[2]),
        .I4(led_OBUF[4]),
        .I5(led_OBUF[5]),
        .O(w_data[5]));
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    array_reg_reg_0_3_0_5_i_7
       (.I0(led_OBUF[2]),
        .I1(led_OBUF[0]),
        .I2(led_OBUF[1]),
        .I3(led_OBUF[3]),
        .I4(led_OBUF[4]),
        .O(w_data[4]));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "32" *) 
  (* RTL_RAM_NAME = "uart_test/uart_unit/fifo_rx_unit/array_reg_reg_0_3_6_7" *) 
  (* RTL_RAM_STYLE = "NONE" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "3" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "6" *) 
  (* ram_slice_end = "6" *) 
  RAM32X1D #(
    .INIT(32'h00000000)) 
    array_reg_reg_0_3_6_7
       (.A0(w_ptr_reg[0]),
        .A1(w_ptr_reg[1]),
        .A2(1'b0),
        .A3(1'b0),
        .A4(1'b0),
        .D(Q[6]),
        .DPO(led_OBUF[6]),
        .DPRA0(ADDRC),
        .DPRA1(r_ptr_reg),
        .DPRA2(1'b0),
        .DPRA3(1'b0),
        .DPRA4(1'b0),
        .SPO(NLW_array_reg_reg_0_3_6_7_SPO_UNCONNECTED),
        .WCLK(CLK100MHZ_IBUF_BUFG),
        .WE(\led[1] ));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "32" *) 
  (* RTL_RAM_NAME = "uart_test/uart_unit/fifo_rx_unit/array_reg_reg_0_3_6_7" *) 
  (* RTL_RAM_STYLE = "NONE" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "3" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "7" *) 
  (* ram_slice_end = "7" *) 
  RAM32X1D #(
    .INIT(32'h00000000)) 
    array_reg_reg_0_3_6_7__0
       (.A0(w_ptr_reg[0]),
        .A1(w_ptr_reg[1]),
        .A2(1'b0),
        .A3(1'b0),
        .A4(1'b0),
        .D(Q[7]),
        .DPO(led_OBUF[7]),
        .DPRA0(ADDRC),
        .DPRA1(r_ptr_reg),
        .DPRA2(1'b0),
        .DPRA3(1'b0),
        .DPRA4(1'b0),
        .SPO(NLW_array_reg_reg_0_3_6_7__0_SPO_UNCONNECTED),
        .WCLK(CLK100MHZ_IBUF_BUFG),
        .WE(\led[1] ));
  LUT3 #(
    .INIT(8'h78)) 
    array_reg_reg_0_3_6_7__0_i_1
       (.I0(array_reg_reg_0_3_6_7_i_2_n_0),
        .I1(led_OBUF[6]),
        .I2(led_OBUF[7]),
        .O(w_data[7]));
  LUT2 #(
    .INIT(4'h6)) 
    array_reg_reg_0_3_6_7_i_1
       (.I0(array_reg_reg_0_3_6_7_i_2_n_0),
        .I1(led_OBUF[6]),
        .O(w_data[6]));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    array_reg_reg_0_3_6_7_i_2
       (.I0(led_OBUF[5]),
        .I1(led_OBUF[3]),
        .I2(led_OBUF[1]),
        .I3(led_OBUF[0]),
        .I4(led_OBUF[2]),
        .I5(led_OBUF[4]),
        .O(array_reg_reg_0_3_6_7_i_2_n_0));
  LUT6 #(
    .INIT(64'hDFCFFFFF10000D00)) 
    empty_reg_i_1
       (.I0(full_reg_reg_2),
        .I1(full_reg_reg_0),
        .I2(empty_reg_reg_1),
        .I3(empty_reg_i_3_n_0),
        .I4(full_reg_reg_1),
        .I5(empty_reg_reg_0),
        .O(empty_reg_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'h4128)) 
    empty_reg_i_3
       (.I0(ADDRC),
        .I1(r_ptr_reg),
        .I2(w_ptr_reg[1]),
        .I3(w_ptr_reg[0]),
        .O(empty_reg_i_3_n_0));
  FDPE #(
    .INIT(1'b1)) 
    empty_reg_reg
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(empty_reg_i_1_n_0),
        .PRE(AR),
        .Q(empty_reg_reg_0));
  LUT6 #(
    .INIT(64'hFCF0F8F0F0F0F088)) 
    full_reg_i_1
       (.I0(full_reg_reg_2),
        .I1(full_reg_i_2_n_0),
        .I2(full_reg_reg_0),
        .I3(empty_reg_reg_1),
        .I4(empty_reg_reg_0),
        .I5(full_reg_reg_1),
        .O(full_reg_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'h0960)) 
    full_reg_i_2
       (.I0(r_ptr_reg),
        .I1(w_ptr_reg[1]),
        .I2(w_ptr_reg[0]),
        .I3(ADDRC),
        .O(full_reg_i_2_n_0));
  FDCE #(
    .INIT(1'b0)) 
    full_reg_reg
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(full_reg_i_1_n_0),
        .Q(full_reg_reg_0));
  LUT6 #(
    .INIT(64'hFFFFDD5D000022A2)) 
    \r_ptr_reg[1]_i_1 
       (.I0(ADDRC),
        .I1(empty_reg_reg_0),
        .I2(state_reg_0),
        .I3(\r_ptr_reg_reg[1]_0 ),
        .I4(full_reg_reg_1),
        .I5(r_ptr_reg),
        .O(\r_ptr_reg[1]_i_1_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \r_ptr_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\r_ptr_reg_reg[0]_0 ),
        .Q(ADDRC));
  FDCE #(
    .INIT(1'b0)) 
    \r_ptr_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\r_ptr_reg[1]_i_1_n_0 ),
        .Q(r_ptr_reg));
  LUT1 #(
    .INIT(2'h1)) 
    \sseg_OBUF[3]_inst_i_1 
       (.I0(empty_reg_reg_0),
        .O(sseg_OBUF));
  LUT6 #(
    .INIT(64'hFD57555502A8AAAA)) 
    \w_ptr_reg[0]_i_1 
       (.I0(full_reg_reg_2),
        .I1(state_reg[0]),
        .I2(state_reg[1]),
        .I3(state_reg[2]),
        .I4(full_reg_reg_0),
        .I5(w_ptr_reg[0]),
        .O(\w_ptr_reg[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFD5FF00002A00)) 
    \w_ptr_reg[1]_i_1 
       (.I0(w_ptr_reg[0]),
        .I1(full_reg_reg_0),
        .I2(full_reg_reg_1),
        .I3(state_reg_0),
        .I4(\r_ptr_reg_reg[1]_0 ),
        .I5(w_ptr_reg[1]),
        .O(\w_ptr_reg[1]_i_1_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \w_ptr_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\w_ptr_reg[0]_i_1_n_0 ),
        .Q(w_ptr_reg[0]));
  FDCE #(
    .INIT(1'b0)) 
    \w_ptr_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\w_ptr_reg[1]_i_1_n_0 ),
        .Q(w_ptr_reg[1]));
endmodule

(* ORIG_REF_NAME = "fifo" *) 
module fifo_0
   (ADDRD,
    tx_empty,
    full_reg_reg_0,
    \w_ptr_reg_reg[0]_0 ,
    \r_ptr_reg_reg[0]_0 ,
    sseg_OBUF,
    D,
    CLK100MHZ_IBUF_BUFG,
    AR,
    \w_ptr_reg_reg[0]_1 ,
    w_data,
    \b_reg_reg[7] ,
    \r_ptr_reg_reg[0]_1 ,
    full_reg_reg_1,
    full_reg_reg_2,
    \r_ptr_reg_reg[1]_0 ,
    \r_ptr_reg_reg[1]_1 ,
    state_reg);
  output [0:0]ADDRD;
  output tx_empty;
  output full_reg_reg_0;
  output [6:0]\w_ptr_reg_reg[0]_0 ;
  output [0:0]\r_ptr_reg_reg[0]_0 ;
  output [0:0]sseg_OBUF;
  output [0:0]D;
  input CLK100MHZ_IBUF_BUFG;
  input [0:0]AR;
  input \w_ptr_reg_reg[0]_1 ;
  input [7:0]w_data;
  input \b_reg_reg[7] ;
  input \r_ptr_reg_reg[0]_1 ;
  input full_reg_reg_1;
  input full_reg_reg_2;
  input \r_ptr_reg_reg[1]_0 ;
  input \r_ptr_reg_reg[1]_1 ;
  input [0:0]state_reg;

  wire [0:0]ADDRD;
  wire [0:0]AR;
  wire CLK100MHZ_IBUF_BUFG;
  wire [0:0]D;
  wire \b_reg_reg[7] ;
  wire empty_reg_i_1__0_n_0;
  wire empty_reg_i_2__0_n_0;
  wire full_reg_i_1__0_n_0;
  wire full_reg_i_2__0_n_0;
  wire full_reg_reg_0;
  wire full_reg_reg_1;
  wire full_reg_reg_2;
  wire [7:7]r_data;
  wire [1:1]r_ptr_reg;
  wire \r_ptr_reg[1]_i_1__0_n_0 ;
  wire [0:0]\r_ptr_reg_reg[0]_0 ;
  wire \r_ptr_reg_reg[0]_1 ;
  wire \r_ptr_reg_reg[1]_0 ;
  wire \r_ptr_reg_reg[1]_1 ;
  wire [0:0]sseg_OBUF;
  wire [0:0]state_reg;
  wire tx_empty;
  wire [7:0]w_data;
  wire [1:1]w_ptr_reg;
  wire \w_ptr_reg[1]_i_1__0_n_0 ;
  wire [6:0]\w_ptr_reg_reg[0]_0 ;
  wire \w_ptr_reg_reg[0]_1 ;
  wire [1:0]NLW_array_reg_reg_0_3_0_5_DOD_UNCONNECTED;
  wire NLW_array_reg_reg_0_3_6_7_SPO_UNCONNECTED;
  wire NLW_array_reg_reg_0_3_6_7__0_SPO_UNCONNECTED;

  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "32" *) 
  (* RTL_RAM_NAME = "uart_test/uart_unit/fifo_tx_unit/array_reg_reg" *) 
  (* RTL_RAM_STYLE = "auto" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "3" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "0" *) 
  (* ram_slice_end = "5" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    array_reg_reg_0_3_0_5
       (.ADDRA({1'b0,1'b0,1'b0,r_ptr_reg,\r_ptr_reg_reg[0]_0 }),
        .ADDRB({1'b0,1'b0,1'b0,r_ptr_reg,\r_ptr_reg_reg[0]_0 }),
        .ADDRC({1'b0,1'b0,1'b0,r_ptr_reg,\r_ptr_reg_reg[0]_0 }),
        .ADDRD({1'b0,1'b0,1'b0,w_ptr_reg,ADDRD}),
        .DIA(w_data[1:0]),
        .DIB(w_data[3:2]),
        .DIC(w_data[5:4]),
        .DID({1'b0,1'b0}),
        .DOA(\w_ptr_reg_reg[0]_0 [1:0]),
        .DOB(\w_ptr_reg_reg[0]_0 [3:2]),
        .DOC(\w_ptr_reg_reg[0]_0 [5:4]),
        .DOD(NLW_array_reg_reg_0_3_0_5_DOD_UNCONNECTED[1:0]),
        .WCLK(CLK100MHZ_IBUF_BUFG),
        .WE(\b_reg_reg[7] ));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "32" *) 
  (* RTL_RAM_NAME = "uart_test/uart_unit/fifo_tx_unit/array_reg_reg_0_3_6_7" *) 
  (* RTL_RAM_STYLE = "NONE" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "3" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "6" *) 
  (* ram_slice_end = "6" *) 
  RAM32X1D #(
    .INIT(32'h00000000)) 
    array_reg_reg_0_3_6_7
       (.A0(ADDRD),
        .A1(w_ptr_reg),
        .A2(1'b0),
        .A3(1'b0),
        .A4(1'b0),
        .D(w_data[6]),
        .DPO(\w_ptr_reg_reg[0]_0 [6]),
        .DPRA0(\r_ptr_reg_reg[0]_0 ),
        .DPRA1(r_ptr_reg),
        .DPRA2(1'b0),
        .DPRA3(1'b0),
        .DPRA4(1'b0),
        .SPO(NLW_array_reg_reg_0_3_6_7_SPO_UNCONNECTED),
        .WCLK(CLK100MHZ_IBUF_BUFG),
        .WE(\b_reg_reg[7] ));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  (* RTL_RAM_BITS = "32" *) 
  (* RTL_RAM_NAME = "uart_test/uart_unit/fifo_tx_unit/array_reg_reg_0_3_6_7" *) 
  (* RTL_RAM_STYLE = "NONE" *) 
  (* RTL_RAM_TYPE = "RAM_SDP" *) 
  (* ram_addr_begin = "0" *) 
  (* ram_addr_end = "3" *) 
  (* ram_offset = "0" *) 
  (* ram_slice_begin = "7" *) 
  (* ram_slice_end = "7" *) 
  RAM32X1D #(
    .INIT(32'h00000000)) 
    array_reg_reg_0_3_6_7__0
       (.A0(ADDRD),
        .A1(w_ptr_reg),
        .A2(1'b0),
        .A3(1'b0),
        .A4(1'b0),
        .D(w_data[7]),
        .DPO(r_data),
        .DPRA0(\r_ptr_reg_reg[0]_0 ),
        .DPRA1(r_ptr_reg),
        .DPRA2(1'b0),
        .DPRA3(1'b0),
        .DPRA4(1'b0),
        .SPO(NLW_array_reg_reg_0_3_6_7__0_SPO_UNCONNECTED),
        .WCLK(CLK100MHZ_IBUF_BUFG),
        .WE(\b_reg_reg[7] ));
  LUT2 #(
    .INIT(4'h2)) 
    \b_reg[7]_i_2 
       (.I0(r_data),
        .I1(state_reg),
        .O(D));
  LUT5 #(
    .INIT(32'hF3B0F0B0)) 
    empty_reg_i_1__0
       (.I0(full_reg_reg_0),
        .I1(full_reg_reg_1),
        .I2(tx_empty),
        .I3(full_reg_reg_2),
        .I4(empty_reg_i_2__0_n_0),
        .O(empty_reg_i_1__0_n_0));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'h4128)) 
    empty_reg_i_2__0
       (.I0(\r_ptr_reg_reg[0]_0 ),
        .I1(r_ptr_reg),
        .I2(w_ptr_reg),
        .I3(ADDRD),
        .O(empty_reg_i_2__0_n_0));
  FDPE #(
    .INIT(1'b1)) 
    empty_reg_reg
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(empty_reg_i_1__0_n_0),
        .PRE(AR),
        .Q(tx_empty));
  LUT5 #(
    .INIT(32'hCCECC0EC)) 
    full_reg_i_1__0
       (.I0(full_reg_i_2__0_n_0),
        .I1(full_reg_reg_0),
        .I2(full_reg_reg_1),
        .I3(full_reg_reg_2),
        .I4(tx_empty),
        .O(full_reg_i_1__0_n_0));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'h0960)) 
    full_reg_i_2__0
       (.I0(r_ptr_reg),
        .I1(w_ptr_reg),
        .I2(ADDRD),
        .I3(\r_ptr_reg_reg[0]_0 ),
        .O(full_reg_i_2__0_n_0));
  FDCE #(
    .INIT(1'b0)) 
    full_reg_reg
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(full_reg_i_1__0_n_0),
        .Q(full_reg_reg_0));
  LUT6 #(
    .INIT(64'hFFFFD5FF00002A00)) 
    \r_ptr_reg[1]_i_1__0 
       (.I0(\r_ptr_reg_reg[0]_0 ),
        .I1(full_reg_reg_2),
        .I2(tx_empty),
        .I3(\r_ptr_reg_reg[1]_0 ),
        .I4(\r_ptr_reg_reg[1]_1 ),
        .I5(r_ptr_reg),
        .O(\r_ptr_reg[1]_i_1__0_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \r_ptr_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\r_ptr_reg_reg[0]_1 ),
        .Q(\r_ptr_reg_reg[0]_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \r_ptr_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\r_ptr_reg[1]_i_1__0_n_0 ),
        .Q(r_ptr_reg));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \sseg_OBUF[6]_inst_i_1 
       (.I0(full_reg_reg_0),
        .O(sseg_OBUF));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'hFFD5002A)) 
    \w_ptr_reg[1]_i_1__0 
       (.I0(ADDRD),
        .I1(full_reg_reg_0),
        .I2(full_reg_reg_1),
        .I3(full_reg_reg_2),
        .I4(w_ptr_reg),
        .O(\w_ptr_reg[1]_i_1__0_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \w_ptr_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\w_ptr_reg_reg[0]_1 ),
        .Q(ADDRD));
  FDCE #(
    .INIT(1'b0)) 
    \w_ptr_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\w_ptr_reg[1]_i_1__0_n_0 ),
        .Q(w_ptr_reg));
endmodule

module mod_m_counter
   (\FSM_sequential_state_reg_reg[0] ,
    \r_reg_reg[0]_0 ,
    Q,
    \r_reg_reg[8]_0 ,
    \r_reg_reg[8]_1 ,
    \r_reg_reg[4]_0 ,
    \r_reg_reg[8]_2 ,
    \r_reg_reg[8]_3 ,
    \r_reg_reg[0]_1 ,
    \r_reg_reg[4]_1 ,
    \FSM_sequential_state_reg_reg[0]_0 ,
    state_reg,
    full_reg_reg,
    \FSM_sequential_state_reg_reg[0]_1 ,
    \FSM_sequential_state_reg_reg[0]_2 ,
    \r_ptr_reg_reg[0] ,
    array_reg_reg_0_3_6_7__0,
    CLK100MHZ_IBUF_BUFG,
    AR);
  output \FSM_sequential_state_reg_reg[0] ;
  output \r_reg_reg[0]_0 ;
  output [0:0]Q;
  output \r_reg_reg[8]_0 ;
  output \r_reg_reg[8]_1 ;
  output \r_reg_reg[4]_0 ;
  output \r_reg_reg[8]_2 ;
  output \r_reg_reg[8]_3 ;
  output \r_reg_reg[0]_1 ;
  output \r_reg_reg[4]_1 ;
  output \FSM_sequential_state_reg_reg[0]_0 ;
  input [1:0]state_reg;
  input full_reg_reg;
  input \FSM_sequential_state_reg_reg[0]_1 ;
  input \FSM_sequential_state_reg_reg[0]_2 ;
  input \r_ptr_reg_reg[0] ;
  input array_reg_reg_0_3_6_7__0;
  input CLK100MHZ_IBUF_BUFG;
  input [0:0]AR;

  wire [0:0]AR;
  wire CLK100MHZ_IBUF_BUFG;
  wire \FSM_sequential_state_reg_reg[0] ;
  wire \FSM_sequential_state_reg_reg[0]_0 ;
  wire \FSM_sequential_state_reg_reg[0]_1 ;
  wire \FSM_sequential_state_reg_reg[0]_2 ;
  wire [0:0]Q;
  wire array_reg_reg_0_3_6_7__0;
  wire full_reg_reg;
  wire [8:0]r_next;
  wire \r_ptr_reg_reg[0] ;
  wire [8:0]r_reg;
  wire \r_reg[6]_i_2_n_0 ;
  wire \r_reg[6]_i_3_n_0 ;
  wire \r_reg[8]_i_2_n_0 ;
  wire \r_reg_reg[0]_0 ;
  wire \r_reg_reg[0]_1 ;
  wire \r_reg_reg[4]_0 ;
  wire \r_reg_reg[4]_1 ;
  wire \r_reg_reg[8]_0 ;
  wire \r_reg_reg[8]_1 ;
  wire \r_reg_reg[8]_2 ;
  wire \r_reg_reg[8]_3 ;
  wire [1:0]state_reg;

  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h00000008)) 
    \FSM_sequential_state_reg[1]_i_2 
       (.I0(\FSM_sequential_state_reg_reg[0]_2 ),
        .I1(r_reg[8]),
        .I2(r_reg[1]),
        .I3(r_reg[4]),
        .I4(\r_reg_reg[0]_0 ),
        .O(\r_reg_reg[8]_1 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFDFFFF)) 
    \FSM_sequential_state_reg[1]_i_4 
       (.I0(r_reg[8]),
        .I1(r_reg[1]),
        .I2(r_reg[4]),
        .I3(\r_reg_reg[0]_0 ),
        .I4(state_reg[1]),
        .I5(\FSM_sequential_state_reg_reg[0]_1 ),
        .O(\r_reg_reg[8]_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFF7FFFFFFFF)) 
    \FSM_sequential_state_reg[1]_i_6 
       (.I0(r_reg[0]),
        .I1(Q),
        .I2(r_reg[3]),
        .I3(r_reg[7]),
        .I4(r_reg[5]),
        .I5(r_reg[6]),
        .O(\r_reg_reg[0]_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    array_reg_reg_0_3_0_5_i_1
       (.I0(\r_reg_reg[8]_0 ),
        .I1(state_reg[0]),
        .I2(array_reg_reg_0_3_6_7__0),
        .O(\FSM_sequential_state_reg_reg[0]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \n_reg[2]_i_3 
       (.I0(r_reg[8]),
        .I1(r_reg[1]),
        .I2(r_reg[4]),
        .O(\r_reg_reg[8]_3 ));
  LUT6 #(
    .INIT(64'h0000000200000000)) 
    \r_ptr_reg[0]_i_2 
       (.I0(state_reg[0]),
        .I1(full_reg_reg),
        .I2(\r_reg_reg[0]_0 ),
        .I3(r_reg[4]),
        .I4(r_reg[1]),
        .I5(r_reg[8]),
        .O(\FSM_sequential_state_reg_reg[0] ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h00000002)) 
    \r_ptr_reg[1]_i_2 
       (.I0(r_reg[8]),
        .I1(r_reg[1]),
        .I2(r_reg[4]),
        .I3(\r_reg_reg[0]_0 ),
        .I4(\r_ptr_reg_reg[0] ),
        .O(\r_reg_reg[8]_2 ));
  LUT1 #(
    .INIT(2'h1)) 
    \r_reg[0]_i_1 
       (.I0(r_reg[0]),
        .O(r_next[0]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h28)) 
    \r_reg[1]_i_1 
       (.I0(\r_reg_reg[4]_0 ),
        .I1(r_reg[1]),
        .I2(r_reg[0]),
        .O(r_next[1]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'h2A80)) 
    \r_reg[2]_i_1 
       (.I0(\r_reg_reg[4]_0 ),
        .I1(r_reg[0]),
        .I2(r_reg[1]),
        .I3(Q),
        .O(r_next[2]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \r_reg[3]_i_1 
       (.I0(r_reg[3]),
        .I1(r_reg[0]),
        .I2(Q),
        .I3(r_reg[1]),
        .O(r_next[3]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \r_reg[4]_i_1 
       (.I0(r_reg[1]),
        .I1(Q),
        .I2(r_reg[0]),
        .I3(r_reg[3]),
        .I4(r_reg[4]),
        .O(r_next[4]));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \r_reg[5]_i_1 
       (.I0(r_reg[5]),
        .I1(r_reg[1]),
        .I2(Q),
        .I3(r_reg[0]),
        .I4(r_reg[3]),
        .I5(r_reg[4]),
        .O(r_next[5]));
  LUT6 #(
    .INIT(64'h00FDFFFDFF000000)) 
    \r_reg[6]_i_1 
       (.I0(\r_reg[6]_i_2_n_0 ),
        .I1(\r_reg[6]_i_3_n_0 ),
        .I2(r_reg[7]),
        .I3(r_reg[5]),
        .I4(\r_reg[8]_i_2_n_0 ),
        .I5(r_reg[6]),
        .O(r_next[6]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    \r_reg[6]_i_2 
       (.I0(r_reg[3]),
        .I1(r_reg[4]),
        .I2(r_reg[8]),
        .I3(Q),
        .O(\r_reg[6]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \r_reg[6]_i_3 
       (.I0(r_reg[1]),
        .I1(r_reg[0]),
        .O(\r_reg[6]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h6AAA)) 
    \r_reg[7]_i_1 
       (.I0(r_reg[7]),
        .I1(r_reg[5]),
        .I2(\r_reg[8]_i_2_n_0 ),
        .I3(r_reg[6]),
        .O(r_next[7]));
  LUT6 #(
    .INIT(64'h7FFF000080008000)) 
    \r_reg[8]_i_1 
       (.I0(r_reg[7]),
        .I1(r_reg[5]),
        .I2(\r_reg[8]_i_2_n_0 ),
        .I3(r_reg[6]),
        .I4(\r_reg_reg[4]_0 ),
        .I5(r_reg[8]),
        .O(r_next[8]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \r_reg[8]_i_2 
       (.I0(r_reg[4]),
        .I1(r_reg[3]),
        .I2(r_reg[0]),
        .I3(Q),
        .I4(r_reg[1]),
        .O(\r_reg[8]_i_2_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \r_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(r_next[0]),
        .Q(r_reg[0]));
  FDCE #(
    .INIT(1'b0)) 
    \r_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(r_next[1]),
        .Q(r_reg[1]));
  FDCE #(
    .INIT(1'b0)) 
    \r_reg_reg[2] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(r_next[2]),
        .Q(Q));
  FDCE #(
    .INIT(1'b0)) 
    \r_reg_reg[3] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(r_next[3]),
        .Q(r_reg[3]));
  FDCE #(
    .INIT(1'b0)) 
    \r_reg_reg[4] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(r_next[4]),
        .Q(r_reg[4]));
  FDCE #(
    .INIT(1'b0)) 
    \r_reg_reg[5] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(r_next[5]),
        .Q(r_reg[5]));
  FDCE #(
    .INIT(1'b0)) 
    \r_reg_reg[6] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(r_next[6]),
        .Q(r_reg[6]));
  FDCE #(
    .INIT(1'b0)) 
    \r_reg_reg[7] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(r_next[7]),
        .Q(r_reg[7]));
  FDCE #(
    .INIT(1'b0)) 
    \r_reg_reg[8] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(r_next[8]),
        .Q(r_reg[8]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hFEFF)) 
    \s_reg[3]_i_4 
       (.I0(\r_reg_reg[0]_0 ),
        .I1(r_reg[4]),
        .I2(r_reg[1]),
        .I3(r_reg[8]),
        .O(\r_reg_reg[4]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \w_ptr_reg[1]_i_3 
       (.I0(r_reg[4]),
        .I1(r_reg[3]),
        .O(\r_reg_reg[4]_1 ));
  LUT6 #(
    .INIT(64'hFFFFFDFFFFFFFFFF)) 
    \w_ptr_reg[1]_i_4 
       (.I0(r_reg[0]),
        .I1(r_reg[1]),
        .I2(r_reg[7]),
        .I3(r_reg[8]),
        .I4(r_reg[5]),
        .I5(r_reg[6]),
        .O(\r_reg_reg[0]_1 ));
endmodule

module uart
   (\r_ptr_reg_reg[0] ,
    \w_ptr_reg_reg[0] ,
    tx_OBUF,
    rx_empty,
    tx_full,
    led_OBUF,
    \FSM_sequential_state_reg_reg[1] ,
    rx_done_tick,
    sseg_OBUF,
    CLK100MHZ_IBUF_BUFG,
    AR,
    \r_ptr_reg_reg[0]_0 ,
    \w_ptr_reg_reg[0]_0 ,
    \b_reg_reg[7] ,
    \r_ptr_reg_reg[0]_1 ,
    D,
    state_reg);
  output [0:0]\r_ptr_reg_reg[0] ;
  output [0:0]\w_ptr_reg_reg[0] ;
  output tx_OBUF;
  output rx_empty;
  output tx_full;
  output [7:0]led_OBUF;
  output \FSM_sequential_state_reg_reg[1] ;
  output rx_done_tick;
  output [1:0]sseg_OBUF;
  input CLK100MHZ_IBUF_BUFG;
  input [0:0]AR;
  input \r_ptr_reg_reg[0]_0 ;
  input \w_ptr_reg_reg[0]_0 ;
  input \b_reg_reg[7] ;
  input \r_ptr_reg_reg[0]_1 ;
  input [0:0]D;
  input [2:0]state_reg;

  wire [0:0]AR;
  wire CLK100MHZ_IBUF_BUFG;
  wire [0:0]D;
  wire \FSM_sequential_state_reg_reg[1] ;
  wire [7:7]b_next;
  wire \b_reg_reg[7] ;
  wire baud_gen_unit_n_1;
  wire baud_gen_unit_n_10;
  wire baud_gen_unit_n_3;
  wire baud_gen_unit_n_4;
  wire baud_gen_unit_n_5;
  wire baud_gen_unit_n_6;
  wire baud_gen_unit_n_7;
  wire baud_gen_unit_n_8;
  wire baud_gen_unit_n_9;
  wire fifo_rx_unit_n_2;
  wire [7:0]led_OBUF;
  wire [6:0]p_0_in;
  wire [6:0]r_data;
  wire [0:0]r_ptr_reg;
  wire [0:0]\r_ptr_reg_reg[0] ;
  wire \r_ptr_reg_reg[0]_0 ;
  wire \r_ptr_reg_reg[0]_1 ;
  wire [2:2]r_reg;
  wire rx_done_tick;
  wire rx_empty;
  wire [1:0]sseg_OBUF;
  wire [2:0]state_reg;
  wire [1:0]state_reg_0;
  wire [1:1]state_reg_1;
  wire tx_OBUF;
  wire tx_empty;
  wire tx_full;
  wire uart_rx_unit_n_0;
  wire uart_rx_unit_n_13;
  wire uart_rx_unit_n_3;
  wire uart_rx_unit_n_4;
  wire uart_rx_unit_n_5;
  wire uart_tx_unit_n_2;
  wire uart_tx_unit_n_4;
  wire uart_tx_unit_n_5;
  wire [7:0]w_data;
  wire [0:0]\w_ptr_reg_reg[0] ;
  wire \w_ptr_reg_reg[0]_0 ;

  mod_m_counter baud_gen_unit
       (.AR(AR),
        .CLK100MHZ_IBUF_BUFG(CLK100MHZ_IBUF_BUFG),
        .\FSM_sequential_state_reg_reg[0] (rx_done_tick),
        .\FSM_sequential_state_reg_reg[0]_0 (baud_gen_unit_n_10),
        .\FSM_sequential_state_reg_reg[0]_1 (uart_rx_unit_n_3),
        .\FSM_sequential_state_reg_reg[0]_2 (uart_rx_unit_n_0),
        .Q(r_reg),
        .array_reg_reg_0_3_6_7__0(fifo_rx_unit_n_2),
        .full_reg_reg(uart_rx_unit_n_5),
        .\r_ptr_reg_reg[0] (uart_tx_unit_n_2),
        .\r_reg_reg[0]_0 (baud_gen_unit_n_1),
        .\r_reg_reg[0]_1 (baud_gen_unit_n_8),
        .\r_reg_reg[4]_0 (baud_gen_unit_n_5),
        .\r_reg_reg[4]_1 (baud_gen_unit_n_9),
        .\r_reg_reg[8]_0 (baud_gen_unit_n_3),
        .\r_reg_reg[8]_1 (baud_gen_unit_n_4),
        .\r_reg_reg[8]_2 (baud_gen_unit_n_6),
        .\r_reg_reg[8]_3 (baud_gen_unit_n_7),
        .state_reg(state_reg_0));
  fifo fifo_rx_unit
       (.ADDRC(\r_ptr_reg_reg[0] ),
        .AR(AR),
        .CLK100MHZ_IBUF_BUFG(CLK100MHZ_IBUF_BUFG),
        .Q({p_0_in,uart_rx_unit_n_13}),
        .empty_reg_reg_0(rx_empty),
        .empty_reg_reg_1(uart_rx_unit_n_4),
        .full_reg_reg_0(fifo_rx_unit_n_2),
        .full_reg_reg_1(\r_ptr_reg_reg[0]_1 ),
        .full_reg_reg_2(rx_done_tick),
        .\led[1] (baud_gen_unit_n_10),
        .led_OBUF(led_OBUF),
        .\r_ptr_reg_reg[0]_0 (\r_ptr_reg_reg[0]_0 ),
        .\r_ptr_reg_reg[1]_0 (baud_gen_unit_n_3),
        .sseg_OBUF(sseg_OBUF[0]),
        .state_reg(state_reg),
        .state_reg_0(state_reg_0[0]),
        .w_data(w_data));
  fifo_0 fifo_tx_unit
       (.ADDRD(\w_ptr_reg_reg[0] ),
        .AR(AR),
        .CLK100MHZ_IBUF_BUFG(CLK100MHZ_IBUF_BUFG),
        .D(b_next),
        .\b_reg_reg[7] (\b_reg_reg[7] ),
        .full_reg_reg_0(tx_full),
        .full_reg_reg_1(\FSM_sequential_state_reg_reg[1] ),
        .full_reg_reg_2(\r_ptr_reg_reg[0]_1 ),
        .\r_ptr_reg_reg[0]_0 (r_ptr_reg),
        .\r_ptr_reg_reg[0]_1 (uart_tx_unit_n_5),
        .\r_ptr_reg_reg[1]_0 (baud_gen_unit_n_6),
        .\r_ptr_reg_reg[1]_1 (uart_tx_unit_n_4),
        .sseg_OBUF(sseg_OBUF[1]),
        .state_reg(state_reg_1),
        .tx_empty(tx_empty),
        .w_data(w_data),
        .\w_ptr_reg_reg[0]_0 (r_data),
        .\w_ptr_reg_reg[0]_1 (\w_ptr_reg_reg[0]_0 ));
  uart_rx uart_rx_unit
       (.AR(AR),
        .CLK100MHZ_IBUF_BUFG(CLK100MHZ_IBUF_BUFG),
        .D(D),
        .\FSM_sequential_state_reg_reg[0]_0 (uart_rx_unit_n_4),
        .\FSM_sequential_state_reg_reg[0]_1 (baud_gen_unit_n_3),
        .\FSM_sequential_state_reg_reg[0]_2 (baud_gen_unit_n_4),
        .\FSM_sequential_state_reg_reg[1]_0 (uart_rx_unit_n_0),
        .Q(r_reg),
        .\b_reg_reg[7]_0 ({p_0_in,uart_rx_unit_n_13}),
        .empty_reg_reg(baud_gen_unit_n_8),
        .empty_reg_reg_0(baud_gen_unit_n_9),
        .\n_reg_reg[0]_0 (baud_gen_unit_n_7),
        .\n_reg_reg[0]_1 (baud_gen_unit_n_1),
        .\s_reg_reg[0]_0 (baud_gen_unit_n_5),
        .\s_reg_reg[2]_0 (uart_rx_unit_n_3),
        .\s_reg_reg[3]_0 (uart_rx_unit_n_5),
        .state_reg(state_reg_0));
  uart_tx uart_tx_unit
       (.AR(AR),
        .CLK100MHZ_IBUF_BUFG(CLK100MHZ_IBUF_BUFG),
        .D(b_next),
        .\FSM_sequential_state_reg_reg[0]_0 (uart_tx_unit_n_5),
        .\FSM_sequential_state_reg_reg[1]_0 (state_reg_1),
        .\FSM_sequential_state_reg_reg[1]_1 (\FSM_sequential_state_reg_reg[1] ),
        .\FSM_sequential_state_reg_reg[1]_2 (uart_tx_unit_n_4),
        .Q(r_reg),
        .\b_reg_reg[6]_0 (r_data),
        .full_reg_reg(baud_gen_unit_n_9),
        .full_reg_reg_0(baud_gen_unit_n_8),
        .\r_ptr_reg_reg[0] (baud_gen_unit_n_6),
        .\r_ptr_reg_reg[0]_0 (\r_ptr_reg_reg[0]_1 ),
        .\r_ptr_reg_reg[0]_1 (r_ptr_reg),
        .\s_reg_reg[0]_0 (baud_gen_unit_n_5),
        .\s_reg_reg[2]_0 (uart_tx_unit_n_2),
        .tx_OBUF(tx_OBUF),
        .tx_empty(tx_empty));
endmodule

module uart_rx
   (\FSM_sequential_state_reg_reg[1]_0 ,
    state_reg,
    \s_reg_reg[2]_0 ,
    \FSM_sequential_state_reg_reg[0]_0 ,
    \s_reg_reg[3]_0 ,
    \b_reg_reg[7]_0 ,
    \n_reg_reg[0]_0 ,
    \n_reg_reg[0]_1 ,
    D,
    \s_reg_reg[0]_0 ,
    empty_reg_reg,
    Q,
    empty_reg_reg_0,
    \FSM_sequential_state_reg_reg[0]_1 ,
    \FSM_sequential_state_reg_reg[0]_2 ,
    CLK100MHZ_IBUF_BUFG,
    AR);
  output \FSM_sequential_state_reg_reg[1]_0 ;
  output [1:0]state_reg;
  output \s_reg_reg[2]_0 ;
  output \FSM_sequential_state_reg_reg[0]_0 ;
  output \s_reg_reg[3]_0 ;
  output [7:0]\b_reg_reg[7]_0 ;
  input \n_reg_reg[0]_0 ;
  input \n_reg_reg[0]_1 ;
  input [0:0]D;
  input \s_reg_reg[0]_0 ;
  input empty_reg_reg;
  input [0:0]Q;
  input empty_reg_reg_0;
  input \FSM_sequential_state_reg_reg[0]_1 ;
  input \FSM_sequential_state_reg_reg[0]_2 ;
  input CLK100MHZ_IBUF_BUFG;
  input [0:0]AR;

  wire [0:0]AR;
  wire CLK100MHZ_IBUF_BUFG;
  wire [0:0]D;
  wire \FSM_sequential_state_reg[0]_i_1_n_0 ;
  wire \FSM_sequential_state_reg[1]_i_1_n_0 ;
  wire \FSM_sequential_state_reg[1]_i_3_n_0 ;
  wire \FSM_sequential_state_reg_reg[0]_0 ;
  wire \FSM_sequential_state_reg_reg[0]_1 ;
  wire \FSM_sequential_state_reg_reg[0]_2 ;
  wire \FSM_sequential_state_reg_reg[1]_0 ;
  wire [0:0]Q;
  wire \b_reg[7]_i_1__0_n_0 ;
  wire [7:0]\b_reg_reg[7]_0 ;
  wire empty_reg_reg;
  wire empty_reg_reg_0;
  wire n_next;
  wire [2:0]n_reg;
  wire \n_reg[0]_i_1_n_0 ;
  wire \n_reg[1]_i_1_n_0 ;
  wire \n_reg[2]_i_1_n_0 ;
  wire \n_reg_reg[0]_0 ;
  wire \n_reg_reg[0]_1 ;
  wire s_next;
  wire [3:0]s_reg;
  wire \s_reg[0]_i_1__0_n_0 ;
  wire \s_reg[1]_i_1__0_n_0 ;
  wire \s_reg[2]_i_1__0_n_0 ;
  wire \s_reg[3]_i_2_n_0 ;
  wire \s_reg_reg[0]_0 ;
  wire \s_reg_reg[2]_0 ;
  wire \s_reg_reg[3]_0 ;
  wire [1:0]state_reg;

  LUT6 #(
    .INIT(64'h0E0E0E0EF1F1F1FF)) 
    \FSM_sequential_state_reg[0]_i_1 
       (.I0(\FSM_sequential_state_reg_reg[0]_1 ),
        .I1(\FSM_sequential_state_reg[1]_i_3_n_0 ),
        .I2(\FSM_sequential_state_reg_reg[0]_2 ),
        .I3(state_reg[1]),
        .I4(D),
        .I5(state_reg[0]),
        .O(\FSM_sequential_state_reg[0]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h6C6C6C66)) 
    \FSM_sequential_state_reg[1]_i_1 
       (.I0(state_reg[0]),
        .I1(state_reg[1]),
        .I2(\FSM_sequential_state_reg_reg[0]_2 ),
        .I3(\FSM_sequential_state_reg[1]_i_3_n_0 ),
        .I4(\FSM_sequential_state_reg_reg[0]_1 ),
        .O(\FSM_sequential_state_reg[1]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h1555)) 
    \FSM_sequential_state_reg[1]_i_3 
       (.I0(state_reg[0]),
        .I1(n_reg[0]),
        .I2(n_reg[1]),
        .I3(n_reg[2]),
        .O(\FSM_sequential_state_reg[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040000000)) 
    \FSM_sequential_state_reg[1]_i_5 
       (.I0(state_reg[1]),
        .I1(state_reg[0]),
        .I2(s_reg[1]),
        .I3(s_reg[0]),
        .I4(s_reg[2]),
        .I5(s_reg[3]),
        .O(\FSM_sequential_state_reg_reg[1]_0 ));
  (* FSM_ENCODED_STATES = "idle:00,start:01,data:10,stop:11" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\FSM_sequential_state_reg[0]_i_1_n_0 ),
        .Q(state_reg[0]));
  (* FSM_ENCODED_STATES = "idle:00,start:01,data:10,stop:11" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\FSM_sequential_state_reg[1]_i_1_n_0 ),
        .Q(state_reg[1]));
  LUT2 #(
    .INIT(4'h1)) 
    \b_reg[7]_i_1__0 
       (.I0(state_reg[0]),
        .I1(\FSM_sequential_state_reg_reg[0]_1 ),
        .O(\b_reg[7]_i_1__0_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(\b_reg[7]_i_1__0_n_0 ),
        .CLR(AR),
        .D(\b_reg_reg[7]_0 [1]),
        .Q(\b_reg_reg[7]_0 [0]));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(\b_reg[7]_i_1__0_n_0 ),
        .CLR(AR),
        .D(\b_reg_reg[7]_0 [2]),
        .Q(\b_reg_reg[7]_0 [1]));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[2] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(\b_reg[7]_i_1__0_n_0 ),
        .CLR(AR),
        .D(\b_reg_reg[7]_0 [3]),
        .Q(\b_reg_reg[7]_0 [2]));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[3] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(\b_reg[7]_i_1__0_n_0 ),
        .CLR(AR),
        .D(\b_reg_reg[7]_0 [4]),
        .Q(\b_reg_reg[7]_0 [3]));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[4] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(\b_reg[7]_i_1__0_n_0 ),
        .CLR(AR),
        .D(\b_reg_reg[7]_0 [5]),
        .Q(\b_reg_reg[7]_0 [4]));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[5] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(\b_reg[7]_i_1__0_n_0 ),
        .CLR(AR),
        .D(\b_reg_reg[7]_0 [6]),
        .Q(\b_reg_reg[7]_0 [5]));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[6] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(\b_reg[7]_i_1__0_n_0 ),
        .CLR(AR),
        .D(\b_reg_reg[7]_0 [7]),
        .Q(\b_reg_reg[7]_0 [6]));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[7] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(\b_reg[7]_i_1__0_n_0 ),
        .CLR(AR),
        .D(D),
        .Q(\b_reg_reg[7]_0 [7]));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    empty_reg_i_2
       (.I0(state_reg[0]),
        .I1(empty_reg_reg),
        .I2(Q),
        .I3(empty_reg_reg_0),
        .I4(state_reg[1]),
        .I5(\s_reg_reg[2]_0 ),
        .O(\FSM_sequential_state_reg_reg[0]_0 ));
  LUT3 #(
    .INIT(8'h38)) 
    \n_reg[0]_i_1 
       (.I0(state_reg[1]),
        .I1(n_next),
        .I2(n_reg[0]),
        .O(\n_reg[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'h2F80)) 
    \n_reg[1]_i_1 
       (.I0(state_reg[1]),
        .I1(n_reg[0]),
        .I2(n_next),
        .I3(n_reg[1]),
        .O(\n_reg[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'h2AFF8000)) 
    \n_reg[2]_i_1 
       (.I0(state_reg[1]),
        .I1(n_reg[0]),
        .I2(n_reg[1]),
        .I3(n_next),
        .I4(n_reg[2]),
        .O(\n_reg[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h08080C0808080808)) 
    \n_reg[2]_i_2 
       (.I0(\FSM_sequential_state_reg_reg[1]_0 ),
        .I1(\n_reg_reg[0]_0 ),
        .I2(\n_reg_reg[0]_1 ),
        .I3(state_reg[1]),
        .I4(\s_reg_reg[2]_0 ),
        .I5(\FSM_sequential_state_reg[1]_i_3_n_0 ),
        .O(n_next));
  FDCE #(
    .INIT(1'b0)) 
    \n_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\n_reg[0]_i_1_n_0 ),
        .Q(n_reg[0]));
  FDCE #(
    .INIT(1'b0)) 
    \n_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\n_reg[1]_i_1_n_0 ),
        .Q(n_reg[1]));
  FDCE #(
    .INIT(1'b0)) 
    \n_reg_reg[2] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\n_reg[2]_i_1_n_0 ),
        .Q(n_reg[2]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT5 #(
    .INIT(32'h7FFFFFFF)) 
    \r_ptr_reg[0]_i_3 
       (.I0(s_reg[3]),
        .I1(s_reg[1]),
        .I2(s_reg[0]),
        .I3(s_reg[2]),
        .I4(state_reg[1]),
        .O(\s_reg_reg[3]_0 ));
  LUT3 #(
    .INIT(8'h0E)) 
    \s_reg[0]_i_1__0 
       (.I0(state_reg[0]),
        .I1(state_reg[1]),
        .I2(s_reg[0]),
        .O(\s_reg[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT4 #(
    .INIT(16'h0EE0)) 
    \s_reg[1]_i_1__0 
       (.I0(state_reg[0]),
        .I1(state_reg[1]),
        .I2(s_reg[1]),
        .I3(s_reg[0]),
        .O(\s_reg[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'h0EEEE000)) 
    \s_reg[2]_i_1__0 
       (.I0(state_reg[0]),
        .I1(state_reg[1]),
        .I2(s_reg[0]),
        .I3(s_reg[1]),
        .I4(s_reg[2]),
        .O(\s_reg[2]_i_1__0_n_0 ));
  LUT5 #(
    .INIT(32'h0101FD3D)) 
    \s_reg[3]_i_1 
       (.I0(D),
        .I1(state_reg[0]),
        .I2(state_reg[1]),
        .I3(\s_reg_reg[2]_0 ),
        .I4(\s_reg_reg[0]_0 ),
        .O(s_next));
  LUT6 #(
    .INIT(64'h0EEEEEEEC0000000)) 
    \s_reg[3]_i_2 
       (.I0(state_reg[0]),
        .I1(state_reg[1]),
        .I2(s_reg[1]),
        .I3(s_reg[0]),
        .I4(s_reg[2]),
        .I5(s_reg[3]),
        .O(\s_reg[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'h7FFF)) 
    \s_reg[3]_i_3 
       (.I0(s_reg[2]),
        .I1(s_reg[0]),
        .I2(s_reg[1]),
        .I3(s_reg[3]),
        .O(\s_reg_reg[2]_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \s_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(s_next),
        .CLR(AR),
        .D(\s_reg[0]_i_1__0_n_0 ),
        .Q(s_reg[0]));
  FDCE #(
    .INIT(1'b0)) 
    \s_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(s_next),
        .CLR(AR),
        .D(\s_reg[1]_i_1__0_n_0 ),
        .Q(s_reg[1]));
  FDCE #(
    .INIT(1'b0)) 
    \s_reg_reg[2] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(s_next),
        .CLR(AR),
        .D(\s_reg[2]_i_1__0_n_0 ),
        .Q(s_reg[2]));
  FDCE #(
    .INIT(1'b0)) 
    \s_reg_reg[3] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(s_next),
        .CLR(AR),
        .D(\s_reg[3]_i_2_n_0 ),
        .Q(s_reg[3]));
endmodule

(* NotValidForBitStream *)
module uart_test
   (CLK100MHZ,
    reset,
    rx,
    btn,
    tx,
    an,
    sseg,
    led);
  input CLK100MHZ;
  input reset;
  input rx;
  input [2:0]btn;
  output tx;
  output [3:0]an;
  output [7:0]sseg;
  output [7:0]led;

  wire CLK100MHZ;
  wire CLK100MHZ_IBUF;
  wire CLK100MHZ_IBUF_BUFG;
  wire [3:0]an;
  wire [2:0]btn;
  wire [0:0]btn_IBUF;
  wire btn_db_unit_n_0;
  wire btn_db_unit_n_4;
  wire btn_db_unit_n_5;
  wire btn_db_unit_n_6;
  wire [0:0]\fifo_rx_unit/r_ptr_reg ;
  wire [0:0]\fifo_tx_unit/w_ptr_reg ;
  wire [7:0]led;
  wire [7:0]led_OBUF;
  wire reset;
  wire reset_IBUF;
  wire rx;
  wire rx_IBUF;
  wire rx_done_tick;
  wire rx_empty;
  wire [7:0]sseg;
  wire [6:3]sseg_OBUF;
  wire [2:0]state_reg;
  wire tx;
  wire tx_OBUF;
  wire tx_full;
  wire uart_unit_n_13;

  BUFG CLK100MHZ_IBUF_BUFG_inst
       (.I(CLK100MHZ_IBUF),
        .O(CLK100MHZ_IBUF_BUFG));
  IBUF CLK100MHZ_IBUF_inst
       (.I(CLK100MHZ),
        .O(CLK100MHZ_IBUF));
  OBUF \an_OBUF[0]_inst 
       (.I(1'b0),
        .O(an[0]));
  OBUF \an_OBUF[1]_inst 
       (.I(1'b1),
        .O(an[1]));
  OBUF \an_OBUF[2]_inst 
       (.I(1'b1),
        .O(an[2]));
  OBUF \an_OBUF[3]_inst 
       (.I(1'b1),
        .O(an[3]));
  IBUF \btn_IBUF[0]_inst 
       (.I(btn[0]),
        .O(btn_IBUF));
  debounce btn_db_unit
       (.AR(reset_IBUF),
        .CLK100MHZ_IBUF_BUFG(CLK100MHZ_IBUF_BUFG),
        .\FSM_sequential_state_reg_reg[0]_0 (btn_db_unit_n_4),
        .\FSM_sequential_state_reg_reg[2]_0 (btn_db_unit_n_0),
        .\FSM_sequential_state_reg_reg[2]_1 (btn_db_unit_n_5),
        .btn_IBUF(btn_IBUF),
        .full_reg_reg(btn_db_unit_n_6),
        .r_ptr_reg(\fifo_rx_unit/r_ptr_reg ),
        .rx_done_tick(rx_done_tick),
        .rx_empty(rx_empty),
        .state_reg(state_reg),
        .tx_full(tx_full),
        .w_ptr_reg(\fifo_tx_unit/w_ptr_reg ),
        .\w_ptr_reg_reg[0] (uart_unit_n_13));
  OBUF \led_OBUF[0]_inst 
       (.I(led_OBUF[0]),
        .O(led[0]));
  OBUF \led_OBUF[1]_inst 
       (.I(led_OBUF[1]),
        .O(led[1]));
  OBUF \led_OBUF[2]_inst 
       (.I(led_OBUF[2]),
        .O(led[2]));
  OBUF \led_OBUF[3]_inst 
       (.I(led_OBUF[3]),
        .O(led[3]));
  OBUF \led_OBUF[4]_inst 
       (.I(led_OBUF[4]),
        .O(led[4]));
  OBUF \led_OBUF[5]_inst 
       (.I(led_OBUF[5]),
        .O(led[5]));
  OBUF \led_OBUF[6]_inst 
       (.I(led_OBUF[6]),
        .O(led[6]));
  OBUF \led_OBUF[7]_inst 
       (.I(led_OBUF[7]),
        .O(led[7]));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  IBUF rx_IBUF_inst
       (.I(rx),
        .O(rx_IBUF));
  OBUF \sseg_OBUF[0]_inst 
       (.I(1'b1),
        .O(sseg[0]));
  OBUF \sseg_OBUF[1]_inst 
       (.I(1'b1),
        .O(sseg[1]));
  OBUF \sseg_OBUF[2]_inst 
       (.I(1'b1),
        .O(sseg[2]));
  OBUF \sseg_OBUF[3]_inst 
       (.I(sseg_OBUF[3]),
        .O(sseg[3]));
  OBUF \sseg_OBUF[4]_inst 
       (.I(1'b1),
        .O(sseg[4]));
  OBUF \sseg_OBUF[5]_inst 
       (.I(1'b1),
        .O(sseg[5]));
  OBUF \sseg_OBUF[6]_inst 
       (.I(sseg_OBUF[6]),
        .O(sseg[6]));
  OBUF \sseg_OBUF[7]_inst 
       (.I(1'b1),
        .O(sseg[7]));
  OBUF tx_OBUF_inst
       (.I(tx_OBUF),
        .O(tx));
  uart uart_unit
       (.AR(reset_IBUF),
        .CLK100MHZ_IBUF_BUFG(CLK100MHZ_IBUF_BUFG),
        .D(rx_IBUF),
        .\FSM_sequential_state_reg_reg[1] (uart_unit_n_13),
        .\b_reg_reg[7] (btn_db_unit_n_6),
        .led_OBUF(led_OBUF),
        .\r_ptr_reg_reg[0] (\fifo_rx_unit/r_ptr_reg ),
        .\r_ptr_reg_reg[0]_0 (btn_db_unit_n_0),
        .\r_ptr_reg_reg[0]_1 (btn_db_unit_n_5),
        .rx_done_tick(rx_done_tick),
        .rx_empty(rx_empty),
        .sseg_OBUF({sseg_OBUF[6],sseg_OBUF[3]}),
        .state_reg(state_reg),
        .tx_OBUF(tx_OBUF),
        .tx_full(tx_full),
        .\w_ptr_reg_reg[0] (\fifo_tx_unit/w_ptr_reg ),
        .\w_ptr_reg_reg[0]_0 (btn_db_unit_n_4));
endmodule

module uart_tx
   (tx_OBUF,
    \FSM_sequential_state_reg_reg[1]_0 ,
    \s_reg_reg[2]_0 ,
    \FSM_sequential_state_reg_reg[1]_1 ,
    \FSM_sequential_state_reg_reg[1]_2 ,
    \FSM_sequential_state_reg_reg[0]_0 ,
    CLK100MHZ_IBUF_BUFG,
    AR,
    tx_empty,
    \s_reg_reg[0]_0 ,
    full_reg_reg,
    Q,
    full_reg_reg_0,
    \r_ptr_reg_reg[0] ,
    \r_ptr_reg_reg[0]_0 ,
    \r_ptr_reg_reg[0]_1 ,
    D,
    \b_reg_reg[6]_0 );
  output tx_OBUF;
  output [0:0]\FSM_sequential_state_reg_reg[1]_0 ;
  output \s_reg_reg[2]_0 ;
  output \FSM_sequential_state_reg_reg[1]_1 ;
  output \FSM_sequential_state_reg_reg[1]_2 ;
  output \FSM_sequential_state_reg_reg[0]_0 ;
  input CLK100MHZ_IBUF_BUFG;
  input [0:0]AR;
  input tx_empty;
  input \s_reg_reg[0]_0 ;
  input full_reg_reg;
  input [0:0]Q;
  input full_reg_reg_0;
  input \r_ptr_reg_reg[0] ;
  input \r_ptr_reg_reg[0]_0 ;
  input [0:0]\r_ptr_reg_reg[0]_1 ;
  input [0:0]D;
  input [6:0]\b_reg_reg[6]_0 ;

  wire [0:0]AR;
  wire CLK100MHZ_IBUF_BUFG;
  wire [0:0]D;
  wire \FSM_sequential_state_reg[0]_i_1__0_n_0 ;
  wire \FSM_sequential_state_reg[0]_i_2_n_0 ;
  wire \FSM_sequential_state_reg[1]_i_1__0_n_0 ;
  wire \FSM_sequential_state_reg_reg[0]_0 ;
  wire [0:0]\FSM_sequential_state_reg_reg[1]_0 ;
  wire \FSM_sequential_state_reg_reg[1]_1 ;
  wire \FSM_sequential_state_reg_reg[1]_2 ;
  wire [0:0]Q;
  wire [6:0]b_next;
  wire b_next_0;
  wire [0:0]b_reg;
  wire [6:0]\b_reg_reg[6]_0 ;
  wire \b_reg_reg_n_0_[1] ;
  wire \b_reg_reg_n_0_[2] ;
  wire \b_reg_reg_n_0_[3] ;
  wire \b_reg_reg_n_0_[4] ;
  wire \b_reg_reg_n_0_[5] ;
  wire \b_reg_reg_n_0_[6] ;
  wire \b_reg_reg_n_0_[7] ;
  wire full_reg_reg;
  wire full_reg_reg_0;
  wire [2:0]n_reg;
  wire \n_reg[0]_i_1_n_0 ;
  wire \n_reg[1]_i_1_n_0 ;
  wire \n_reg[2]_i_1_n_0 ;
  wire \r_ptr_reg_reg[0] ;
  wire \r_ptr_reg_reg[0]_0 ;
  wire [0:0]\r_ptr_reg_reg[0]_1 ;
  wire s_next;
  wire [3:0]s_reg;
  wire \s_reg[0]_i_1_n_0 ;
  wire \s_reg[1]_i_1_n_0 ;
  wire \s_reg[2]_i_1_n_0 ;
  wire \s_reg[3]_i_2__0_n_0 ;
  wire \s_reg_reg[0]_0 ;
  wire \s_reg_reg[2]_0 ;
  wire [0:0]state_reg;
  wire tx_OBUF;
  wire tx_empty;
  wire tx_next;

  LUT6 #(
    .INIT(64'h55555555008033B3)) 
    \FSM_sequential_state_reg[0]_i_1__0 
       (.I0(\r_ptr_reg_reg[0] ),
        .I1(\FSM_sequential_state_reg_reg[1]_0 ),
        .I2(n_reg[2]),
        .I3(\FSM_sequential_state_reg[0]_i_2_n_0 ),
        .I4(tx_empty),
        .I5(state_reg),
        .O(\FSM_sequential_state_reg[0]_i_1__0_n_0 ));
  LUT2 #(
    .INIT(4'h7)) 
    \FSM_sequential_state_reg[0]_i_2 
       (.I0(n_reg[0]),
        .I1(n_reg[1]),
        .O(\FSM_sequential_state_reg[0]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'h6C)) 
    \FSM_sequential_state_reg[1]_i_1__0 
       (.I0(state_reg),
        .I1(\FSM_sequential_state_reg_reg[1]_0 ),
        .I2(\r_ptr_reg_reg[0] ),
        .O(\FSM_sequential_state_reg[1]_i_1__0_n_0 ));
  (* FSM_ENCODED_STATES = "idle:00,start:01,data:10,stop:11" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\FSM_sequential_state_reg[0]_i_1__0_n_0 ),
        .Q(state_reg));
  (* FSM_ENCODED_STATES = "idle:00,start:01,data:10,stop:11" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\FSM_sequential_state_reg[1]_i_1__0_n_0 ),
        .Q(\FSM_sequential_state_reg_reg[1]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \b_reg[0]_i_1 
       (.I0(\b_reg_reg_n_0_[1] ),
        .I1(\FSM_sequential_state_reg_reg[1]_0 ),
        .I2(\b_reg_reg[6]_0 [0]),
        .O(b_next[0]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \b_reg[1]_i_1 
       (.I0(\b_reg_reg_n_0_[2] ),
        .I1(\FSM_sequential_state_reg_reg[1]_0 ),
        .I2(\b_reg_reg[6]_0 [1]),
        .O(b_next[1]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \b_reg[2]_i_1 
       (.I0(\b_reg_reg_n_0_[3] ),
        .I1(\FSM_sequential_state_reg_reg[1]_0 ),
        .I2(\b_reg_reg[6]_0 [2]),
        .O(b_next[2]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \b_reg[3]_i_1 
       (.I0(\b_reg_reg_n_0_[4] ),
        .I1(\FSM_sequential_state_reg_reg[1]_0 ),
        .I2(\b_reg_reg[6]_0 [3]),
        .O(b_next[3]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \b_reg[4]_i_1 
       (.I0(\b_reg_reg_n_0_[5] ),
        .I1(\FSM_sequential_state_reg_reg[1]_0 ),
        .I2(\b_reg_reg[6]_0 [4]),
        .O(b_next[4]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \b_reg[5]_i_1 
       (.I0(\b_reg_reg_n_0_[6] ),
        .I1(\FSM_sequential_state_reg_reg[1]_0 ),
        .I2(\b_reg_reg[6]_0 [5]),
        .O(b_next[5]));
  LUT3 #(
    .INIT(8'hB8)) 
    \b_reg[6]_i_1 
       (.I0(\b_reg_reg_n_0_[7] ),
        .I1(\FSM_sequential_state_reg_reg[1]_0 ),
        .I2(\b_reg_reg[6]_0 [6]),
        .O(b_next[6]));
  LUT5 #(
    .INIT(32'h01010131)) 
    \b_reg[7]_i_1 
       (.I0(tx_empty),
        .I1(state_reg),
        .I2(\FSM_sequential_state_reg_reg[1]_0 ),
        .I3(\s_reg_reg[0]_0 ),
        .I4(\s_reg_reg[2]_0 ),
        .O(b_next_0));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \b_reg[7]_i_3 
       (.I0(s_reg[2]),
        .I1(s_reg[0]),
        .I2(s_reg[1]),
        .I3(s_reg[3]),
        .O(\s_reg_reg[2]_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(b_next_0),
        .CLR(AR),
        .D(b_next[0]),
        .Q(b_reg));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(b_next_0),
        .CLR(AR),
        .D(b_next[1]),
        .Q(\b_reg_reg_n_0_[1] ));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[2] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(b_next_0),
        .CLR(AR),
        .D(b_next[2]),
        .Q(\b_reg_reg_n_0_[2] ));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[3] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(b_next_0),
        .CLR(AR),
        .D(b_next[3]),
        .Q(\b_reg_reg_n_0_[3] ));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[4] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(b_next_0),
        .CLR(AR),
        .D(b_next[4]),
        .Q(\b_reg_reg_n_0_[4] ));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[5] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(b_next_0),
        .CLR(AR),
        .D(b_next[5]),
        .Q(\b_reg_reg_n_0_[5] ));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[6] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(b_next_0),
        .CLR(AR),
        .D(b_next[6]),
        .Q(\b_reg_reg_n_0_[6] ));
  FDCE #(
    .INIT(1'b0)) 
    \b_reg_reg[7] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(b_next_0),
        .CLR(AR),
        .D(D),
        .Q(\b_reg_reg_n_0_[7] ));
  LUT6 #(
    .INIT(64'hDD00DD00F7887788)) 
    \n_reg[0]_i_1 
       (.I0(\r_ptr_reg_reg[0] ),
        .I1(\FSM_sequential_state_reg_reg[1]_0 ),
        .I2(n_reg[2]),
        .I3(n_reg[0]),
        .I4(n_reg[1]),
        .I5(state_reg),
        .O(\n_reg[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hDDDD0000F7FF8800)) 
    \n_reg[1]_i_1 
       (.I0(\r_ptr_reg_reg[0] ),
        .I1(\FSM_sequential_state_reg_reg[1]_0 ),
        .I2(n_reg[2]),
        .I3(n_reg[0]),
        .I4(n_reg[1]),
        .I5(state_reg),
        .O(\n_reg[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hD0D0D0D0F8F0F0F0)) 
    \n_reg[2]_i_1 
       (.I0(\r_ptr_reg_reg[0] ),
        .I1(\FSM_sequential_state_reg_reg[1]_0 ),
        .I2(n_reg[2]),
        .I3(n_reg[0]),
        .I4(n_reg[1]),
        .I5(state_reg),
        .O(\n_reg[2]_i_1_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \n_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\n_reg[0]_i_1_n_0 ),
        .Q(n_reg[0]));
  FDCE #(
    .INIT(1'b0)) 
    \n_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\n_reg[1]_i_1_n_0 ),
        .Q(n_reg[1]));
  FDCE #(
    .INIT(1'b0)) 
    \n_reg_reg[2] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .CLR(AR),
        .D(\n_reg[2]_i_1_n_0 ),
        .Q(n_reg[2]));
  LUT6 #(
    .INIT(64'hFF7F7F7F00808080)) 
    \r_ptr_reg[0]_i_1__0 
       (.I0(state_reg),
        .I1(\FSM_sequential_state_reg_reg[1]_0 ),
        .I2(\r_ptr_reg_reg[0] ),
        .I3(tx_empty),
        .I4(\r_ptr_reg_reg[0]_0 ),
        .I5(\r_ptr_reg_reg[0]_1 ),
        .O(\FSM_sequential_state_reg_reg[0]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \r_ptr_reg[1]_i_3 
       (.I0(\FSM_sequential_state_reg_reg[1]_0 ),
        .I1(state_reg),
        .O(\FSM_sequential_state_reg_reg[1]_2 ));
  LUT3 #(
    .INIT(8'h0E)) 
    \s_reg[0]_i_1 
       (.I0(\FSM_sequential_state_reg_reg[1]_0 ),
        .I1(state_reg),
        .I2(s_reg[0]),
        .O(\s_reg[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT4 #(
    .INIT(16'h0EE0)) 
    \s_reg[1]_i_1 
       (.I0(\FSM_sequential_state_reg_reg[1]_0 ),
        .I1(state_reg),
        .I2(s_reg[1]),
        .I3(s_reg[0]),
        .O(\s_reg[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'h0EEEE000)) 
    \s_reg[2]_i_1 
       (.I0(\FSM_sequential_state_reg_reg[1]_0 ),
        .I1(state_reg),
        .I2(s_reg[0]),
        .I3(s_reg[1]),
        .I4(s_reg[2]),
        .O(\s_reg[2]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h33350335)) 
    \s_reg[3]_i_1__0 
       (.I0(tx_empty),
        .I1(\s_reg_reg[0]_0 ),
        .I2(state_reg),
        .I3(\FSM_sequential_state_reg_reg[1]_0 ),
        .I4(\s_reg_reg[2]_0 ),
        .O(s_next));
  LUT6 #(
    .INIT(64'h0EE0E0E0E0E0E0E0)) 
    \s_reg[3]_i_2__0 
       (.I0(\FSM_sequential_state_reg_reg[1]_0 ),
        .I1(state_reg),
        .I2(s_reg[3]),
        .I3(s_reg[1]),
        .I4(s_reg[0]),
        .I5(s_reg[2]),
        .O(\s_reg[3]_i_2__0_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \s_reg_reg[0] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(s_next),
        .CLR(AR),
        .D(\s_reg[0]_i_1_n_0 ),
        .Q(s_reg[0]));
  FDCE #(
    .INIT(1'b0)) 
    \s_reg_reg[1] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(s_next),
        .CLR(AR),
        .D(\s_reg[1]_i_1_n_0 ),
        .Q(s_reg[1]));
  FDCE #(
    .INIT(1'b0)) 
    \s_reg_reg[2] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(s_next),
        .CLR(AR),
        .D(\s_reg[2]_i_1_n_0 ),
        .Q(s_reg[2]));
  FDCE #(
    .INIT(1'b0)) 
    \s_reg_reg[3] 
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(s_next),
        .CLR(AR),
        .D(\s_reg[3]_i_2__0_n_0 ),
        .Q(s_reg[3]));
  LUT3 #(
    .INIT(8'hE5)) 
    tx_reg_i_1
       (.I0(state_reg),
        .I1(b_reg),
        .I2(\FSM_sequential_state_reg_reg[1]_0 ),
        .O(tx_next));
  FDPE #(
    .INIT(1'b1)) 
    tx_reg_reg
       (.C(CLK100MHZ_IBUF_BUFG),
        .CE(1'b1),
        .D(tx_next),
        .PRE(AR),
        .Q(tx_OBUF));
  LUT6 #(
    .INIT(64'hFFFFFF7FFFFFFFFF)) 
    \w_ptr_reg[1]_i_2 
       (.I0(\FSM_sequential_state_reg_reg[1]_0 ),
        .I1(full_reg_reg),
        .I2(Q),
        .I3(full_reg_reg_0),
        .I4(\s_reg_reg[2]_0 ),
        .I5(state_reg),
        .O(\FSM_sequential_state_reg_reg[1]_1 ));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
