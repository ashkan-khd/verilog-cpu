module Stack(Clk, RstN, Enable, Data_in, Push, Pop, Data_out, Full, Empty);
	parameter WORD_RANGE = 8;
	parameter WORD_COUNT = 64;
	input Clk, RstN, Enable, Push, Pop;
	input [WORD_RANGE-1:0] Data_in;
	output reg [WORD_RANGE-1:0] Data_out;
	output reg Full, Empty;
	
	integer ptr;
	reg [WORD_RANGE-1:0] vars[WORD_COUNT-1:0];
	
	always @(posedge Clk, posedge RstN) begin
		if(RstN) begin
			ptr = 0;
			Empty = 1;
			Full = 0;
		end
		else begin
			if (Enable) begin
				if(Pop & ~Empty) begin
					Full = 0;
					ptr = ptr - 1;
					Data_out = vars[ptr];
					if(ptr == 0)
						Empty = 1;
				end
				if(Push & ~Full) begin
					Empty = 0;
					vars[ptr] = Data_in;
					ptr = ptr + 1;
					if(ptr == WORD_COUNT)
						Full = 1;
				end
			end
		end
	end
		
	initial begin
		ptr = 0;
		Empty = 1;
		Full = 0;
	end
endmodule
