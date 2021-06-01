module DataPath (
);
parameter WORD_RANGE = 8;
parameter MEMORY_WORD_COUNT = 256;
parameter STACK_WORD_COUNT = 8;
parameter FLAGS_COUNT = 2;

input [WORD_RANGE-1:0] data_in;
input cache_a_b_not, is_data_indirect, ALUOP, pop_operand;
input push_result, write_mem_result;
input [WORD_RANGE-1:0] write_address;
input clk;
output [WORD_RANGE-1:0] data_out;


output [FLAGS_COUNT-1:0] flags;

assign data_out = pop_operand ? stack_out : alu_out;


always @(*) begin
    if (cache_a_b_not) begin
        if (is_data_indirect) begin
            cache_a = data_memory_bus;
        end else begin
            cache_a = data_in;
        end
    end else begin
        if (is_data_indirect) begin
            cache_b = data_memory_bus;
        end else begin
            cache_b = data_in;
        end
    end
end

// stack segment
reg reset_stack;
wire stack_enable;
assign stack_enable = push_result || pop_operand;
wire [WORD_RANGE-1:0] stack_out;
Stack stack(
	clk, reset_stack, stack_enable, alu_out, push_result, pop_operand, stack_out
);
defparam stack.WORD_RANGE = WORD_RANGE;
defparam stack.WORD_COUNT = STACK_WORD_COUNT;

initial begin
    reset_stack = 1;
    reset_stack = 0;

end


// alu segment
reg [WORD_RANGE-1:0] cache_a, cache_b;
reg alu_cin;
wire [WORD_RANGE-1:0] alu_out;
wire cout, zero;
ALU alu(
    cache_a,
    cache_b,
    alu_cin,
    ALUOP,
    alu_out,
    cout,
    zero
);
alu.TERMINAL_RANGE = WORD_RANGE;

assign flags[0] = zero;
assign flags[1] = alu_out[WORD_RANGE-1];

initial begin
    alu_cin = 0;
    cache_a = {WORD_RANGE{1'b0}};
    cache_b = {WORD_RANGE{1'b0}};
end

// data memory segment
wire [WORD_RANGE-1] data_memory_address;
MUX mux(
    write_mem_result,
    write_address,
    data_in,
    data_memory_address
);
defparam mux.WORD_RANGE = WORD_RANGE;

wire [WORD_RANGE-1] data_memory_bus;
Memory data_memory(
    data_memory_address,
    write_mem_result, 
    1'b0,
    data_memory_bus
);
defparam data_memory.N = MEMORY_WORD_COUNT;
defparam data_memory.M = WORD_RANGE;

TriStateBuffer tri_state_buffer(
    .seed(write_mem_result),
    .data_in(alu_out),
    .data_out(data_memory_bus)
);
defparam tri_state_buffer.RANGE = WORD_RANGE;


endmodule