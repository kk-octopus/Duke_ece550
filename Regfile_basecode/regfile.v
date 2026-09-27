module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;

   /* YOUR CODE HERE */
wire [31:0] reg_data [0:31];
wire [31:0] reg_enable;

//write decoder:
wire [31:0] sel_enable;
decoder32 decode_w(
    .sel(ctrl_writeReg),
    .reg_num(sel_enable)
    );

//reg_select enable signal
genvar j;
generate
    for(j = 0; j < 32; j = j + 1) begin: reg_select
        and(reg_enable[j],ctrl_writeEnable, sel_enable[j]);
    end
endgenerate

//connect input data to register, waiting for the enable logic
genvar i;
generate 
    for(i = 1; i < 32; i = i + 1) begin: reg_group
    dffe ff (
            .q(reg_data[i]), 
            .d(data_writeReg), 
            .clk(clock), 
            .en(reg_enable[i]), 
            .clr(ctrl_reset)
            );
end
endgenerate
wire [31:0] regA_enable, regB_enable;

//regA
decoder32 regA(
    .sel(ctrl_readRegA),
    .reg_num(regA_enable)
    );

//regB
decoder32 regB(
    .sel(ctrl_readRegB),
    .reg_num(regB_enable)
    );

//R0 constrain
assign reg_data[0] = 32'b0;

//reg A buff
genvar a;
generate
    for(a = 0; a < 32; a = a + 1) begin: read_a
assign data_readRegA = regA_enable[a] ? reg_data[a] : 32'bz; 
    end
endgenerate

//reg B buff
genvar b;
generate
    for(b = 0; b < 32; b = b + 1) begin: read_b
assign data_readRegB = regB_enable[b] ? reg_data[b] : 32'bz; 
    end
endgenerate

endmodule
