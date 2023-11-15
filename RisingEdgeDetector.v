module RisingEdgeDetector (
    input wire clk,
    input wire signal,
    output reg edging
);

  reg previous_signal;

  always @(posedge clk) begin
     edging <= 0;
    if (signal == 1'b0 && previous_signal == 1'b1) begin
      edging <= 1;
    end
    previous_signal <= signal;
  end

endmodule