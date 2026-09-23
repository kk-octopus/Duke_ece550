`timescale 1 ns / 100 ps
module sequence_detector_tb();
 reg clk, reset, seq_in;
 wire detect;
 wire[2:0]cur_state;
 // Change the module name if necessary
 sequence_detector dut (
 .clk (clk),
 .reset (reset),
 .seq_in (seq_in),
 .detect (detect),
 .cur_state(cur_state)
 );
 // Clock generation
 always #10 clk = ~clk;
 // Display detection
 always @(posedge clk) begin
 if (detect)
 $display($time, " Sequence 1101 detected");
 end
 initial begin
 $display($time, " Simulation start");
 clk = 1'b0;
 reset = 1'b1;
 seq_in = 1'b0;
 // Reset
 #20 reset = 1'b0;
 // Test sequence: 1101101
 // Contains two overlapping occurrences of "1101"
 @(negedge clk); seq_in = 1'b1;
 @(negedge clk); seq_in = 1'b1;
 @(negedge clk); seq_in = 1'b0;
 @(negedge clk); seq_in = 1'b1;
 @(negedge clk); seq_in = 1'b1;
 @(negedge clk); seq_in = 1'b0;
 @(negedge clk); seq_in = 1'b1;
 // Allow the FSM to finish
 @(negedge clk);
 @(negedge clk);
 $display($time, " Simulation end");
 $stop;
 end
endmodule