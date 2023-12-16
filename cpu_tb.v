`timescale 1ns/1ns
`include "cpu.v"

module tb_cpu;
    // Parameters
    parameter WIDTH_DATA = 16;
    parameter AWIDTH = 5;

    reg clk;
    reg reset;

    // Instructions Memory
    reg [WIDTH_DATA-1:0] instruction;
    wire [AWIDTH-1:0] address_memory_inst;
    wire read_inst_enable;

    // Data Memory
    wire [WIDTH_DATA-1:0] memory_data_out;
    reg [WIDTH_DATA-1:0] memory_data_in;
    wire read_data_enable;
    wire write_data_enable;
    wire [9:0] address_memory_data;

    // ALU
    reg [WIDTH_DATA-1:0] result_alu;
    wire [WIDTH_DATA-1:0] operand_a;
    wire [WIDTH_DATA-1:0] operand_b;
    wire [3:0] op_ALU;

    // Stack operations
    reg stack_full_operations;
    reg [WIDTH_DATA -1 :0] stack_data_out_operations;
    wire stack_push_operations, stack_pop_operations; 
    wire [WIDTH_DATA -1 :0] stack_data_in_operations;

    // Stack subroutines
    reg stack_full_subroutines;
    reg [WIDTH_DATA -1 :0] stack_data_out_subroutines;
    wire stack_push_subroutines, stack_pop_subroutines; 
    wire [WIDTH_DATA -1 :0] stack_data_in_subroutines;

    // CPU module
    cpu #(.WIDTH_DATA(WIDTH_DATA), .AWIDTH(AWIDTH)) u_cpu (
        .clk(clk),
        .reset(reset),
        // Instructions Memory
        .instruction(instruction),
        .address_memory_inst(address_memory_inst),
        .read_inst_enable(read_inst_enable),
        // Data Memory
        .memory_data_out(memory_data_out),
        .memory_data_in(memory_data_in),
        .read_data_enable(read_data_enable),
        .write_data_enable(write_data_enable),
        .address_memory_data(address_memory_data),
        // ALU
        .result_alu(result_alu),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .op_ALU(op_ALU),
        // Stack operations
        .stack_full_operations(stack_full_operations),
        .stack_data_out_operations(stack_data_out_operations),
        .stack_push_operations(stack_push_operations),
        .stack_pop_operations(stack_pop_operations),
        .stack_data_in_operations(stack_data_in_operations),
        // Stack subroutines
        .stack_full_subroutines(stack_full_subroutines),
        .stack_data_out_subroutines(stack_data_out_subroutines),
        .stack_push_subroutines(stack_push_subroutines),
        .stack_pop_subroutines(stack_pop_subroutines),
        .stack_data_in_subroutines(stack_data_in_subroutines)
    );

    // Clock generation
    always #5 clk = ~clk;


    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;

        #10
        reset = 0;
        #10
        
        $display("\n-------CPU reseted-------\n");
        // Tests

        
        instruction = {5'd20, 11'd5};    // CALL
        #40
        $display("\n-------END CALL-------\n");

        instruction = {5'd20, 11'd5};    // CALL
        #40
        $display("\n-------END CALL-------\n");

        instruction = {5'd21, 11'd0};    // RET
        #50
        $display("\n-------END RET-------\n");
        


        /*
        instruction = {5'd1, 11'd5};    // PUSH_I
        #40
        $display("\n-------END PUSH_I-------\n");
        
        instruction = {5'd1, 11'd2};    // PUSH_I
        #40
        $display("\n-------END PUSH_I-------\n");

        instruction = {5'd4, 11'd0};    // ADD
        #70
        $display("\n-------END ADD-------\n");
        
        */
        $finish;
    end
endmodule