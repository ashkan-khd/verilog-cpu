module TriStateBuffer (
    seed,
    data_in,
    data_out
);
parameter RANGE = 8;
input seed;
input [RANGE-1:0] data_in;
output reg [RANGE-1:0] data_out;

always @(seed, data_in) begin
    if (seed) begin
        data_out = data_in;
    end else begin
        data_out = {RANGE{1'bz}};
    end
end

endmodule
