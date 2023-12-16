`include "alu/alu.v"
`include "stack/stack.v"

module cpu #(
    parameter integer WIDTH_DATA = 16, parameter integer AWIDTH = 5
    )(
        input wire clk,
        input wire reset,

        // Instruction memory
        input wire [WIDTH_DATA-1:0] instruction,
        output reg [AWIDTH-1:0] address_memory_inst,
        output reg read_inst_enable,

        // Data memory
        output reg [WIDTH_DATA-1:0] memory_data_out,
        input wire [WIDTH_DATA-1:0] memory_data_in,
        output reg read_data_enable,
        output reg write_data_enable,
        output reg [9:0] address_memory_data,

        // ALU
        input wire [WIDTH_DATA-1:0] result_alu,        
        output reg  [WIDTH_DATA-1:0] operand_a,
        output reg  [WIDTH_DATA-1:0] operand_b,
        output reg  [3:0] op_ALU,

        // Stack operations
        input wire stack_full_operations,
        input wire stack_empty_operations,
        output reg stack_push_operations, 
        output reg stack_pop_operations, 
        input wire [WIDTH_DATA -1 :0] stack_data_out_operations,
        output reg [WIDTH_DATA -1 :0] stack_data_in_operations,

        // Stack subroutines
        input wire stack_full_subroutines,
        input wire stack_empty_subroutines,
        output reg stack_push_subroutines, 
        output reg stack_pop_subroutines, 
        input wire [WIDTH_DATA -1 :0] stack_data_out_subroutines,
        output reg [WIDTH_DATA -1 :0] stack_data_in_subroutines

    );

    // Instructions
    localparam PUSH      = 0;
    localparam PUSH_I    = 1;
    localparam PUSH_T    = 2;
    localparam POP       = 3;
    localparam ADD       = 4;
    localparam SUB       = 5;
    localparam MUL       = 6;
    localparam DIV       = 7;
    localparam AND       = 8;
    localparam NAND      = 9;
    localparam OR        = 10;
    localparam XOR       = 11;
    localparam CMP       = 12;
    localparam NOT       = 13;
    localparam GOTO      = 14;
    localparam IF_EQ     = 15;
    localparam IF_GT     = 16;
    localparam IF_LT     = 17;
    localparam IF_GE     = 18;
    localparam IF_LE     = 19;
    localparam CALL      = 20;
    localparam RET       = 21;

    // States
    localparam LOAD_INST            = 0;
    localparam GET_INST             = 1;
    localparam PCOUNTER_INC         = 2;
    localparam DECODE               = 3;
    localparam POP_TEMP1            = 4;
    localparam POP_TEMP2            = 5;
    localparam OP_ALU               = 6;
    localparam PUSH_OP_RESULT       = 7;
    localparam GET_DATA             = 8;
    localparam PUSH_M               = 9;
    localparam ENABLE_WRITE_DATA    = 11;
    localparam WRITE_DATA           = 13;
    localparam POP_IF_EQ            = 14;
    localparam CMP_IF_EQ            = 15;
    localparam POP_IF_GT            = 16;
    localparam CMP_IF_GT            = 17;
    localparam POP_IF_LT            = 18;
    localparam CMP_IF_LT            = 19;
    localparam POP_IF_GE            = 20;
    localparam CMP_IF_GE            = 21;
    localparam POP_IF_LE            = 22;
    localparam CMP_IF_LE            = 23;
    localparam PUSH_SUBROUTINE      = 24;
    localparam POP_SUBROUTINE       = 25;
    localparam UPDATE_PCOUNTER      = 26;
    localparam GET_TEMP1            = 27;
    localparam GET_TEMP2            = 28;

    // PCOUNTER
    reg [AWIDTH-1:0] pcounter = 0;

    // ALU
    alu  #(.WIDTH_DATA(WIDTH_DATA))alu_cpu (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .op_code(instruction[WIDTH_DATA-1:WIDTH_DATA-5]),
        .result(result_alu)
    );

    // stack_operations
    stack #(.WIDTH_DATA(WIDTH_DATA), .DEPTH(32)) stack_operations (
        .clk(clk),
        .reset(reset),
        .push(stack_push_operations),
        .pop(stack_pop_operations),
        .data_in(stack_data_in_operations),
        .data_out(stack_data_out_operations),
        .full(stack_full_operations),
        .empty(smp_empty_operations)
    );

    // stack_subroutines
    stack #(.WIDTH_DATA(WIDTH_DATA), .DEPTH(32)) stack_subroutines (
        .clk(clk),
        .reset(reset),
        .push(stack_push_subroutines),
        .pop(stack_pop_subroutines),
        .data_in(stack_data_in_subroutines),
        .data_out(stack_data_out_subroutines),
        .full(stack_full_subroutines),
        .empty(stack_empty_subroutines)
    );

    // Registers
    reg [WIDTH_DATA-1:0] Temp1 = 0, Temp2 = 0, TOS = 0;

    // Control signals
    reg [4:0] operation = 0;
    reg [WIDTH_DATA -6 :0] operand = 0;
    reg [5:0] state = 0, next_state = 0;

    // Attribute instruction to operation and operand
    always @(instruction) begin
        operation = instruction[WIDTH_DATA-1:WIDTH_DATA-5];
        operand = instruction[WIDTH_DATA-5:0];

        $display("instruction: %b", instruction);
        $display("operation: %b", operation);
        $display("operand: %b\n", operand);

        operand = instruction[WIDTH_DATA - 6 : 0];
    end

    always @(posedge clk) begin
        //$display("CLK - %d \t - stack_data_out_operations: %d",  clk, stack_data_out_operations);  
        if(reset) begin
            state <= LOAD_INST;
            pcounter <= 0;
            Temp1 = 0;
            Temp2 = 0;
            TOS = 0;
            next_state <= 0;
            stack_push_operations <= 0;
            stack_pop_operations <= 0;
            stack_data_in_operations <= 0;
            stack_push_subroutines <= 0;
            stack_pop_subroutines <= 0;
            stack_data_in_subroutines <= 0;
            operand_a <= 0;
            operand_b <= 0;
            //Todo: Verificar quais outras flags precisam zerar.
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
                $display("State - LOAD_INST");
                $display("pcounter: %d", pcounter);
                next_state = GET_INST;
                address_memory_inst = pcounter;
                read_inst_enable = 1;
            end
            GET_INST : begin    //TODO : criar esse novo estado no miro
                $display("State - GET_INST");
                next_state = DECODE;
                read_inst_enable = 0;
                // instruction is updated from the instruction memory
            end
            PCOUNTER_INC : begin 
                $display("State - PCOUNTER_INC");
                next_state = LOAD_INST;
                stack_push_operations = 0;
                stack_pop_operations = 0;
                write_data_enable = 0;                
                stack_push_operations = 0;
            end
            DECODE : begin
                $display("State - DECODE");
                case (operation)
                    PUSH: begin
                        $display("OP - PUSH");
                        next_state = GET_DATA;
                        read_data_enable = 1;
                        address_memory_data = operand;
                    end
                    PUSH_I: begin
                        $display("OP - PUSH_I");
                        next_state = PCOUNTER_INC; 
                        stack_data_in_operations = operand;
                        stack_push_operations = 1; //Both data must be stable in the next clock                
                    end
                    PUSH_T: begin
                        $display("OP - PUSH_T");
                        next_state = PCOUNTER_INC;
                        stack_data_in_operations = Temp1;
                        stack_push_operations = 1;     
                    end             
                    POP: begin
                        $display("OP - POP");
                        next_state = ENABLE_WRITE_DATA;
                        stack_pop_operations = 1;
                    end
                    ADD, SUB, MUL, DIV, AND, NAND, OR, XOR, CMP, NOT: begin
                        $display("OP - OP_ALU");
                        next_state = POP_TEMP1;
                    end
                    GOTO: begin
                        $display("OP - GOTO");
                        next_state = LOAD_INST;
                        pcounter <= operand; // To do: Verificar depois se não conseguimos tirar o latch
                    end
                    IF_EQ: begin
                        $display("OP - IF_EQ");
                        next_state = POP_IF_EQ;
                        stack_pop_operations = 1;
                    end  
                    IF_GT: begin
                        $display("OP - IF_GT");
                        next_state = POP_IF_GT;
                        stack_pop_operations = 1;
                    end                      
                    IF_LT: begin
                        $display("OP - IF_LT");
                        next_state = POP_IF_LT;
                        stack_pop_operations = 1;
                    end  
                    IF_GE: begin
                        $display("OP - IF_GE");
                        next_state = POP_IF_GE;
                        stack_pop_operations = 1;
                    end                      
                    IF_LE: begin
                        $display("OP - IF_LE");
                        next_state = POP_IF_LE;
                        stack_pop_operations = 1;
                    end 
                    CALL: begin
                        $display("OP - CALL");
                        next_state = PUSH_SUBROUTINE;
                        stack_data_in_subroutines = pcounter;
                        stack_push_subroutines = 1;
                    end
                    RET: begin
                        $display("OP - RET");
                        next_state = POP_SUBROUTINE;
                        stack_pop_subroutines = 1;
                    end
                    default: begin
                        $display("OP - default");
                        next_state = 0;
                    end
                endcase                
            end
            POP_TEMP1 : begin
                $display("State - POP_TEMP1");
                next_state = GET_TEMP1;
                stack_pop_operations = 1;
                $display("stack_data_out_operations: %d", stack_data_out_operations);                
            end
            GET_TEMP1 : begin
                $display("State - GET_TEMP1");
                next_state = POP_TEMP2;
                Temp1 = stack_data_out_operations;
                stack_pop_operations = 0;                
                $display("stack_data_out_operations: %d", stack_data_out_operations);                
            end
            POP_TEMP2 : begin
                $display("State - POP_TEMP2");
                next_state = GET_TEMP2;
                stack_pop_operations = 1;                
                $display("stack_data_out_operations: %d", stack_data_out_operations);                
            end
            GET_TEMP2 : begin
                $display("State - GET_TEMP2");
                next_state = OP_ALU;
                Temp2 = stack_data_out_operations;  // ToDo : Testar se tá pegando o segundo operando corretamente
                stack_pop_operations = 0;      
                $display("stack_data_out_operations: %d", stack_data_out_operations);                
            end
            OP_ALU : begin
                $display("State - OP_ALU");
                $display("Temp1: %d", Temp1);
                $display("Temp2: %d", Temp2);
                next_state = PUSH_OP_RESULT;
                operand_a = Temp1;
                operand_b = Temp2;
                op_ALU = operation;
            end
            PUSH_OP_RESULT : begin
                $display("State - PUSH_OP_RESULT");
                next_state = PCOUNTER_INC;
                stack_data_in_operations = result_alu;
                stack_push_operations = 1;                 
            end           
            GET_DATA : begin
                $display("State - GET_DATA");
                next_state = PUSH_M;
                stack_push_operations = 1;
                // memory data in is updated from the instruction memory
            end
            PUSH_M : begin
                $display("State - PUSH_M");
                next_state = PCOUNTER_INC;
                stack_data_in_operations = memory_data_in;
                stack_push_operations = 0;
            end
            ENABLE_WRITE_DATA : begin
                $display("State - ENABLE_WRITE_DATA");
                next_state = PCOUNTER_INC;
                TOS = stack_data_out_operations;
                $display("TOS: %d", TOS);
                write_data_enable = 1;
            end
            WRITE_DATA : begin
                $display("State - WRITE_DATA");
                next_state = PCOUNTER_INC;
                memory_data_out = TOS;                
            end
            POP_IF_EQ : begin
                $display("State - POP_IF_EQ");  
                next_state = CMP_IF_EQ;
                Temp1 = stack_data_out_operations;
                stack_pop_operations = 0;
            end
            CMP_IF_EQ : begin
                $display("State - CMP_IF_EQ");
                if (Temp1 == 0) begin
                    next_state = LOAD_INST;
                    pcounter = operand;
                end
                else begin
                    next_state = PCOUNTER_INC;
                end
            end 

            POP_IF_GT : begin
                $display("State - POP_IF_GT");
                next_state = CMP_IF_GT;
                Temp1 = stack_data_out_operations;
                stack_pop_operations = 0;
            end
            CMP_IF_GT : begin
                $display("State - CMP_IF_GT");
                if (Temp1 > 0) begin
                    next_state = LOAD_INST;
                    pcounter = operand;
                end
                else begin
                    next_state = PCOUNTER_INC;
                end
            end

            POP_IF_LT : begin  
                $display("State - POP_IF_LT");
                next_state = CMP_IF_LT;
                Temp1 = stack_data_out_operations;
                stack_pop_operations = 0;
            end
            CMP_IF_LT : begin
                $display("State - CMP_IF_LT");
                if (Temp1 < 0) begin
                    next_state = LOAD_INST;
                    pcounter = operand;
                end
                else begin
                    next_state = PCOUNTER_INC;
                end
            end 
            POP_IF_GE : begin  
                $display("State - POP_IF_GE");
                next_state = CMP_IF_GE;
                Temp1 = stack_data_out_operations;
                stack_pop_operations = 0;
            end
            CMP_IF_GE : begin
                $display("State - CMP_IF_GE");
                if (Temp1 >= 0) begin
                    next_state = LOAD_INST;
                    pcounter = operand;
                end
                else begin
                    next_state = PCOUNTER_INC;
                end
            end   
            POP_IF_LE : begin  
                $display("State - POP_IF_LE");
                next_state = CMP_IF_LE;
                Temp1 = stack_data_out_operations;
                stack_pop_operations = 0;
            end
            CMP_IF_LE : begin
                $display("State - CMP_IF_LE");
                if (Temp1 <= 0) begin
                    next_state = LOAD_INST;
                    pcounter = operand;
                end
                else begin
                    next_state = PCOUNTER_INC;
                end
            end
            PUSH_SUBROUTINE : begin
                $display("State - PUSH_SUBROUTINE");
                next_state = UPDATE_PCOUNTER;
                stack_push_subroutines = 0;
            end                    
            POP_SUBROUTINE : begin
                $display("State - POP_SUBROUTINE");
                next_state = UPDATE_PCOUNTER;
                operand = stack_data_out_subroutines;
                stack_pop_subroutines = 0;
            end
            UPDATE_PCOUNTER : begin
                $display("State - UPDATE_PCOUNTER");
                $display("operand: %d", operand);
                next_state = LOAD_INST;
                pcounter = operand;
            end            
        endcase

    end
endmodule

