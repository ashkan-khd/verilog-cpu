module TestALU ();
parameter TEST_RANGE = 4;
reg [TEST_RANGE-1:0] A, B;
reg cin, ALUOP;
wire [TEST_RANGE-1:0] product;
wire cout, Zero;

ALU alu(
    A,
    B,
    cin,
    ALUOP,
    product,
    cout,
    Zero
);
defparam alu.TERMINAL_RANGE = TEST_RANGE;

initial begin
    #5
    A = 4'b1101;
    B = 4'b0100;
    cin = 0;
    ALUOP = 0; // ADD
    #5
    A = 4'b1110;
    B = 4'b0001;
    cin = 1;
    ALUOP = 0; // ADD
    #5
    A = 4'b1110;
    B = 4'b1110;
    cin = 0;
    ALUOP = 1; // SUB
    #5
    A = 4'b1110;
    B = 4'b0110;
    cin = 0;
    ALUOP = 1; // SUB
    #5
    $stop;
end

endmodule