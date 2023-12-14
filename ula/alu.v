module alu #(
    parameter integer WIDTH_DATA = 32
    )(
    
    input wire [WIDTH_DATA - 1:0] operand_a,
    input wire [WIDTH_DATA - 1:0] operand_b,
  	input wire [4:0] op_code,
    output reg [WIDTH_DATA - 1:0] result

);

    // Paramenters ALU
    localparam ADD = 4;
    localparam SUB = 5;
    localparam MUL = 6;
    localparam DIV = 7;
    localparam AND = 8;
    localparam NAND = 9;
    localparam OR = 10;
    localparam XOR = 11;
    localparam CMP = 12;
    localparam NOT = 13;

    always @* begin
		result = 0;
        case (op_code)
            ADD: begin
                result = operand_a + operand_b;
                
            end
            SUB: begin
                result = operand_a - operand_b;
                
            end
            MUL: begin
                result = operand_a * operand_b;
                
            end
            DIV: begin
                if (operand_b != 0) begin
                    result = operand_a / operand_b;
                end else begin
                    result = 32'b0;
                end
            end
            AND: begin
                result = operand_a & operand_b;
            end
            NAND: begin
                result = ~(operand_a & operand_b);
            end
            OR: begin
                result = operand_a | operand_b;
            end
            NOT: begin
                result = ~operand_a;
            end
            CMP: begin
                if (operand_a == operand_b) begin
                    result = 0;
                end else if (operand_a > operand_b) begin
                    result = 1;
                end else begin
                    result = -1;
                end
            end
            default: begin
                result = 0;
            end
        endcase
    end
endmodule