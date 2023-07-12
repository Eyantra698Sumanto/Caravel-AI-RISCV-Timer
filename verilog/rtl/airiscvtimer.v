module Timer (
  input clk,                // Clock input
  input reset,              // Reset input
  input start,              // Start input
  output reg [31:0] time     // Elapsed time output in seconds
);

  reg [31:0] internalTime;   // Internal time counter variable

  always @(posedge clk) begin
    if (reset) begin
      // Reset the timer
      internalTime <= 0;
    end else if (start) begin
      // Increment the timer if start is active
      internalTime <= internalTime + 1;
    end
  end

  always @(posedge clk) begin
    // Output the time in seconds
    time <= internalTime / 80000000;  // Divide by clock frequency (80MHz) to obtain time in seconds
  end

endmodule