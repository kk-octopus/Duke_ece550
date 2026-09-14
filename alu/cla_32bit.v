module cla_32bit(a, b, cin, Gi, Pi, out, cout, overflow);
    input [31:0] a;
    input [31:0] b;
    input cin;
    output Gi,Pi;
    output [31:0] out;
    output cout;
    output overflow;

    wire [1:0] G;
    wire [1:0] P;
    wire c1;
    wire [1:0] c2;
    wire [1:0] C;
    wire [1:0] block;
    wire [1:0] flow;
//ci = gi + pici;
    assign C[0] = cin;

genvar i;
    generate
        for(i = 0; i < 2; i = i + 1) begin : block_cla16
        cla_16bit Sixteen1(
            .a(a[16 * i + 15 : 16 * i]),
            .b(b[16 * i + 15 : 16 * i]),
            .cin(C[i]),

            .out(out[16 * i + 15 : 16 * i]), 
            .cout(block[i]), 
            .Gi(G[i]), 
            .Pi(P[i]),
            .overflow(flow[i])
            );

        end

    endgenerate

//C1 = G0 + P0c0;
    and(c1, P[0], cin);
    or(C[1], c1, G[0]);

assign cout = block[1];
assign overflow = flow[1];

endmodule