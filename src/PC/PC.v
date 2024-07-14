module pc_module (
    input wire clock,       // Clock signal
    input wire reset,       // Reset signal to initialize PC
    input wire enable,      // Enable signal for updating PC
    input wire [15:0] next_pc, // Next PC value to be loaded
    output reg [15:0] PC    // Current PC value
);

    // Always block triggered on the rising edge of the clock or reset signal
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            PC <= 16'b0;  // If reset is high, initialize PC to 0
        end else if (enable) begin
            PC <= next_pc; // If enable is high, update PC with next_pc value
        end else begin
            PC <= PC;     // If neither reset nor enable is high, maintain the current PC value
        end
    end

endmodule
