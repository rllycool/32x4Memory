module RamProj (

input CLOCK_50,
input [9:0] SW,

output wire [7:0] HEX0,
output wire [7:0] HEX1,
output wire [7:0] HEX2
//output wire [7:0] HEX3,
//output wire [7:0] HEX4,
//output wire [7:0] HEX5

);

wire rollover250;
wire [4:0] q0;
wire wren;

reg [4:0] n;
reg carry;

Timer250 timer250 ( .clk(CLOCK_50), .Rollover(rollover250));
RamMe rambo ( .clock(CLOCK_50), .data(SW[3:0]), .rdaddress(n), .wraddress(SW[8:4]), .wren(wren), .q(q0)); 


//n counter using display2 as rollover
MakeHEX1 display2 (.numwant(carry), .display(HEX2), .dot(1'b1));
MakeHEX display1 (.numwant(n), .display(HEX1), .dot(1'b0));

//q data from memory
MakeHEX display0 (.numwant(q0), .display(HEX0), .dot(1'b1));


always @ (posedge rollover250) begin
	n <= n + 1'b1;

	carry <= n[4];
	
	
end



endmodule