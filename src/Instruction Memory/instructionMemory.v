module instructionMemory (clock, address,im_enable, instruction);
    input wire clock;
    input wire [15:0] address;
	input im_enable;
    output reg [15:0] instruction;
    reg [15:0] memory [0:255];
    always @(*) begin
		if (im_enable == 1'b1) begin
        instruction <= memory[address];
		end
    end
    initial begin
//        
//        memory[1]  = 16'b0001001000110101; // ADD R1, R2, R3
//        memory[2]  = 16'b0010001000110110; // SUB R1, R2, R3
        memory[3]  = 16'b0011000100100001; // ADDI R1, R1, 1
        memory[4]  = 16'b0100000100100010; // ANDI R1, R1, 2
        memory[5]  = 16'b0101000100100100; // LW R1, 4(R2)
        memory[6]  = 16'b0110000100100100; // LBu R1, 4(R2)
//        memory[7]  = 16'b0110010100100100; // LBs R1, 4(R2)
//        memory[8]  = 16'b0111001001000100; // SW 4(R2), R1
        //memory[9]  = 16'b1000000100110101; // BGT R1, R3, 5
//        memory[10] = 16'b1000010100100101; // BGTZ R1, 5
//        memory[11] = 16'b1001000100110101; // BLT R1, R3, 5
//        memory[12] = 16'b1001010100100101; // BLTZ R1, 5
//        memory[13] = 16'b1010000100110101; // BEQ R1, R3, 5
//        memory[14] = 16'b1010010100100101; // BEQZ R1, 5
//        memory[15] = 16'b1011000100110101; // BNE R1, R3, 5
//        memory[16] = 16'b1011010100100101; // BNEZ R1, 5
//        memory[17] = 16'b1100000000000101; // JMP 5
		memory[1] = 16'b1101000000000101; // CALL 5
		memory[2] = 16'b1110000000000000; // RET
//        memory[9] = 16'b1111010000000101; // Sv R2, 5
//		memory[10]  = 16'b0000001000110100; // AND R1, R2, R3

       
    end
endmodule