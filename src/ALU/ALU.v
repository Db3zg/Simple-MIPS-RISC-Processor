module ALU (
	input clk,
    input [15:0] A, B,         // ALU inputs
    input [1:0] ALU_op,        // ALU operation code
    output reg [15:0] result,  // ALU result
    output Z,                  // Zero flag
    output N                   // Negative flag
);

    reg carry_out;

    always @(posedge clk) begin
        case (ALU_op)
            2'b00: {carry_out, result} = A + B;  // ADD
            2'b01: {carry_out, result} = A - B;  // SUB
            2'b10: result = A & B;               // AND
            2'b11: result = A | B;               // OR
            // Add other operations as needed
            default: result = 16'b0;
        endcase
    end

    // Generate condition flags
    assign Z = (result == 16'b0);
    assign N = result[15];

endmodule
