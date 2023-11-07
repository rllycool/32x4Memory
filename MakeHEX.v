module MakeHEX(
	input wire [3:0] numwant, input wire dot,
	output reg [7:0] display
);

reg [6:0] segments;
always@(*) begin
		
		case(numwant)
			4'b0000: segments = 7'b1000000; //0
			4'b0001: segments = 7'b1111001; //1
			4'b0010: segments = 7'b0100100; //2
			4'b0011: segments = 7'b0110000; //3
			
			4'b0100: segments = 7'b0011001; //4
			4'b0101: segments = 7'b0010010; //5
			4'b0110: segments = 7'b0000010; //6
			4'b0111: segments = 7'b1111000; //7

			4'b1000: segments = 7'b0000000; //8 
			4'b1001: segments = 7'b0011000; //9
 			4'b1010: segments = 7'b0001000; //A
			4'b1011: segments = 7'b0000000; //B
			
			4'b1100: segments = 7'b1000110; //C
			4'b1101: segments = 7'b1000000; //D
			4'b1110: segments = 7'b0000110;//E
			4'b1111: segments = 7'b0001110;//F
			default: segments = 7'b1000000;
		endcase
		display = {dot, segments};
	end	

endmodule