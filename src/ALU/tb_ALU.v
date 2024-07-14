module tb_ALU;

    // Testbench signals
    reg clk;
    reg [15:0] A, B;
    reg [1:0] ALU_op;
    wire [15:0] result;
    wire Z, N;

    // Instantiate the ALU module
    ALU uut (
        .clk(clk),
        .A(A),
        .B(B),
        .ALU_op(ALU_op),
        .result(result),
        .Z(Z),
        .N(N)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        A = 0;
        B = 0;
        ALU_op = 2'b00;

        // Test addition
        #10 A = 16'h0001; B = 16'h0001; ALU_op = 2'b00; // 1 + 1
        #10 A = 16'hFFFF; B = 16'h0001; ALU_op = 2'b00; // -1 + 1

        // Test subtraction
        #10 A = 16'h0002; B = 16'h0001; ALU_op = 2'b01; // 2 - 1
        #10 A = 16'h0001; B = 16'h0002; ALU_op = 2'b01; // 1 - 2

        // Test AND
        #10 A = 16'h00FF; B = 16'h0F0F; ALU_op = 2'b10; // 00FF & 0F0F

        // Test OR
        #10 A = 16'h00F0; B = 16'h0F00; ALU_op = 2'b11; // 00F0 | 0F00

        // End simulation
        #20 $finish;
    end

    // Monitor changes in the result, Z, and N signals
    initial begin
        $monitor("At time %t, A: %h, B: %h, ALU_op: %b, result: %h, Z: %b, N: %b", $time, A, B, ALU_op, result, Z, N);
    end

endmodule
