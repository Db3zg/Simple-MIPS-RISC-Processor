module tb_ControlUnit;

    // Testbench signals
    reg clk;
    reg cu_enable;
    reg [15:0] PC;
    reg [3:0] opcode;
    reg mode;
    reg ZF;
    reg NF;
    wire [1:0] SrcPc;
    wire SrcRW;
    wire SrcRB;
    wire SrcRA;
    wire RegW;
    wire SrcA;
    wire SrcB;
    wire [1:0] ALUOp;
    wire MemAddSrc;
    wire DataInSrc;
    wire MemW;
    wire MemR;
    wire [1:0] WB;
    wire TakeExt1;
    wire TakeExt2;
    wire byte_en;

    // Instantiate the ControlUnit module
    ControlUnit uut (
        .clk(clk),
        .cu_enable(cu_enable),
        .PC(PC),
        .opcode(opcode),
        .mode(mode),
        .ZF(ZF),
        .NF(NF),
        .SrcPc(SrcPc),
        .SrcRW(SrcRW),
        .SrcRB(SrcRB),
        .SrcRA(SrcRA),
        .RegW(RegW),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUOp(ALUOp),
        .MemAddSrc(MemAddSrc),
        .DataInSrc(DataInSrc),
        .MemW(MemW),
        .MemR(MemR),
        .WB(WB),
        .TakeExt1(TakeExt1),
        .TakeExt2(TakeExt2),
        .byte_en(byte_en)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        cu_enable = 1;
        PC = 0;
        opcode = 4'b0000;
        mode = 0;
        ZF = 0;
        NF = 0;

        // Test AND instruction
        #10 opcode = 4'b0000; // AND
        #10 opcode = 4'b0001; // ADD
        #10 opcode = 4'b0010; // SUB
        #10 opcode = 4'b0011; // ANDI
        #10 opcode = 4'b0100; // ADDI
        #10 opcode = 4'b0101; // LW
        #10 opcode = 4'b0110; // LBu or LBs
        #10 opcode = 4'b0111; // SW
        #10 opcode = 4'b1000; mode = 1; ZF = 0; NF = 1; // BGT or BGTZ
        #10 opcode = 4'b1001; mode = 1; ZF = 0; NF = 0; // BLT or BLTZ
        #10 opcode = 4'b1010; mode = 1; ZF = 1; // BEQ or BEQZ
        #10 opcode = 4'b1011; mode = 1; ZF = 0; // BNE or BNEZ
        #10 opcode = 4'b1100; // JMP
        #10 opcode = 4'b1101; // CALL
        #10 opcode = 4'b1110; // RET
        #10 opcode = 4'b1111; // Sv

        // End simulation
        #20 $finish;
    end

    // Monitor changes in control signals
    initial begin
        $monitor("At time %t, opcode: %b, SrcPc: %b, SrcRW: %b, SrcRB: %b, SrcRA: %b, RegW: %b, SrcA: %b, SrcB: %b, ALUOp: %b, MemAddSrc: %b, DataInSrc: %b, MemW: %b, MemR: %b, WB: %b, TakeExt1: %b, TakeExt2: %b, byte_en: %b",
            $time, opcode, SrcPc, SrcRW, SrcRB, SrcRA, RegW, SrcA, SrcB, ALUOp, MemAddSrc, DataInSrc, MemW, MemR, WB, TakeExt1, TakeExt2, byte_en);
    end

endmodule
