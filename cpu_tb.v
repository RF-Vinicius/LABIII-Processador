`timescale 1ns/1ns
`include "cpu.v"

module tb_cpu;
    // Parameters
    parameter WIDTH_DATA = 16;
    parameter AWIDTH = 5;

    reg clk;
    reg reset;
    reg [WIDTH_DATA-1:0] instruction;

    // CPU module
    cpu #(.WIDTH_DATA(WIDTH_DATA), .AWIDTH(AWIDTH)) u_cpu (
        .clk(clk),
        .reset(reset),
        .instruction(instruction)
    );

    // Clock generation
    always #5 clk = ~clk;


    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        #10
        reset = 0;

        $display("\n-------CPU reseted-------\n");

        #10

        // Tests

        instruction = {5'd20, 11'd5};    // CALL
        #40
        $display("\n-------END CALL-------\n");

        instruction = {5'd20, 11'd4};    // CALL
        #40
        $display("\n-------END CALL-------\n");

        instruction = {5'd21, 11'd0};    // RET
        #80
        $display("\n-------END RET-------\n");
        


        /*
        instruction = {5'd1, 11'd5};    // PUSH_I
        #40
        $display("\n-------END PUSH_I-------\n");
        
        instruction = {5'd1, 11'd2};    // PUSH_I
        #40
        $display("\n-------END PUSH_I-------\n");

        instruction = {5'd4, 11'd0};    // ADD
        #80
        $display("\n-------END ADD-------\n");
        */
        
        $finish;
    end
endmodule