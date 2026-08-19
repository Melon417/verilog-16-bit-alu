// Self-Checking Testbench for 16-bit ALU
// Author: Mohammad Memon

`timescale 1ns/1ps

module alu_16bit_tb;

    logic [15:0] a;
    logic [15:0] b;
    logic [3:0]  op;

    logic [15:0] y;
    logic zero;
    logic carry;
    logic overflow;
    logic negative;

    int errors;
    int tests;

    localparam OP_ADD = 4'b0000;
    localparam OP_SUB = 4'b0001;
    localparam OP_AND = 4'b0010;
    localparam OP_OR  = 4'b0011;
    localparam OP_XOR = 4'b0100;
    localparam OP_NOT = 4'b0101;
    localparam OP_SHL = 4'b0110;
    localparam OP_SHR = 4'b0111;

    alu_16bit dut (
        .a(a),
        .b(b),
        .op(op),
        .y(y),
        .zero(zero),
        .carry(carry),
        .overflow(overflow),
        .negative(negative)
    );

    task check_result(
        input logic [15:0] expected_y,
        input logic expected_zero,
        input logic expected_carry,
        input logic expected_overflow,
        input logic expected_negative,
        input string test_name
    );
        begin
            tests++;
            #1;

            if (
                y        !== expected_y        ||
                zero     !== expected_zero     ||
                carry    !== expected_carry    ||
                overflow !== expected_overflow ||
                negative !== expected_negative
            ) begin
                $display("ERROR in %s", test_name);
                $display("  a=%h b=%h op=%b", a, b, op);
                $display("  Expected: y=%h zero=%b carry=%b overflow=%b negative=%b",
                         expected_y, expected_zero, expected_carry, expected_overflow, expected_negative);
                $display("  Got:      y=%h zero=%b carry=%b overflow=%b negative=%b",
                         y, zero, carry, overflow, negative);
                errors++;
            end else begin
                $display("PASS: %s", test_name);
            end
        end
    endtask

    initial begin
        errors = 0;
        tests  = 0;

        $display("Starting 16-bit ALU testbench...");

        // ADD normal
        a = 16'h0005;
        b = 16'h0003;
        op = OP_ADD;
        #1;
        check_result(16'h0008, 1'b0, 1'b0, 1'b0, 1'b0, "ADD normal");

        // ADD zero result
        a = 16'h0000;
        b = 16'h0000;
        op = OP_ADD;
        #1;
        check_result(16'h0000, 1'b1, 1'b0, 1'b0, 1'b0, "ADD zero");

        // ADD carry
        a = 16'hFFFF;
        b = 16'h0001;
        op = OP_ADD;
        #1;
        check_result(16'h0000, 1'b1, 1'b1, 1'b0, 1'b0, "ADD carry");

        // ADD signed overflow: 32767 + 1 = -32768 signed
        a = 16'h7FFF;
        b = 16'h0001;
        op = OP_ADD;
        #1;
        check_result(16'h8000, 1'b0, 1'b0, 1'b1, 1'b1, "ADD signed overflow");

        // SUB normal
        a = 16'h0008;
        b = 16'h0003;
        op = OP_SUB;
        #1;
        check_result(16'h0005, 1'b0, 1'b1, 1'b0, 1'b0, "SUB normal");

        // SUB zero
        a = 16'h0008;
        b = 16'h0008;
        op = OP_SUB;
        #1;
        check_result(16'h0000, 1'b1, 1'b1, 1'b0, 1'b0, "SUB zero");

        // SUB borrow
        a = 16'h0003;
        b = 16'h0008;
        op = OP_SUB;
        #1;
        check_result(16'hFFFB, 1'b0, 1'b0, 1'b0, 1'b1, "SUB borrow");

        // SUB signed overflow: 32767 - (-1) = signed overflow
        a = 16'h7FFF;
        b = 16'hFFFF;
        op = OP_SUB;
        #1;
        check_result(16'h8000, 1'b0, 1'b0, 1'b1, 1'b1, "SUB signed overflow");

        // AND
        a = 16'hF0F0;
        b = 16'h0FF0;
        op = OP_AND;
        #1;
        check_result(16'h00F0, 1'b0, 1'b0, 1'b0, 1'b0, "AND operation");

        // OR
        a = 16'hF0F0;
        b = 16'h0FF0;
        op = OP_OR;
        #1;
        check_result(16'hFFF0, 1'b0, 1'b0, 1'b0, 1'b1, "OR operation");

        // XOR
        a = 16'hAAAA;
        b = 16'h5555;
        op = OP_XOR;
        #1;
        check_result(16'hFFFF, 1'b0, 1'b0, 1'b0, 1'b1, "XOR operation");

        // NOT
        a = 16'h00FF;
        b = 16'h0000;
        op = OP_NOT;
        #1;
        check_result(16'hFF00, 1'b0, 1'b0, 1'b0, 1'b1, "NOT operation");

        // Shift left
        a = 16'h8001;
        b = 16'h0000;
        op = OP_SHL;
        #1;
        check_result(16'h0002, 1'b0, 1'b1, 1'b0, 1'b0, "SHL operation");

        // Shift right
        a = 16'h0003;
        b = 16'h0000;
        op = OP_SHR;
        #1;
        check_result(16'h0001, 1'b0, 1'b1, 1'b0, 1'b0, "SHR operation");

        // Default invalid op
        a = 16'h1234;
        b = 16'h5678;
        op = 4'b1111;
        #1;
        check_result(16'h0000, 1'b1, 1'b0, 1'b0, 1'b0, "Invalid operation default");

        $display("========================================");
        $display("ALU TEST SUMMARY");
        $display("Tests run: %0d", tests);
        $display("Errors:    %0d", errors);

        if (errors == 0) begin
            $display("ALL ALU TESTS PASSED");
        end else begin
            $display("ALU TESTS FAILED");
        end

        $display("========================================");

        $finish;
    end

endmodule
