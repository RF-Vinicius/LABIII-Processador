module cpu #(
    parameter integer WIDTH_DATA = 32, parameter integer AWIDTH = 5
    )(
        input wire clk,
        input wire rst,

        // Instruction memory
        input wire [WIDTH_DATA-1:0] instruction,
        output reg [AWIDTH-1:0] address_memory_inst,
        output reg read_inst_enable,

        // Data memory
        output reg [WIDTH_DATA-1:0] memory_data_out,
        input wire [WIDTH_DATA-1:0] memory_data_in,
        output reg read_data_enable,
        output reg write_data_enable
        output reg [9:0] address_memory_data,

        // ALU
        input wire [WIDTH_DATA-1:0] result_alu,        
        output reg  [WIDTH_DATA-1:0] operand_a,
        output reg  [WIDTH_DATA-1:0] operand_b,
        output reg  [3:0] op_ALU,

        // Stack operations

        // Stack subroutines
    );

    localparam PUSH = 0;
    localparam PUSH_I = 1;
    localparam PUSH_T = 2;
    localparam POP = 3;
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
    localparam GOTO = 14;
    localparam IF_EQ = 15;
    localparam IF_GT = 16;
    localparam IF_LT = 17;
    localparam IF_GE = 18;
    localparam IF_LE = 19;
    localparam CALL = 20;
    localparam RET = 21;

