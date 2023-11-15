`timescale 1ns/1ps

module SyncChain(
input wire in, input clk, 
output wire out
);

  reg [3:0] chain;

  always @(posedge clk) begin
      chain <= {chain[2:0], in};
  end

  assign out = chain[3];

endmodule