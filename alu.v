module ALU (
    A,
    B,
    cin,
    ALUOP,
    product,
    cout,
    Zero
);
parameter TERMINAL_RANGE = 8;
input [TERMINAL_RANGE-1:0] A, B;
input cin, ALUOP;
output reg [TERMINAL_RANGE-1:0] product;
output reg cout, Zero;

wire [TERMINAL_RANGE-1:0] cleaned_B;
assign cleaned_B = ALUOP ? -B : B;

always @(*) begin
    {cout, product} = A + cleaned_B + cin;
    Zero = (product == 0);
end

endmodule