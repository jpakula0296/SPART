// Jesse Pakula & Blake Vandercar
// ECE 551 Excercise 8

// UART rxdreciever testbench
module spart_tb();

// declare all signals we will manipulate as type reg
reg clk, rst, iocs, iorw;
reg [1:0] ioaddr;
reg [1:0] br_cfg;
reg rxd;

wire rda;
wire tbr;
wire [7:0] databus;
wire [9:0] rx_shift_reg;
wire [7:0] transmit_buffer;
wire tx_begin;
wire rx_done;
wire [15:0] divisor_buffer;
wire txd;


reg [7:0] correct_value;


reg [7:0] baud_clk = 130;
	
driver driver_DUT(
	.clk (clk),
	.rst (rst),
	.br_cfg (br_cfg),
	.iocs (iocs),
	.iorw (iorw),
	.rda (rda),
	.tbr (tbr),
	.ioaddr (ioaddr),
	.databus (databus)
	);

	
spart spart_DUT(
	.clk (clk),
	.rst (rst),
	.iocs (iocs),
	.iorw (iorw),
	.transmit_buffer (transmit_buffer),
	.tx_begin (tx_begin),
	.rda (rda),
	.divisor_buffer (divisor_buffer),
	.ioaddr (ioaddr),
	.databus (databus),
	.txd (txd),
	.rxd (rxd)
	);

initial begin
//////////////////////////////////  LOAD DIVISION BUFFER  /////////////////////
	clk = 1'b1;
	rxd = 1'b1;
	rst = 1'b0; // start with reset asserted
	br_cfg = 2'b11; // load fastest baud for testing
	repeat (2) @(posedge clk);
	
	rst = 1'b1; // deassert
	
	repeat (4) @(posedge clk); // wait for division buffer to load

	
///////////////////////// RX TEST //////////////////////////////////////////////
	
	
	// transmit h'A5 as in example
	correct_value = 8'b01010101;
	//start bit
	rxd= 1'b0;
	repeat(baud_clk) @(negedge clk);
	// 10100101
	rxd= 1'b1;
	repeat(baud_clk) @(negedge clk);
	rxd= 1'b0;
	repeat(baud_clk) @(negedge clk);
	rxd= 1'b1;
	repeat(baud_clk) @(negedge clk);
	rxd= 1'b0;
	repeat (baud_clk*2) @(negedge clk);
	rxd= 1'b1;
	repeat (baud_clk) @(negedge clk);
	rxd= 1'b0;
	repeat (baud_clk) @(negedge clk);
	rxd= 1'b1;
	repeat (baud_clk) @(negedge clk);
	// stop bit
	rxd= 1'b1;
	repeat (baud_clk*12) @(negedge clk); // wait for tx to send data out
	$stop;
	
	// transmit h'E7 as in example
	correct_value = 8'hE7;
	//start bit
	rxd= 1'b0;
	repeat(baud_clk) @(negedge clk);
	// 11100111
	rxd= 1'b1;
	repeat(baud_clk*3) @(negedge clk);
	rxd= 1'b0;
	repeat(baud_clk*2) @(negedge clk);
	rxd= 1'b1;
	repeat(baud_clk*3) @(negedge clk);
	// stop bit
	rxd= 1'b1;
	repeat (baud_clk) @(negedge clk);
	
	// transmit h'24 as in example
	correct_value = 8'h24;
	//start bit
	rxd= 1'b0;
	repeat(baud_clk) @(negedge clk);
	// 00100100
	rxd= 1'b0;
	repeat(baud_clk*2) @(negedge clk);
	rxd= 1'b1;
	repeat(baud_clk) @(negedge clk);
	rxd= 1'b0;
	repeat(baud_clk*2) @(negedge clk);
	rxd= 1'b1;
	repeat (baud_clk) @(negedge clk);
	rxd= 1'b0;
	repeat(baud_clk*2) @(negedge clk);
	// stop bit
	rxd= 1'b1;
	repeat (baud_clk) @(negedge clk);
$stop;


end

/*
always @(posedge clk) begin
	if (rda) begin
		if (databus == correct_value)
			$display("databus=%h , correct value=%h, PASS",databus,correct_value);
		else
			$display("databus=%h , correct value=%h, FAIL",databus,correct_value);
	end
end
*/

always begin
	#1 clk = ~clk;		// period 2 clock
end


endmodule 