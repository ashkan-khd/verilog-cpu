module ControlUnit (

);
`define START 3'b001
`define MID 3'b010
`define END 3'b100
parameter DATA_RANGE = 8;
parameter INST_RANGE = 12;
parameter OP_CODE_RANGE = 4;

input clk;
input [DATA_RANGE-1:0] init_PC;

reg [DATA_RANGE-1:0] PC;
reg [INST_RANGE-1:0] IR;

Memory instruction_memory(
    PC,
    1'b0, 
    1'b1,
    IR
);
defparam instruction_memory.N = DATA_RANGE;
defparam instruction_memory.M = INST_RANGE;

wire [OP_CODE_RANGE-1:0] op_code;
assign op_code = IR[INST_RANGE-1:INST_RANGE-OP_CODE_RANGE]
reg [3:1] states;

initial begin
    PC = init_PC;
    states = 3'b000;
end

always @(clk) begin
    if (states==START) begin
        case (op_code)
            4'b0000: states=
            default: 
        endcase
    end
end


function [3:1] states_after_push_constance();
    begin
        
    end
endfunction

    
endmodule