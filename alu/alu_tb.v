`timescale 1ns / 1ps
`include "alu.v"

module alu_tb;
    reg [31:0] operand_a;
    reg [31:0] operand_b;
    reg [4:0] op_code;
    wire [31:0] result;

    // Instantiate the alu module
    alu #(.WIDTH_DATA(32)) uut (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .op_code(op_code),
        .result(result)
    );

    initial begin
        // Test ADD operation
        operand_a = 10;
        operand_b = 20;
        op_code = 4; // ADD
        #10;
        $display("ADD: %d + %d = %d", operand_a, operand_b, result);

        // Test SUB operation
        operand_a = 30;
        operand_b = 20;
        op_code = 5; // SUB
        #10;
        $display("SUB: %d - %d = %d", operand_a, operand_b, result);

        // Test MUL operation
        operand_a = 3;
        operand_b = 4;
        op_code = 6; // MUL
        #10;
        $display("MUL: %d * %d = %d", operand_a, operand_b, result);

        // Test DIV operation
        operand_a = 40;
        operand_b = 4;
        op_code = 7; // DIV
        #10;
        $display("DIV: %d / %d = %d", operand_a, operand_b, result);

        // Test AND operation
        operand_a = 1;
        operand_b = 0;
        op_code = 8; // AND
        #10;
        $display("AND: %b & %b = %b", operand_a, operand_b, result);

        // Test NAND operation
        operand_a = 1;
        operand_b = 0;
        op_code = 9; // NAND
        #10;
        $display("NAND: %b ~& %b = %b", operand_a, operand_b, result);

        // Test OR operation
        operand_a = 1;
        operand_b = 1;
        op_code = 10; // OR
        #10;
        $display("OR: %b | %b = %b", operand_a, operand_b, result);

        // Test NOT operation
        operand_a = 1;
        op_code = 13; // NOT
        #10;
        $display("NOT: ~ %b = %b", operand_a, result);

        // Test CMP operation
        operand_a = 10;
        operand_b = 10;
        op_code = 12; // CMP
        #10;
        $display("CMP result: %d ? %d = %d", operand_a, operand_b, result);

        $finish;
    end
endmodule