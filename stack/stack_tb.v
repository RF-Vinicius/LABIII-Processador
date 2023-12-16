`timescale 1ns/1ns
`include "stack.v"

module stack_tb;
    reg clk;
    reg reset;
    reg push;
    reg pop;
    reg [31:0] data_in;
    wire [31:0] data_out;
    wire full;
    wire empty;

    // Instantiate the stack module
    stack #(.WIDTH_DATA(32), .DEPTH(10)) uut (
        .clk(clk),
        .reset(reset),
        .push(push),
        .pop(pop),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        push = 0;
        pop = 0;
        data_in = 0;

        // Apply reset
        #10;
        reset = 0;
        #10;

        // Test push operation
        push = 1;
        for (data_in = 1; data_in <= 5; data_in = data_in + 1) begin
            #10;
            //$display("Push: %d", data_in);
            if(full) begin
                $display("Stack is full!");
            end
        end
        push = 0;
        $display("\n");
        // Test pop operation
        pop = 1;
        while (!empty) begin
            #10;
            //$display("Pop: %d", data_out);
            if(empty) begin
                $display("Stack is empty!");
            end
        end
        pop = 0;

        $finish;
    end
endmodule