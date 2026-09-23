`timescale 1 ns / 100 ps
`default_nettype none

// Enhanced self-checking testbench for ECE 550 Project Checkpoint 2.
//
// This file intentionally uses behavioral operators in the reference model.
// The operator restrictions in the assignment apply to the DUT, not to the
// testbench.  Compile this file together with alu.v, but do not include any
// testbench in the final Gradescope submission zip.
module alu_tb_enhanced;

    localparam [4:0] OP_ADD = 5'b00000;
    localparam [4:0] OP_SUB = 5'b00001;
    localparam [4:0] OP_AND = 5'b00010;
    localparam [4:0] OP_OR  = 5'b00011;
    localparam [4:0] OP_SLL = 5'b00100;
    localparam [4:0] OP_SRA = 5'b00101;

    reg         clock;
    reg  [31:0] data_operandA;
    reg  [31:0] data_operandB;
    reg  [4:0]  ctrl_ALUopcode;
    reg  [4:0]  ctrl_shiftamt;

    wire [31:0] data_result;
    wire        isNotEqual;
    wire        isLessThan;
    wire        overflow;

    integer test_cases;
    integer checks;
    integer errors;
    integer index;
    integer seed;

    reg [31:0] walking_a;
    reg [31:0] walking_b;
    reg [31:0] random_a;
    reg [31:0] random_b;
    reg [4:0]  random_shift;

    alu dut(
        .data_operandA(data_operandA),
        .data_operandB(data_operandB),
        .ctrl_ALUopcode(ctrl_ALUopcode),
        .ctrl_shiftamt(ctrl_shiftamt),
        .data_result(data_result),
        .isNotEqual(isNotEqual),
        .isLessThan(isLessThan),
        .overflow(overflow)
    );

    // 50 MHz clock: a 20 ns period.  The ALU itself is combinational, but
    // changing inputs once per cycle also catches opcode/mux transition bugs.
    always #10 clock = ~clock;

    // Apply one vector just after a falling clock edge and check it after a
    // short combinational settling interval.  Compare flags only when the
    // assignment says they are meaningful for the selected operation.
    task check_case;
        input [4:0]  operation;
        input [31:0] operand_a;
        input [31:0] operand_b;
        input [4:0]  shift_amount;
        input [31:0] expected_result;
        input        expected_not_equal;
        input        expected_less_than;
        input        expected_overflow;
        input        check_compare_flags;
        input        check_overflow_flag;
        begin
            @(negedge clock);
            ctrl_ALUopcode = operation;
            data_operandA  = operand_a;
            data_operandB  = operand_b;
            ctrl_shiftamt  = shift_amount;
            #1;

            test_cases = test_cases + 1;
            checks = checks + 1;
            if (data_result !== expected_result) begin
                errors = errors + 1;
                $display("[FAIL result] case=%0d op=%b A=%h B=%h shamt=%0d expected=%h actual=%h",
                         test_cases, operation, operand_a, operand_b,
                         shift_amount, expected_result, data_result);
            end

            if (check_compare_flags) begin
                checks = checks + 1;
                if (isNotEqual !== expected_not_equal) begin
                    errors = errors + 1;
                    $display("[FAIL isNotEqual] case=%0d A=%h B=%h expected=%b actual=%b",
                             test_cases, operand_a, operand_b,
                             expected_not_equal, isNotEqual);
                end

                checks = checks + 1;
                if (isLessThan !== expected_less_than) begin
                    errors = errors + 1;
                    $display("[FAIL isLessThan] case=%0d A=%h (%0d) B=%h (%0d) expected=%b actual=%b",
                             test_cases, operand_a, $signed(operand_a),
                             operand_b, $signed(operand_b),
                             expected_less_than, isLessThan);
                end
            end

            if (check_overflow_flag) begin
                checks = checks + 1;
                if (overflow !== expected_overflow) begin
                    errors = errors + 1;
                    $display("[FAIL overflow] case=%0d op=%b A=%h B=%h result=%h expected=%b actual=%b",
                             test_cases, operation, operand_a, operand_b,
                             expected_result, expected_overflow, overflow);
                end
            end
        end
    endtask

    task run_add;
        input [31:0] operand_a;
        input [31:0] operand_b;
        input [4:0]  shift_amount;
        reg   [31:0] expected;
        reg          expected_overflow;
        begin
            expected = operand_a + operand_b;
            expected_overflow = (operand_a[31] == operand_b[31]) &&
                                (expected[31] != operand_a[31]);
            check_case(OP_ADD, operand_a, operand_b, shift_amount, expected,
                       1'b0, 1'b0, expected_overflow, 1'b0, 1'b1);
        end
    endtask

    task run_sub;
        input [31:0] operand_a;
        input [31:0] operand_b;
        input [4:0]  shift_amount;
        reg   [31:0] expected;
        reg          expected_not_equal;
        reg          expected_less_than;
        reg          expected_overflow;
        begin
            expected = operand_a - operand_b;
            expected_not_equal = (operand_a != operand_b);
            expected_less_than = ($signed(operand_a) < $signed(operand_b));
            expected_overflow = (operand_a[31] != operand_b[31]) &&
                                (expected[31] != operand_a[31]);
            check_case(OP_SUB, operand_a, operand_b, shift_amount, expected,
                       expected_not_equal, expected_less_than,
                       expected_overflow, 1'b1, 1'b1);
        end
    endtask

    task run_and;
        input [31:0] operand_a;
        input [31:0] operand_b;
        input [4:0]  shift_amount;
        reg   [31:0] expected;
        begin
            expected = operand_a & operand_b;
            check_case(OP_AND, operand_a, operand_b, shift_amount, expected,
                       1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
    endtask

    task run_or;
        input [31:0] operand_a;
        input [31:0] operand_b;
        input [4:0]  shift_amount;
        reg   [31:0] expected;
        begin
            expected = operand_a | operand_b;
            check_case(OP_OR, operand_a, operand_b, shift_amount, expected,
                       1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
    endtask

    task run_sll;
        input [31:0] operand_a;
        input [31:0] ignored_operand_b;
        input [4:0]  shift_amount;
        reg   [31:0] expected;
        begin
            expected = operand_a << shift_amount;
            check_case(OP_SLL, operand_a, ignored_operand_b, shift_amount,
                       expected, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
    endtask

    task run_sra;
        input [31:0] operand_a;
        input [31:0] ignored_operand_b;
        input [4:0]  shift_amount;
        reg   [31:0] expected;
        begin
            expected = $signed(operand_a) >>> shift_amount;
            check_case(OP_SRA, operand_a, ignored_operand_b, shift_amount,
                       expected, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
    endtask

    initial begin
        clock           = 1'b0;
        data_operandA   = 32'b0;
        data_operandB   = 32'b0;
        ctrl_ALUopcode  = OP_ADD;
        ctrl_shiftamt   = 5'b0;
        test_cases      = 0;
        checks          = 0;
        errors          = 0;
        seed            = 32'h5500C2;

        $display("============================================================");
        $display("Starting enhanced ECE 550 Checkpoint 2 ALU verification");
        $display("============================================================");

        // ADD boundaries and signed-overflow transitions.  Shift amount is
        // deliberately varied to ensure it is ignored for non-shift ops.
        run_add(32'h00000000, 32'h00000000, 5'd0);
        run_add(32'h00000000, 32'hFFFFFFFF, 5'd31);
        run_add(32'hFFFFFFFF, 32'h00000001, 5'd1);
        run_add(32'h7FFFFFFF, 32'h00000001, 5'd31);
        run_add(32'h7FFFFFFF, 32'h7FFFFFFF, 5'd0);
        run_add(32'h80000000, 32'hFFFFFFFF, 5'd16);
        run_add(32'h80000000, 32'h80000000, 5'd0);
        run_add(32'h40000000, 32'h40000000, 5'd7);
        run_add(32'h80000000, 32'h7FFFFFFF, 5'd3);
        run_add(32'hAAAAAAAA, 32'h55555555, 5'd29);

        // SUB, strict signed comparison, equality, and overflow boundaries.
        run_sub(32'h00000000, 32'h00000000, 5'd0);
        run_sub(32'hFFFFFFFF, 32'hFFFFFFFF, 5'd31);
        run_sub(32'h7FFFFFFF, 32'h7FFFFFFF, 5'd17);
        run_sub(32'h80000000, 32'h80000000, 5'd23);
        run_sub(32'hAAAAAAAA, 32'hAAAAAAAA, 5'd9);
        run_sub(32'h00000001, 32'h00000000, 5'd5);
        run_sub(32'h00000000, 32'h00000001, 5'd27);
        run_sub(32'hFFFFFFFF, 32'h00000000, 5'd0); // -1 < 0
        run_sub(32'h00000000, 32'hFFFFFFFF, 5'd0); // 0 > -1
        run_sub(32'h80000000, 32'h7FFFFFFF, 5'd0); // INT_MIN < INT_MAX
        run_sub(32'h7FFFFFFF, 32'h80000000, 5'd0); // INT_MAX > INT_MIN
        run_sub(32'h80000000, 32'hFFFFFFFF, 5'd0); // INT_MIN < -1
        run_sub(32'hFFFFFFFF, 32'h80000000, 5'd0); // -1 > INT_MIN
        run_sub(32'h80000000, 32'h00000001, 5'd0); // negative overflow
        run_sub(32'h7FFFFFFF, 32'hFFFFFFFF, 5'd0); // positive overflow
        run_sub(32'h80000001, 32'h7FFFFFFF, 5'd0);
        run_sub(32'hFFFFFFFE, 32'hFFFFFFFF, 5'd0); // -2 < -1

        // Basic AND/OR boundaries, complements, alternating bits, and MSB.
        run_and(32'h00000000, 32'h00000000, 5'd0);
        run_and(32'hFFFFFFFF, 32'h00000000, 5'd31);
        run_and(32'h00000000, 32'hFFFFFFFF, 5'd1);
        run_and(32'hFFFFFFFF, 32'hFFFFFFFF, 5'd30);
        run_and(32'hAAAAAAAA, 32'h55555555, 5'd13);
        run_and(32'hF0F0F0F0, 32'h0FF00FF0, 5'd22);
        run_and(32'h80000000, 32'h7FFFFFFF, 5'd9);

        run_or(32'h00000000, 32'h00000000, 5'd31);
        run_or(32'hFFFFFFFF, 32'h00000000, 5'd0);
        run_or(32'h00000000, 32'hFFFFFFFF, 5'd16);
        run_or(32'hFFFFFFFF, 32'hFFFFFFFF, 5'd7);
        run_or(32'hAAAAAAAA, 32'h55555555, 5'd3);
        run_or(32'hF0F0F0F0, 32'h0FF00FF0, 5'd28);
        run_or(32'h80000000, 32'h7FFFFFFF, 5'd4);

        // Walking-one tests catch every individual bit slice and cross-bit
        // wiring mistakes in both logic operations.
        for (index = 0; index < 32; index = index + 1) begin
            walking_a = 32'h00000001 << index;
            walking_b = 32'h00000001 << ((index + 1) % 32);
            run_and(walking_a, walking_a, index);
            run_and(walking_a, walking_b, 31 - index);
            run_or(walking_a, walking_a, index);
            run_or(walking_a, walking_b, 31 - index);
        end

        // Exhaust all legal shift amounts (0..31) using zero, positive,
        // negative, end-bit, and alternating-bit patterns.  Operand B changes
        // as well, ensuring that the shifters do not accidentally depend on it.
        for (index = 0; index < 32; index = index + 1) begin
            run_sll(32'h00000000, 32'hFFFFFFFF, index);
            run_sll(32'h00000001, 32'hDEADBEEF, index);
            run_sll(32'hFFFFFFFF, 32'h00000000, index);
            run_sll(32'h80000001, 32'h12345678, index);
            run_sll(32'hA5A5A5A5, 32'h5A5A5A5A, index);

            run_sra(32'h00000000, 32'hFFFFFFFF, index);
            run_sra(32'h7FFFFFFF, 32'hDEADBEEF, index);
            run_sra(32'h80000000, 32'h00000000, index);
            run_sra(32'hFFFFFFFF, 32'h12345678, index);
            run_sra(32'hA5A5A5A5, 32'h5A5A5A5A, index);
        end

        // Deterministic pseudo-random regression.  The seed is fixed so that
        // any failure is reproducible.  Every operation receives 100 vectors.
        for (index = 0; index < 100; index = index + 1) begin
            random_a     = $random(seed);
            random_b     = $random(seed);
            random_shift = $random(seed);

            run_add(random_a, random_b, random_shift);
            run_sub(random_a, random_b, random_shift);
            run_and(random_a, random_b, random_shift);
            run_or (random_a, random_b, random_shift);
            run_sll(random_a, random_b, random_shift);
            run_sra(random_a, random_b, random_shift);
        end

        $display("============================================================");
        $display("Completed %0d test cases and %0d signal checks.",
                 test_cases, checks);
        if (errors == 0) begin
            $display("PASS: all checks completed without errors.");
        end
        else begin
            $display("FAIL: %0d of %0d signal checks failed.", errors, checks);
        end
        $display("============================================================");
        $finish;
    end

endmodule

`default_nettype wire
