module Core (
    clk,
    init_PC
);
parameter WORD_RANGE = 8;
parameter MEMORY_WORD_COUNT = 256;
parameter STACK_WORD_COUNT = 8;
parameter INST_RANGE = 12;
parameter OP_CODE_RANGE = 4;
input clk;
input [WORD_RANGE-1:0] init_PC;

DataPath dp(
	clk,
    datapath_in,
    cache_a_b_not, 
    is_data_indirect, 
    ALUOP, 
    pop_operand,
    push_result, 
    write_mem_result,
    data_memory_write_addr,
    datapath_alu_out, 
    datapath_stack_out,
    flags
);
defparam dp.WORD_RANGE = WORD_RANGE;
defparam dp.MEMORY_WORD_COUNT = MEMORY_WORD_COUNT;
defparam dp.STACK_WORD_COUNT = STACK_WORD_COUNT;


ControlUnit cu(
    clk, 
    init_PC, // ?
    datapath_alu_out, 
    datapath_stack_out, 
    flags, 
    cache_a_b_not, 
    is_data_indirect, 
    ALUOP, 
    pop_operand, 
    push_result, 
    write_mem_result,
    datapath_in,
    data_memory_write_addr
);
defparam cu.DATA_RANGE = WORD_RANGE;
defparam cu.INST_RANGE = INST_RANGE;
defparam cu.OP_CODE_RANGE = OP_CODE_RANGE;

endmodule