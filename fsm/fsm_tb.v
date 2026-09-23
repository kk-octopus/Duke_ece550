`timescale 1ns/100ps
module fsm_tb();
      reg seq_in;
      reg reset;
      reg clk;
      wire out;
      wire [2:0]cur_state;
      fsm fsm1(
            .seq_in(seq_in),
            .reset(reset),
            .clk(clk),
            .out(out),
            .cur_state(cur_state)
      );
      initial begin
            clk= 0;
            reset= 0;
            seq_in =  0;

            #10;
            seq_in=1;
            #10;
            seq_in=1;
            #10;
            seq_in=0;
            #10;
            seq_in=1;
            #10;
            seq_in=1;
            #10;
            seq_in=0;
            #10;
            seq_in=1;
            #10;
            seq_in=1;
            #10;
            seq_in=1;
            #10;
            seq_in=0;
            #10;
            seq_in=1;
            #5;
            reset = 1;
            #10;
            $finish;
      end
      always begin
            #5;
            clk = ~clk;
      end
endmodule