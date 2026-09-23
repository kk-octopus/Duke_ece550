module and32(a, b, out);
    input [31:0] a;
    input [31:0] b;

    output [31:0] out;

genvar i;
generate 
    for(i = 0; i < 32; i = i + 1)begin : and_32
    and(out[i], a[i], b[i]);
    end  
endgenerate

endmodule