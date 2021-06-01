module Memory (
    address,
    write_read_not, 
    enable,
    data
);
parameter N = 30; // #Words = 2 ^ 30
parameter M = 32; // #Word_Bits = 32
// Memory base parameters are set like MIPS-32
input [N-1:0] address;
input write_read_not, enable;
inout [M-1:0] data;

reg [M-1:0] asked_data;
reg [M-1:0] mem [(1<<N)-1:0];

assign first_mem = mem[3];
assign seconde_mem = mem[15];
assign third_mem = mem[10];

TriStateBuffer tri_state_buffer(
    .seed(~write_read_not),
    .data_in(asked_data),
    .data_out(data)
);
defparam tri_state_buffer.RANGE = M;

always @(write_read_not, enable, address, data) begin
    if (enable) begin
        if (write_read_not) begin
            mem[address] = data;
        end else begin
            asked_data = mem[address];
        end
    end
end

integer i;
initial begin
    for (i = 0; i < (1<<N); i = i + 1) begin
        mem[i] = {M{1'b0}};
    end
end

endmodule