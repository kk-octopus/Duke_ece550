module decoder32(sel,reg_num);
input [4:0] sel;
output [31:0] reg_num;

genvar i;
generate 
    for(i = 0; i < 32; i = i + 1) begin: decoder
    localparam [4:0] index = i;
    wire [4:0] diff;
    assign diff = index ^ sel;
    nor(reg_num[i], diff[0], diff[1], diff[2], diff[3], diff[4]);
    end
endgenerate
endmodule