// TODO : criar os estados restantes
    localparam GET_INST = 0;
    localparam DECODE = 1;
    localparam POP_TEMP1 = 2;
    localparam POP_TEMP2 = 3;
    localparam OP_ALU = 4;
    localparam PUSH_OP_RESULT = 5;
    localparam INC_PCOUNTER = 6;
    localparam READ_MEMO = 7;
    localparam PUSH_SUBROUTINE = 8;
    localparam GET_INST = 9;
    localparam GET_INST = 10;
    localparam GET_INST = 11;
    localparam GET_INST = 12;
    localparam GET_INST = 13;

    // Control signals
    reg [4:0] operation;
    reg [BASE_WIDTH -6 :0] operand;
    reg [5:0] state, next_state;

    // Registers
    reg [WIDTH_DATA-1:0] temp1, temp2, TOS;

    // PCOUNTER
    reg [AWIDTH-1:0] pcounter;

    // stack_operations
    wire stack_push_operations, stack_pop_operations, stack_full_operations;
    reg [BASE_WIDTH -1 :0] stack_data_in_operations,
    reg [BASE_WIDTH -1 :0] stack_data_out_operations,

    stack #(.WIDTH_DATA(WIDTH_DATA), .DEPTH(32)) stack_operations (
        .clk(clk),
        .rst(rst),
        .push(stack_push_operations),
        .pop(stack_pop_operations),
        .data_in(stack_data_in_operations),
        .data_out(stack_data_out_operations),
        .full(stack_full_operations)
    );

    // stack_subroutines
    wire stack_push_subroutines, stack_pop_subroutines, stack_full_subroutines;
    reg [BASE_WIDTH -1 :0] stack_data_in_subroutines,
    reg [BASE_WIDTH -1 :0] stack_data_out_subroutines,

    stack #(.WIDTH_DATA(WIDTH_DATA), .DEPTH(32)) stack_subroutines (
        .clk(clk),
        .rst(rst),
        .push(stack_push_subroutines),
        .pop(stack_pop_subroutines),
        .data_in(stack_data_in_subroutines),
        .data_out(stack_data_out_subroutines),
        .full(stack_full_subroutines)
    );

    // ALU

    alu alu_cpu (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .op_code(instruction[31:27]),
        .result(result_alu)
    );
    // Todo: Instanciar ULA

    assign operation = instruction[WIDTH_DATA - 1 +: 5];
    assign operand = instruction[WIDTH_DATA - 6 : 0];

    always @(posedge clk) begin
        if(rst) begin
            state <= LOAD_INST;
            pcounter <= 0;
            //Verificar quais outras flags precisam zerar.
        end
        else begin
            state <= next_state;

            case (next_state)  
                PCOUNTER_INC:   pcounter <= pcounter + 1;

                default:        pcounter <= pcounter;
                
            endcase
            
        end
    end

    always @(*) begin
        case (state)
            LOAD_INST : begin
                next_state = GET_INST;
                address_memory_inst = pcounter;
                read_inst_enable = 1;
            end
            GET_INST : begin    //TODO : criar esse novo estado no miro
                next_state = DECODE;
                read_inst_enable = 0;
                // instruction is updated from the instruction memory
            end
            PCOUNTER_INC : begin 
                next_state = LOAD_INST;
                stack_push_operations = 0;
                stack_pop_operations = 0;
                write_data_enable = 0;                
                stack_push_operations = 0;
            end
            DECODE : begin
                case (operation)
                    PUSH: begin
                        next_state = GET_DATA;
                        read_data_enable = 1;
                        address_memory_data = operand;
                    end
                    PUSH_I: begin
                        next_state = PUSH_STACK; 
                        stack_data_in_operations = operand;
                        stack_push_operations = 1; //Both data must be stable in the next clock                
                    end
                    PUSH_T: begin
                        next_state = PCOUNTER_INC;
                        stack_data_in_operations = temp1;
                        stack_push_operations = 1;     
                    end             
                    POP: begin
                        next_state = ENABLE_WRITE_DATA;
                        TOS = stack_data_out_operations;  // Unstack
                        stack_pop_operations = 1;
                    end
                    ADD, SUB, MUL, DIV, AND, NAND, OR, XOR, CMP, NOT: begin
                        next_state = POP_TEMP1;
                    end
                    GOTO: begin
                        next_state = LOAD_INST;
                        pcounter <= operand; // To do: Verificar depois se não conseguimos tirar o latch
                    end
                    IF_EQ: begin
                        next_state = POP_IF_EQ;
                        stack_pop_operations = 1;
                    end  
                    IF_GT: begin
                        next_state = POP_IF_GT;
                        stack_pop_operations = 1;
                    end                      
                    IF_LT: begin
                        next_state = POP_IF_LT;
                        stack_pop_operations = 1;
                    end  
                    IF_GE: begin
                        next_state = POP_IF_GE;
                        stack_pop_operations = 1;
                    end                      
                    IF_LE: begin
                        next_state = POP_IF_LE;
                        stack_pop_operations = 1;
                    end 
                    CALL: begin
                        next_state = PUSH_SUBROUTINE;
                        stack_data_in_subroutines = pcounter;
                        stack_push_subroutines = 1;
                    end
                    RET:
                        next_state = POP_SUBROUTINE;
                        stack_pop_subroutines = 1;
                    default:
                        next_state = 0;
                endcase                
            end
            POP_TEMP1 : begin
                next_state = POP_TEMP2;
                operand_a = stack_data_out_operations;
                stack_pop_operations = 1;                
            end
            POP_TEMP2 : begin
                next_state = OP_ALU;
                operand_b = stack_data_out_operations;  // ToDo : Testar se tá pegando o segundo operando corretamente
                stack_pop_operations = 1;                
            end
            OP_ALU : begin
                next_state = PUSH_OP_RESULT;
                op_ALU = operation;
            end
            PUSH_OP_RESULT : begin
                next_state = PCOUNTER_INC;
                stack_data_in_operations = result_alu;
                stack_push_operations = 1;                 
            end
            INC_PCOUNTER : begin
                
            end            
            GET_DATA : begin
                next_state = PUSH_M;
                stack_push_operations = 1;
                // memory data in is updated from the instruction memory
            end
            PUSH_M : begin
                next_state = PCOUNTER_INC;
                stack_data_in_operations = memory_data_in;
                stack_push_operations = 0;
            end
            ENABLE_WRITE_DATA : begin
                next_state = PCOUNTER_INC;
                write_data_enable = 1;
            end
            WRITE_DATA : begin
                next_state = PCOUNTER_INC;
                memory_data_out = TOS;                
            end
            POP_IF_EQ : begin  
                next_state = CMP_IF_EQ;
                Temp1 = stack_data_out_operations;
                stack_pop_operations = 0;
            end
            CMP_IF_EQ : begin
                if (Temp1 == 0) begin
                    next_state = LOAD_INST;
                    pcounter = operand;
                end
                else begin
                    next_state = PCOUNTER_INC;
                end
            end 

            POP_IF_GT : begin       // ToDo: Revisar tudo de push e pop para seguir esse modelo da IF_GT
                next_state = CMP_IF_GT;
                Temp1 = stack_data_out_operations;
                stack_pop_operations = 0;
            end
            CMP_IF_GT : begin
                if (Temp1 > 0) begin
                    next_state = LOAD_INST;
                    pcounter = operand;
                end
                else begin
                    next_state = PCOUNTER_INC;
                end
            end

            POP_IF_LT : begin  
                next_state = CMP_IF_LT;
                Temp1 = stack_data_out_operations;
                stack_pop_operations = 0;
            end
            CMP_IF_LT : begin
                if (Temp1 < 0) begin
                    next_state = LOAD_INST;
                    pcounter = operand;
                end
                else begin
                    next_state = PCOUNTER_INC;
                end
            end 
            POP_IF_GE : begin  
                next_state = CMP_IF_GE;
                Temp1 = stack_data_out_operations;
                stack_pop_operations = 0;
            end
            CMP_IF_GE : begin
                if (Temp1 >= 0) begin
                    next_state = LOAD_INST;
                    pcounter = operand;
                end
                else begin
                    next_state = PCOUNTER_INC;
                end
            end   
            POP_IF_LE : begin  
                next_state = CMP_IF_LE;
                Temp1 = stack_data_out_operations;
                stack_pop_operations = 0;
            end
            CMP_IF_LE : begin
                if (Temp1 <= 0) begin
                    next_state = LOAD_INST;
                    pcounter = operand;
                end
                else begin
                    next_state = PCOUNTER_INC;
                end
            end
            PUSH_SUBROUTINE : begin
                next_state = UPDATE_PCOUNTER;
                stack_push_subroutines = 0;
            end                    
            POP_SUBROUTINE : begin
                next_state = UPDATE_PCOUNTER;
                operand = stack_data_out_subroutines;
                stack_pop_subroutines = 0;
            end
            UPDATE_PCOUNTER : begin
                next_state = LOAD_INST;
                pcounter = operand;
            end            
        endcase

    end
endmodule

