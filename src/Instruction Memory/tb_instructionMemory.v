module tb_instructionMemory;

    // Testbench signals
    reg clock;
    reg [15:0] address;
    reg im_enable;
    wire [15:0] instruction;

    // Instantiate the instructionMemory module
    instructionMemory uut (
        .clock(clock),
        .address(address),
        .im_enable(im_enable),
        .instruction(instruction)
    );

    // Clock generation
    always #5 clock = ~clock;

    initial begin
        // Initialize signals
        clock = 0;
        address = 0;
        im_enable = 0;

        // Enable the instruction memory
        #10 im_enable = 1;

        // Read instructions from various addresses
        #10 address = 16'h0000; // Read instruction at address 0
        #10 address = 16'h0001; // Read instruction at address 1
        #10 address = 16'h0002; // Read instruction at address 2
        #10 address = 16'h0003; // Read instruction at address 3
        #10 address = 16'h0004; // Read instruction at address 4
        #10 address = 16'h0005; // Read instruction at address 5
        #10 address = 16'h0006; // Read instruction at address 6
        #10 address = 16'h0007; // Read instruction at address 7
        #10 address = 16'h0008; // Read instruction at address 8

        // Disable the instruction memory
        #10 im_enable = 0;

        // Attempt to read an instruction with the instruction memory disabled
        #10 address = 16'h0000;

        // End simulation
        #20 $finish;
    end

    // Monitor changes in the instruction signal
    initial begin
        $monitor("At time %t, address: %h, instruction: %h", $time, address, instruction);
    end

endmodule
