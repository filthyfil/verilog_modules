module spi #(
	parameter DATA_WIDTH = 8, // bits per transfer
	parameter CLK_DIVIDE = 10, // clock divider for sclk rate
 	parameter CLK_POL = 0, // clock polarity; 0: idle low | 1: idle high
	parameter CLK_PHA = 0, // clock phase; 0: sample on 1st edge | 1: sample on 2nd edge
	parameter CS_POL = 0 // chip select polarity; 0: active-low | 1: active-high
) (
	input wire clk,
	input wire reset,
	input wire start,
	input wire hold,
	input wire [DATA_WIDTH-1:0] tx_data,
	input wire miso,

	output wire sclk,
	output wire mosi,
	output wire cs_n,
	output wire [DATA_WIDTH-1:0] rx_data,
	output wire done
);
	wire rst_n = ~reset; // active-low, async reset

	// body

	// state machine
	reg [1:0] state;
 	reg [1:0] state_next;

	// defined states according to spec are:
	// following Grey encoding
	localparam IDLE = 2'b00,
		   SETUP = 2'b01,
		   TRANSFER = 2'b11,
		   BYTE_DONE = 2'b10;

	// bit counter: bits transferred so far in the current byte
	// (0..DATA_WIDTH-1) — distinct from clk_count, which only tracks
	// phase within the sclk divider
	reg [$clog2(DATA_WIDTH)-1:0] bit_count;

	// edge parity within TRANSFER: toggles every div_terminal, so
	// is_sample_edge can tell the CPHA-designated sample edge from the
	// shift edge without duplicating FSM logic per CPHA value
	reg edge_toggle;
	wire is_sample_edge = ~(edge_toggle ^ CLK_PHA);

	// CPHA==0 samples the last bit on the leading edge, one edge before
	// sclk's trailing toggle brings it back to idle. Without waiting for
	// that trailing edge, the FSM would leave TRANSFER immediately and
	// the clock generator below would snap sclk back to CLK_POL, cutting
	// that last pulse to 1 clk cycle instead of a full CLK_DIVIDE
	// half-period. This flag makes the FSM wait for it. (CPHA==1 doesn't
	// need this: its sample edge IS the trailing edge, already at idle.)
	reg final_edge_pending;

	always @(posedge clk, negedge rst_n) begin
		if (~rst_n) begin
			state <= IDLE;
		end else begin
			state <= state_next;
		end
	end

	always @(posedge clk, negedge rst_n) begin
		if (~rst_n) begin
			bit_count <= 0;
			edge_toggle <= 0;
			final_edge_pending <= 0;
		end else if (state == IDLE && start) begin
			bit_count <= 0;
			edge_toggle <= 0;
			final_edge_pending <= 0;
		end else if (state == TRANSFER && div_terminal) begin
			edge_toggle <= ~edge_toggle;
			if (is_sample_edge) begin
				bit_count <= bit_count + 1;
			end
			final_edge_pending <= (is_sample_edge && bit_count == DATA_WIDTH-1 && CLK_PHA == 0);
		end
	end

	wire div_terminal = (clk_count == CLK_DIVIDE - 1);
	always @* begin
		case (state)
			IDLE: begin
				if (start) begin
					state_next = SETUP;
				end else begin
					state_next = state;
				end
			end
			SETUP: begin
				state_next = TRANSFER;
			end
			TRANSFER: begin
				if (div_terminal && ((is_sample_edge && (bit_count == DATA_WIDTH-1) && CLK_PHA != 0) || final_edge_pending)) begin
					state_next = BYTE_DONE;
				end else begin
					state_next = state;
				end
			end
			BYTE_DONE: begin
				state_next = IDLE;
			end
		endcase
	end

	// slave clock
	// gated to TRANSFER only: sclk must hold at CLK_POL outside a
	// transfer, and the divider should start from a known phase at the
	// beginning of every byte rather than free-running from reset
	wire div_en = (state == TRANSFER);
	localparam COUNT_WIDTH = $clog2(CLK_DIVIDE);
	reg [COUNT_WIDTH-1:0] clk_count; // the register that counts the clock for the peripheral
	reg r_sclk;
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			clk_count <= 0;
			r_sclk <= CLK_POL;
		end else if (~div_en) begin
			clk_count <= 0;
			r_sclk <= CLK_POL;
		end else if (div_terminal) begin
			clk_count <= 0;
			r_sclk <= ~r_sclk;
		end else begin
			clk_count <= clk_count + 1;
		end
	end
	assign sclk = r_sclk;

	// datapath: shift registers, chip select, done/rx_data outputs
	reg [DATA_WIDTH-1:0] tx_shift;
	reg [DATA_WIDTH-1:0] rx_shift;
	reg [DATA_WIDTH-1:0] r_rx_data;
	reg hold_latched;
	reg cs_active;
	reg r_done;

	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			tx_shift     <= 0;
			rx_shift     <= 0;
			r_rx_data    <= 0;
			hold_latched <= 0;
			cs_active    <= 0;
			r_done       <= 0;
		end else begin
			r_done <= 0; // default; pulses for one cycle in BYTE_DONE below

			if (state == IDLE && start) begin
				tx_shift     <= tx_data;
				hold_latched <= hold;
				cs_active    <= 1;
			end else if (state == TRANSFER && div_terminal) begin
				if (is_sample_edge) begin
					rx_shift <= {rx_shift[DATA_WIDTH-2:0], miso};
				end else if (bit_count != 0) begin
					// the first shift-designated edge (CPHA=1) is a
					// no-op: bit 0 is already presented on mosi from
					// the pre-load in IDLE, nothing to shift in yet
					tx_shift <= {tx_shift[DATA_WIDTH-2:0], 1'b0};
				end
			end else if (state == BYTE_DONE) begin
				r_done    <= 1;
				r_rx_data <= rx_shift;
				cs_active <= hold_latched;
			end
		end
	end

	assign mosi    = tx_shift[DATA_WIDTH-1];
	assign cs_n    = cs_active ? CS_POL : ~CS_POL;
	assign rx_data = r_rx_data;
	assign done    = r_done;

endmodule
