module tdp_bram #(
  parameter integer DATA_WIDTH = 8,
  parameter integer DEPTH      = 307200,                    // 640*480
  parameter integer ADDR_WIDTH = 19                         // $clog2(307200)=18.2 -> 19
)(
  input  wire                     clk,
  // Port A
  input  wire                     we_a,
  input  wire [ADDR_WIDTH-1:0]    addr_a,
  input  wire [DATA_WIDTH-1:0]    din_a,
  output reg  [DATA_WIDTH-1:0]    dout_a,
  // Port B
  input  wire                     we_b,
  input  wire [ADDR_WIDTH-1:0]    addr_b,
  input  wire [DATA_WIDTH-1:0]    din_b,
  output reg  [DATA_WIDTH-1:0]    dout_b
);
  // force block RAM, not LUTRAM
  (* ram_style="block" *) reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

  // IMPORTANT: delete big zeroing loops; they can block BRAM inference
  // initial for(i=0;i<DEPTH;i=i+1) mem[i]=0; // <- remove

  // Port A
  always @(posedge clk) begin
    if (we_a) mem[addr_a] <= din_a;
    dout_a <= mem[addr_a];
  end

  // Port B
  always @(posedge clk) begin
    if (we_b) mem[addr_b] <= din_b;
    dout_b <= mem[addr_b];
  end
endmodule
