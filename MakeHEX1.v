module MakeHEX1(
	input wire numwant, input wire dot,
	output reg [7:0] display
);

reg [6:0] segments;
always@(*) begin
		
		case(numwant)
			1'b1: segments = 7'b1111001; //1
			1'b0: segments = 7'b1000000;
			default: segments = 7'b1000000; //0
		endcase
		display = {dot, segments};
	end	

endmodule