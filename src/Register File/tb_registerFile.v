module tb_registerFile;

    // Testbench signals
    reg clk;
    reg rst;
    reg [2:0] RA;
    reg [2:0] RB;
    reg [2:0] RW;
    reg [15:0] WD;
    reg RegWrite;
    reg rf_enable;
    wire [15:0] BusA;
    wire [15:0] BusB;
    wire [15:0] registers [7:0];

    // Instantiate the registerFile module
    registerFile uut (
        .clk(clk),
        .rst(rst),
        .RA(RA),
        .RB(RB),
        .RW(RW),
        .WD(WD),
        .RegWrite(RegWrite),
        .rf_enable(rf_enable),
        .BusA(BusA),
        .BusB(BusB),
        .registers(registers)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        RA = 0;
        RB = 0;
        RW = 0;
        WD = 0;
        RegWrite = 0;
        rf_enable = 0;

        // Reset the register file
        #10 rst = 1;
        #10 rst = 0;

        // Enable the register file
        #10 rf_enable = 1;

        // Write data 0x1234 to register 1
        #10 RW = 3'b001; WD = 16'h1234; RegWrite = 1;
        #10 RegWrite = 0;

        // Write data 0x5678 to register 2
        #10 RW = 3'b010; WD = 16'h5678; RegWrite = 1;
        #10 RegWrite = 0;

        // Read from register 1 and 2
        #10 RA = 3'b001; RB = 3'b010;
        #10;

        // Write data 0xABCD to register 3
        #10 RW = 3'b011; WD = 16'hABCD; RegWrite = 1;
        #10 RegWrite = 0;

        // Read from register 3
        #10 RA = 3'b011;
        #10;

        // Reset the register file again
        #10 rst = 1;
        #10 rst = 0;

        // Read from register 1 and 2 after reset (should be 0)
        #10 RA = 3'b001; RB = 3'b010;
        #10;

        // Disable the register file
        #10 rf_enable = 0;

        // Attempt to write data 0x1234 to register 4 (should not write)
        #10 RW = 3'b100; WD = 16'h1234; RegWrite = 1;
        #10 RegWrite = 0;

        // Enable the register file and read from register 4 (should be 0)
        #10 rf_enable = 1; RA = 3'b100;
        #10;

        // End simulation
        #20 $finish;
    end

    // Monitor changes in the BusA and BusB signals
    initial begin
        $monitor("At time %t, RA: %h, RB: %h, BusA: %h, BusB: %h", $time, RA, RB, BusA, BusB);
    end

endmodule
