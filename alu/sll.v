module sll(a, amount, sll);
 input [31:0] a;
 input [4:0]amount;
 output [31:0] sll;

    wire [31:0] shift1, shift2, shift3, shift4, shift5;
    wire [31:0] out1, out2, out3, out4;

    assign shift1 = {a[30:0], 1'b0};
    assign shift2 = {out1[29:0], 2'b00};
    assign shift3 = {out2[27:0], 4'b0000};
    assign shift4 = {out3[23:0], 8'b00000000};
    assign shift5 = {out4[15:0], 16'b00000000000000000000};
    assign out1 = amount[0] ? shift1 : a;
    assign out2 = amount[1] ? shift2 : out1;
    assign out3 = amount[2] ? shift3 : out2;
    assign out4 = amount[3] ? shift4 : out3;
    assign sll = amount[4] ? shift5 : out4;

endmodule