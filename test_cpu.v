module TestCPU ();
parameter WORD_RANGE = 8;
parameter MEMORY_WORD_COUNT = 256;
parameter STACK_WORD_COUNT = 8;
parameter INST_RANGE = 12;
parameter OP_CODE_RANGE = 4;
parameter CLOCK_CHANGE_DELAY = 5;
reg clk;
reg [WORD_RANGE-1:0] init_PC;

Core core(
    clk,
    init_PC
);
defparam core.WORD_RANGE = WORD_RANGE;
defparam core.MEMORY_WORD_COUNT = MEMORY_WORD_COUNT;
defparam core.STACK_WORD_COUNT = STACK_WORD_COUNT;
defparam core.INST_RANGE = INST_RANGE;
defparam core.OP_CODE_RANGE = OP_CODE_RANGE;

wire [WORD_RANGE-1:0] first_word, second_word, third_word;
assign first_word = core.cu.instruction_memory.mem[0];
assign second_word = core.cu.instruction_memory.mem[1];
assign third_word = core.cu.instruction_memory.mem[2];

always begin
    #CLOCK_CHANGE_DELAY
    clk = ~clk;
end

reg temp;
integer i;
// testing cpu
initial begin
    core.cu.instruction_memory.mem[0] = 12'b0000_00111101; // stack = x
    core.cu.instruction_memory.mem[0] = 12'b0010_00000000; // mem = x

    core.cu.instruction_memory.mem[0] = 12'b0000_00001111; // stack = y 
    core.cu.instruction_memory.mem[0] = 12'b0000_01101100; // stack = z

    core.cu.instruction_memory.mem[0] = 12'b0110_00000000; // stack = y + z
    core.cu.instruction_memory.mem[0] = 12'b0010_00000001; // mem = y + z

    core.cu.instruction_memory.mem[0] = 12'b0001_00000001; // stack = y + z
    core.cu.instruction_memory.mem[0] = 12'b0000_01111101; // stack = w
    core.cu.instruction_memory.mem[0] = 12'b0111_00000000; // stack = w - (y + z)
    core.cu.instruction_memory.mem[0] = 12'b0010_00000010; // mem = w - (y + z)
    clk = 0;
    init_PC = 8'b0000_0000;
    for (i = 0; i < 10; i = i + 1) begin
        #CLOCK_CHANGE_DELAY #CLOCK_CHANGE_DELAY
        temp = ~temp;
    end

    $stop;

end


endmodule