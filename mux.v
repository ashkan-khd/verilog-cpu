module MUX (
    select,
    a,
    b,
    out
);
parameter WORD_RANGE = 16;
input select;
input [WORD_RANGE-1:0] a;
input [WORD_RANGE-1:0] b;
output reg [WORD_RANGE-1:0] out;

integer i;
always @(select, a, b) begin
    if (~select) begin
        out = a;
    end else begin
        out = b;
    end
end

    
endmodule