`timescale 1ns/1ns
`include "cpu.v"

module tb_cpu;

    // Parameters
    parameter WIDTH_DATA = 32;
    parameter AWIDTH = 5;

    // Signals
    reg clk;
    reg reset;
    reg [WIDTH_DATA-1:0] instruction;
    wire [AWIDTH-1:0] address_memory_inst;
    wire read_inst_enable;
    wire [WIDTH_DATA-1:0] memory_data_out;
    reg [WIDTH_DATA-1:0] memory_data_in;
    wire read_data_enable;
    wire write_data_enable;
    wire [9:0] address_memory_data;
    reg [WIDTH_DATA-1:0] result_alu;
    wire [WIDTH_DATA-1:0] operand_a;
    wire [WIDTH_DATA-1:0] operand_b;
    wire [3:0] op_ALU;

    // Instantiate the cpu module
    cpu #(.WIDTH_DATA(WIDTH_DATA), .AWIDTH(AWIDTH)) u_cpu (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .address_memory_inst(address_memory_inst),
        .read_inst_enable(read_inst_enable),
        .memory_data_out(memory_data_out),
        .memory_data_in(memory_data_in),
        .read_data_enable(read_data_enable),
        .write_data_enable(write_data_enable),
        .address_memory_data(address_memory_data),
        .result_alu(result_alu),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .op_ALU(op_ALU)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Reset generation
    initial begin
        reset = 0;
        #10 reset = 1;
        #20 reset = 0;
    end

    // Test stimuli
    initial begin
        // TODO: Add your test stimuli here
    end

endmodule