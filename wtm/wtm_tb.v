`timescale 1ns / 100ps
module wtm_tb;
    reg [4:0] a;
    reg [4:0] b;
    wire [9:0] out;

    reg clock;
    
    wtm w(
        .a(a),
        .b(b),
        .out(out)
    );

    initial begin
    $display($time,"simulation start");
    clock = 1'b0;
       @(negedge clock);
       #10 a = 5'b10110; b = 5'b01101;
       @(negedge clock);
       #10 a = 5'b11001; b = 5'b10010;
       @(negedge clock);
       #10 a = 5'b00101; b = 5'b11010;
       @(negedge clock);
       $stop;

    end
    always 
    #10 clock = ~clock;
endmodule
