module Timer250(
input wire clk, 
output reg Rollover
);

integer count;
initial begin
   count = 0;
   Rollover = 1'b0;
end

always @ (posedge clk) begin
   Rollover = 1'b0;
   //833333
   if (count == 12500000) begin
      Rollover = 1'b1;
      count = 0;
   end

   count = count + 1;
	
end

endmodule