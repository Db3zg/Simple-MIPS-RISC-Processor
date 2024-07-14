module tb_PC_Register;

    // Testbench signals
    reg clk;
    reg rst;
    reg [15:0] pc_in;
    reg pc_write;
    wire [15:0] pc_out;

    // Instantiate the PC_Register module
    PC uut (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_in),
        .pc_write(pc_write),
        .pc_out(pc_out)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 10 ns clock period
    end

    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        pc_in = 16'b0;
        pc_write = 0;

        // Apply reset
        #10;
        rst = 1;
        #10;
        rst = 0;
        #10;
        $display("After reset, PC: %h (Expected: 0000)", pc_out);

        // Test 1: Write to the PC
        #10;
        pc_in = 16'h1234;
        pc_write = 1;
        #10;
        pc_write = 0;
        $display("Test 1 - Write PC: %h (Expected: 1234)", pc_out);

        // Test 2: Increment the PC
        #10;
        pc_in = pc_out + 16'h0002;
        pc_write = 1;
        #10;
        pc_write = 0;
        $display("Test 2 - Increment PC: %h (Expected: 1236)", pc_out);

        // Test 3: Jump to a new address
        #10;
        pc_in = 16'h5678;
        pc_write = 1;
        #10;
        pc_write = 0;
        $display("Test 3 - Jump PC: %h (Expected: 5678)", pc_out);

        // End simulation
        #10;
        $finish;
    end

endmodule
