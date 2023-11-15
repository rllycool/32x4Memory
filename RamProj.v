module RamProj (

input CLOCK_50,
input [9:0] SW,
input [1:0]KEY,
inout [39:0] GPIO,

output wire [7:0] HEX0,
output wire [7:0] HEX1,
output wire [7:0] HEX2,
output wire [7:0] HEX3

);


wire [4:0] q0;
wire wren;
wire notwren;
wire resetUart;

reg [4:0] n;
reg carry;
reg [4:0] uartcount;

wire RShift;
wire enable;
reg r;
wire SampleEnable;
wire Samp;
reg [3:0] tenCount;
reg [1:0] localCount;
wire [7:0] uartOut;
reg [3:0] ramIn;

wire rollover250;
wire rollover86;
wire rollover43;
wire rollover10;
wire load;

reg wrenCheck;

reg [2:0] state, next_state;

Timer868 timer868( .clk(CLOCK_50), .Rollover(rollover86), .s_reset(r));
Timer43 timer43( .clk(CLOCK_50), .Rollover(rollover43), .s_reset(enable)); 
Timer10 timer10( .clk(CLOCK_50), .Rollover(rollover10));
Timer250 timer250 ( .clk(CLOCK_50), .Rollover(rollover250));

ShiftReg shiftyboy ( .clk(CLOCK_50), .enable(RShift), .out(uartOut), .ascii(GPIO[0]), .load(load)); //ascii gpio[0]
RisingEdgeDetector rizz ( .clk(CLOCK_50), .signal(r), .edging(RShift));
RisingEdgeDetector SampleEn (.clk(CLOCK_50), .signal(rollover86), .edging(SampleEnable));

RisingEdgeDetector SampleEn2 ( .clk(CLOCK_50), .signal(GPIO[0]), .edging(load));
RisingEdgeDetector StateEn ( .clk(CLOCK_50), .signal(GPIO[0]), .edging(enable));

always @(posedge CLOCK_50) begin
	state <= next_state;
end

//State transition logic
always @(*) begin
	case(state)
		3'd0: next_state <= (enable) ? 3'h1 : 3'h0;
		3'd1: next_state <= (tenCount >= 4'b1001) ? 3'h0 : 3'h2;
		3'd2: next_state <= (SampleEnable) ? 3'h1 : 3'h2;
	endcase
end

always @(posedge CLOCK_50) begin
	if(state == 3'h0) begin
		tenCount <= 1'b0;
		localCount <= 1'b0;
		r <= 1'b0;	
	end
	if(state == 3'h1) begin
		r <= 1'b1;
		tenCount <= n + 1'b1;
		localCount <= 1'b0;	
	end
	if (state == 3'h2) begin
		r <= 1'b0;
		localCount <= localCount + 1'b1;
	end
end

RamMe rambo ( .clock(CLOCK_50), .data(ramIn), .rdaddress(n), .wraddress(uartCount), .wren(wrenCheck), .q(q0)); 
SyncChain button0 ( .clk(CLOCK_50), .in(KEY[0]), .out(resetUart));

//n counter using display2 as rollover
MakeHEX1 display3 (.numwant(carry), .display(HEX3), .dot(1'b1));
MakeHEX display2 (.numwant(n), .display(HEX2), .dot(1'b1));

//q data from memory
MakeHEX display0 (.numwant(q0), .display(HEX0), .dot(1'b1));

wire numzero;
wire numtwo;
wire numthree;

//assign wren = wrenCheck;
assign q0 = (SW[9]) ? uartCount: SW[4:0];
//assign n = (SW[9]) ? t:f;
//assign carry = (SW[9]) ? t:f;

always @ (posedge rollover250) begin
	if(SW[9]) begin
		n <= n + 1'b1;
		carry <= n[4];
	end
   wrenCheck <= 1'b0;
	
	//check for uart word sent
	if(tenCount >= 4'b1001)begin
		uartcount <= uartcount + 1'b1;
		ramIn <= uartOut[3:0];
	end
	if(resetUart)begin
		uartcount <= 5'b00000;
	end
end

endmodule