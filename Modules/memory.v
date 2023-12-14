module memory
#(parameter WIDTH_DATA=32, parameter DEPTH=5)
(
  input clk,           
  input  read_enable,      
  input  write_enable,      
  input  [(WIDTH_DATA-1):0] data_in,
  input  [DEPTH - 1: 0] address,
  output reg [(WIDTH_DATA-1):0] data_out,  
);


reg [(WIDTH_DATA-1):0] mem[(DEPTH-1):0];


always @(posedge clk) begin

    if(write_enable) begin
        mem[address] <= data_in;
    end
    else if (read_enable) begin
        data_out <= mem[address];
    end
    
end

endmodule