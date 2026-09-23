module mux5(math, and_result, or_result, sll_result, sra_result, opcode, result);
input [31:0] math;
input [31:0] and_result;
input [31:0] or_result;
input [31:0] sll_result;
input [31:0] sra_result;
input [4:0] opcode;
output [31:0] result;

wire sel_math;
   or(sel_math, opcode[1], opcode[2]);
wire [31:0] normal, logic, shift;
assign result = sel_math ? normal : math;
assign shift = opcode[0] ? sra_result : sll_result;
assign logic = opcode[0] ? or_result : and_result;
assign normal = opcode[2] ? shift : logic;

endmodule