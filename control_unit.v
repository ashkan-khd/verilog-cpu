module ControlUnit (
    clk, 
    init_PC, 
    alu_out, 
    stack_out, 
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

parameter DATA_RANGE = 8;
parameter INST_RANGE = 12;
parameter OP_CODE_RANGE = 4;
parameter FLAGS_COUNT = 2;
localparam START = 3'b001;
localparam MID = 3'b010;
localparam END = 3'b100;


input clk;
input [DATA_RANGE-1:0] init_PC;
input [DATA_RANGE-1:0] alu_out, stack_out;
input [FLAGS_COUNT-1:0] flags;
output reg cache_a_b_not, is_data_indirect, ALUOP, pop_operand, push_result, write_mem_result;
output reg [DATA_RANGE-1:0] datapath_in;
output reg [DATA_RANGE-1:0] data_memory_write_addr;

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
assign op_code = IR[INST_RANGE-1:INST_RANGE-OP_CODE_RANGE];
reg [3:1] states;

initial begin
    PC = init_PC;
    states = 3'b000;
end

always @(posedge clk) begin
    if (states == START) begin
		/* cache_a_b_not = 0;
		is_data_indirect = 0;
		ALUOP = 0;
		pop_operand = 0;
		push_result = 0;
		write_mem_result = 0; */ 
		push_result = 0;
		write_mem_result = 0;
		
        case (op_code)
            4'b0000: begin
				cache_a_b_not = 0;
				datapath_in = 0;
				cache_a_b_not = 1;
				datapath_in = IR[DATA_RANGE-1:0];
				push_result = 1;
				PC = PC + 1;
            end
            4'b0001: begin
				cache_a_b_not = 0;
				datapath_in = 0;
				cache_a_b_not = 1;
				is_data_indirect = 1;
				datapath_in = IR[DATA_RANGE-1:0];
				push_result = 1;
				PC = PC + 1;
            end
			4'b0110, 4'b0111, 4'b0010, 4'b0011: begin
				pop_operand = 1;
				states = MID;
            end
			4'b0100: begin
				if(flags[0]) begin
					pop_operand = 1;
					states = MID;
				end else begin
					PC = PC + 1;
				end 
            end
			4'b0101: begin
				if(flags[1]) begin
					pop_operand = 1;
					states = MID;
				end else begin
					PC = PC + 1;
				end 
            end
        endcase
    end
end

always @(posedge clk)
	if(states == MID) begin 
		push_result = 0;
		write_mem_result = 0;
		case(op_code)
			4'b0010: begin
				cache_a_b_not = 1;
				datapath_in = stack_out;
				cache_a_b_not = 0;
				datapath_in = 0;
				pop_operand = 0;
				write_mem_result = 1;
				data_memory_write_addr = IR[DATA_RANGE-1:0];
				write_mem_result = 0;
				PC = PC + 1;
				states = START;
            end
			4'b0100, 4'b0101, 4'b0011: begin
				pop_operand = 0;
				PC = stack_out;
				states = START;
            end
			4'b0110, 4'b0111: begin
                cache_a_b_not = 1;
				datapath_in = stack_out;
				cache_a_b_not = 0;
				states = END;
            end
		endcase
	end

always @(posedge clk)
	if(states == END) begin
        datapath_in = stack_out;
        pop_operand = 0;
        push_result = 1;
        ALUOP = op_code[0];
        states = START;
        PC = PC + 1;
	end
    
endmodule