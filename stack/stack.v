module stack
#(parameter WIDTH_DATA=32, parameter DEPTH=10)
(
  input clk,       
  input reset,     
  input  push,      
  input  pop,      
  input  [(WIDTH_DATA-1):0] data_in, 
  output reg [(WIDTH_DATA-1):0] data_out, 
  output  full,   
  output  empty   
);

reg [(WIDTH_DATA-1):0] stack[(DEPTH-1):0];
reg [(DEPTH-1):0] topPositionStack, topPositionStack_next;


assign full = (topPositionStack == 10'b1111111111);
assign empty = (topPositionStack == 10'b0000000000);

always @(posedge clk) begin
    if (reset) begin
        topPositionStack <= 10'b0;
    end else begin
        if(push && !full) begin
            stack[topPositionStack] <= data_in;
        end
        else if (pop && !empty) begin
            data_out <= stack[topPositionStack - 1];
        end
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
    if (!reset) begin
        topPositionStack <= topPositionStack_next;
    end
end

endmodule