module wtm(a,b,out);
    input [4:0] a;
    input [4:0] b;
    output [9:0] out;

    wire c1;
    wire [1:0] c2;
    wire [2:0] c3;
    wire [3:0] c4;
    wire [3:0] c5;
    wire [2:0] c6;
    wire [1:0] c7;
    wire c8;

    wire s2;
    wire [1:0] s3;
    wire [2:0] s4;
    wire [2:0] s5;
    wire [1:0] s6;
    wire s7;

//row0
    assign out[0] = a[0] & b[0];

//row1 with one carry c1
    half_adder ha1(.a(a[1] & b[0]), .b(a[0] & b[1]), .sum(out[1]), .cout(c1));

//row2 with carry c2 [1:0]
    full_adder fa1 (.a(a[2] & b[0]), .b(a[1] & b[1]), .cin(a[0] & b[2]), .sum(s2), .cout(c2[1]));
    half_adder ha2(.a(c1), .b(s2), .sum(out[2]), .cout(c2[0]));

//row3 with carry c3 [2:0]
    full_adder fa2 (.a(a[3] & b[0]), .b(a[2] & b[1]), .cin(a[1] & b[2]), .sum(s3[1]), .cout(c3[2]));
    full_adder fa3 (.a(a[0] & b[3]), .b(s3[1]), .cin(c2[1]), .sum(s3[0]), .cout(c3[1]));
    half_adder ha3(.a(c2[0]), .b(s3[0]), .sum(out[3]), .cout(c3[0]));

//row4 with carry c4 [3:0]
    full_adder fa4 (.a(a[4] & b[0]), .b(a[3] & b[1]), .cin(a[2] & b[2]), .sum(s4[0]), .cout(c4[0]));
    full_adder fa5 (.a(a[1] & b[3]), .b(a[0] & b[4]), .cin(s4[0]), .sum(s4[1]), .cout(c4[1]));
    full_adder fa6 (.a(c3[2]), .b(c3[1]), .cin(c3[0]), .sum(s4[2]), .cout(c4[2]));
    half_adder ha4(.a(s4[2]), .b(s4[1]), .sum(out[4]), .cout(c4[3]));

//row5 with carry c5 [3:0]
    full_adder fa7 (.a(a[4] & b[1]), .b(a[3] & b[2]), .cin(a[2] & b[3]), .sum(s5[0]), .cout(c5[0]));
    full_adder fa8 (.a(a[1] & b[4]), .b(c4[3]), .cin(s5[0]), .sum(s5[1]), .cout(c5[1]));
    full_adder fa9 (.a(c4[2]), .b(c4[1]), .cin(c4[0]), .sum(s5[2]), .cout(c5[2]));
    half_adder ha5(.a(s5[2]), .b(s5[1]), .sum(out[5]), .cout(c5[3]));

//row6 with carry c6 [2:0]
    full_adder fa10 (.a(a[4] & b[2]), .b(a[3] & b[3]), .cin(a[2] & b[4]), .sum(s6[0]), .cout(c6[0]));
    full_adder fa11 (.a(c5[3]), .b(c5[2]), .cin(s6[0]), .sum(s6[1]), .cout(c6[1]));
    full_adder fa12 (.a(c5[1]), .b(c5[0]), .cin(s6[1]), .sum(out[6]), .cout(c6[2]));

//row7 with carry c7 [1:0]
    full_adder fa13 (.a(a[4] & b[3]), .b(a[3] & b[4]), .cin(c6[0]), .sum(s7), .cout(c7[0]));
    full_adder fa14 (.a(c6[1]), .b(c6[2]), .cin(s7), .sum(out[7]), .cout(c7[1]));

//row7 with carry c7/out[9]
    full_adder fa15 (.a(a[4] & b[4]), .b(c7[0]), .cin(c7[1]), .sum(out[8]), .cout(out[9]));

endmodule
