`timescale 1ns/1ns
module PilhaInstrucoes_tb;
reg clk, reset, push, pop;
reg [3:0] data_in;
wire [3:0] data_out;
wire full;
wire empty;

PilhaInstrucoes #(4, 10) uut (
  .clk(clk),
  .reset(reset),
  .push(push),
  .pop(pop),
  .data_in(data_in),
  .data_out(data_out),
  .full(full),
  .empty(empty)
);


//Definição do clock
initial begin
    clk = 1'b0;
    forever #1 clk = ~clk;
end


initial begin
    reset = 1'b1;
        #2;
    reset = 1'b0;
end


initial begin
    //PUSH 01
    #2;
    data_in <= 4'b1010;
    push = 1'b1;
    #1;
    push = 1'b0;

    #1;

    //PUSH 02
    data_in <= 4'b1111;
    push = 1'b1;
    #1;
    push = 1'b0;

    #1;

    //PUSH 03
    data_in <= 4'b0001;
    push = 1'b1;
    #1;
    push = 1'b0;

    #1;

    //PUSH 04
    data_in <= 4'b1010;
    push = 1'b1;
    #1;
    push = 1'b0;

    #1;

    //POP 01
    pop = 1;
    #1;
    pop = 0;
    #1;

    //POP 02
    pop = 1;
    #1;
    pop = 0;
    #1;

    //PUSH 05
    data_in <= 4'b1100;
    push = 1'b1;
    #1;
    push = 1'b0;

    #1;
end


endmodule