module DataMemory_tb;

    // Testbench signals
    reg clk;
    reg dm_enable;
    reg MemWrite;
    reg MemRead;
    reg byte_enable;
    reg [15:0] address;
    reg [15:0] Data_in;
    wire [15:0] Data_out;
    wire [7:0] memory [511:0];

    // Instantiate the DataMemory module
    DataMemory uut (
        .clk(clk),
        .dm_enable(dm_enable),
        .address(address),
        .Data_in(Data_in),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .byte_enable(byte_enable),
        .Data_out(Data_out),
        .memory(memory)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        dm_enable = 0;
        MemWrite = 0;
        MemRead = 0;
        byte_enable = 0;
        address = 0;
        Data_in = 0;

        // Enable data memory
        #10 dm_enable = 1;

        // Write a word (0xABCD) to address 0x10
        #10 address = 16'h0010; Data_in = 16'hABCD; MemWrite = 1; byte_enable = 0;
        #10 MemWrite = 0; // De-assert write enable

        // Write a byte (0xEF) to address 0x20
        #10 address = 16'h0020; Data_in = 16'h00EF; MemWrite = 1; byte_enable = 1;
        #10 MemWrite = 0; // De-assert write enable

        // Read the word from address 0x10
        #10 address = 16'h0010; MemRead = 1; byte_enable = 0;
        #10 MemRead = 0; // De-assert read enable

        // Read the byte from address 0x20
        #10 address = 16'h0020; MemRead = 1; byte_enable = 1;
        #10 MemRead = 0; // De-assert read enable

        // Read the byte from address 0x11 (should be 0 since it wasn't written)
        #10 address = 16'h0011; MemRead = 1; byte_enable = 1;
        #10 MemRead = 0; // De-assert read enable

        // Disable data memory
        #10 dm_enable = 0;

        // End simulation
        #20 $finish;
    end

    // Monitor changes in the Data_out signal
    initial begin
        $monitor("At time %t, address: %h, Data_out: %h", $time, address, Data_out);
    end

endmodule
