module DataMemory (
    input clk,                // Clock signal
	input reg dm_enable,
    input [15:0] address,     // Memory address
    input [15:0] Data_in,  // Data to write
    input MemWrite,          // Memory write enable signal
    input MemRead,           // Memory read enable signal
    input byte_enable,            // Byte enable signal (1 for byte, 0 for word)
    output reg [15:0] Data_out, // Data read from memory	
	output reg [7:0] memory [511:0]		  // for debugging purpos	   // Define a memory array with 512 locations, each 8 bits wide (256 words of 16 bits)
);

    

    // Memory read operation
    always @(posedge clk) begin
        if (MemRead && dm_enable == 1'b1) begin
            if (byte_enable) begin
                // Byte access
                Data_out = {8'b0, memory[address]}; // Zero-extend to 16 bits
            end else begin
                // Word access (two consecutive bytes)
                Data_out = {memory[address + 1], memory[address]};
            end
        end else begin
            Data_out = 16'b0;
        end
    end

    // Memory write operation
    always @(posedge clk) begin
        if (MemWrite && dm_enable == 1'b1) begin
            if (byte_enable) begin
                // Byte access
                memory[address] <= Data_in[7:0];
            end else begin
                // Word access (two consecutive bytes)
                memory[address] <= Data_in[7:0];
                memory[address + 1] <= Data_in[15:8];
            end
        end
    end

endmodule
