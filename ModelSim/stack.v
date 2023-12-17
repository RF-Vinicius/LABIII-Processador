module stack
#(parameter WIDTH_DATA=16, parameter DEPTH=10)
(
    input clk,       
    input reset,     
    input  push,      
    input  pop,      
    input  [WIDTH_DATA-1:0] data_in, 
    output reg [WIDTH_DATA-1:0] data_out, 
    output reg full,   
    output reg empty   
);

reg [(WIDTH_DATA-1):0] stack[(DEPTH-1):0];
reg [(DEPTH-1):0] topPositionStack = 0, topPositionStack_next = 0;

always @(topPositionStack) begin
    full = (topPositionStack == 10'b1111111111);
    empty = (topPositionStack == 10'b0000000000);
end

always @(posedge clk) begin
    if (reset) begin
        data_out <= 0;
    end else begin
        if(push && !full) begin
            $display("Pushing %d", data_in);
            stack[topPositionStack] <= data_in;
        end
        else if (pop && !empty) begin
            $display("Popping %d", stack[topPositionStack - 1]);
            data_out <= stack[topPositionStack - 1];
        end
        // Todo: Tirar latches
    end
end

// Adicionando lógica combinatória para calcular novo valor de topPositionStack
always @* begin
    if (push && !full) begin
        topPositionStack_next = topPositionStack + 1;
    end
    else if (pop && !empty) begin
        topPositionStack_next = topPositionStack - 1;
    end
    else begin
        topPositionStack_next = topPositionStack;
    end
end

// Atribuindo novo valor de topPositionStack
always @(posedge clk) begin
    if (reset) begin
        topPositionStack <= 10'b0;
    end else begin
        topPositionStack <= topPositionStack_next;
    end
end

endmodule