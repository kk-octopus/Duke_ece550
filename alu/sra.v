module sra(a, amount, sra);
 input [31:0] a;
 input [4:0]amount;
 output [31:0] sra;

    wire [31:0] shift1, shift2, shift3, shift4, shift5;
    wire [31:0] out1, out2, out3, out4;

    assign shift1 = {a[31],a[31:1]};
    assign shift2 = {{2{a[31]}},out1[31:2]};
    assign shift3 = {{4{a[31]}},out2[31:4]};
    assign shift4 = {{8{a[31]}},out3[31:8]};
    assign shift5 = {{16{a[31]}},out4[31:16]};
    assign out1 = amount[0] ? shift1 : a;
    assign out2 = amount[1] ? shift2 : out1;
    assign out3 = amount[2] ? shift3 : out2;
    assign out4 = amount[3] ? shift4 : out3;
    assign sra = amount[4] ? shift5 : out4;

endmodule