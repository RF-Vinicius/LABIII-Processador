`timescale 1ns / 1ps

module testbench;
    reg clk;
    reg reset;

    // Inicializar o módulo Processor0Address
    Processor0Address uut (
        .clk(clk),
        .reset(reset)
    );

    // Gerar um clock
    always begin
        #5 clk = ~clk;
    end

    // Gerar um reset
    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;
    end

    // Testar o módulo
    initial begin
        // Aqui você pode adicionar seu código para testar o módulo
        // Por exemplo, você pode alterar os valores de entrada e verificar os valores de saída
    end
endmodule