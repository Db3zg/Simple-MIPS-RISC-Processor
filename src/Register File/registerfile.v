module registerFile (
    input clk,                    // Clock signal
    input rst,                    // Reset signal
    input [2:0] RA,        // First read register address
    input [2:0] RB,        // Second read register address
    input [2:0] RW,        // Write register address
    input [15:0] WD,      // Data to be written
    input RegWrite,              // Write enable signal
	input rf_enable,
    output reg [15:0] BusA,     // First read data
    output reg [15:0] BusB,      // Second read data	 
	output reg [15:0] registers [7:0]	 // for debugging purpos 
);
					 
    // Initialize registers
    integer i;
    initial begin
        registers[0] = 16'b0;          // Register R0 is always zero
        registers[1] = 16'h0;       // Register R1
        registers[2] = 16'h0010;       // Register R2
        registers[3] = 16'h9ABC;       // Register R3
        registers[4] = 16'hDEF0;       // Register R4
        registers[5] = 16'h1357;       // Register R5
        registers[6] = 16'h2468;       // Register R6
        registers[7] = 16'hACE0;       // Register R7
    end

    // Read data from registers	   
	always @(*) begin
		if (rf_enable == 1'b1) begin
    		assign BusA = (RA == 3'b000) ? 16'b0 : registers[RA];
    		assign BusB = (RB == 3'b000) ? 16'b0 : registers[RB];  	 
		end
	end

    // Write data to register on the positive edge of the clock
    always @(*) begin
        if (rst) begin
            // Reset all registers to 0
            for (i = 0; i < 8; i = i + 1) begin
                registers[i] = 16'b0;
            end
        end else if (RegWrite && RW != 3'b000 && rf_enable == 1'b1) begin
            // Write data to the register if write enable is high and not writing to R0
            registers[RW] <= WD;
        end
    end
endmodule
