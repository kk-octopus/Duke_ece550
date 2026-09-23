module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //

//if subtract, -b = ~b + 1;
   wire [31:0] B;
   wire [31:0] B_in;
   wire cout;
   wire [32:0] equal_result;
   wire less_result;
   wire [31:0] data;
   wire [31:0] and_result, or_result, sll_result, sra_result;
genvar i;
   generate 
      for(i = 0; i < 32; i = i + 1) begin: twos_complement
         xor(B[i],data_operandB[i],ctrl_ALUopcode[0]);
      end
   endgenerate
   assign B_in = ctrl_ALUopcode[0] ? B : data_operandB;

   cla_32bit adder_32(.a(data_operandA), 
                     .b(B_in), 
                     .cin(ctrl_ALUopcode[0]), 
                     .Gi(), 
                     .Pi(), 
                     .out(data), 
                     .cout(cout), 
                     .overflow(overflow)
                     );
assign equal_result[0] = 1'b0;
genvar j;
   generate 
      for(j = 0; j < 32; j = j + 1) begin: equal_module
      or(equal_result[j+1],data_result[j],equal_result[j]);
      end
   endgenerate 
   assign isNotEqual = equal_result[32];
   xor (isLessThan, data_result[31], overflow);

   and32 result_and(.a(data_operandA), .b(data_operandB), .out(and_result));
   or32 result_or(.a(data_operandA), .b(data_operandB), .out(or_result));
   sll result_sll(.a(data_operandA), .amount(ctrl_shiftamt), .sll(sll_result));
   sra result_sra(.a(data_operandA), .amount(ctrl_shiftamt), .sra(sra_result));
   mux5 choose(.math(data), 
               .and_result(and_result), 
               .or_result(or_result), 
               .sll_result(sll_result), 
               .sra_result(sra_result), 
               .opcode(ctrl_ALUopcode), 
               .result(data_result)
               );

endmodule
