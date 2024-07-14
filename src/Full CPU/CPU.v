module CPU();
    // inputs and outputs of the modules
    wire clock;
    reg [15:0] PC;
    reg [15:0] next_pc;
    reg [15:0] Instruction;
    wire [15:0] ALURes;
    wire ZF, NF;
	reg [2:0] RA, RB, RW;
    reg [15:0] BusA, BusB, A, B, Address, DataIn; 
    reg [15:0] BusW;
    wire [15:0] DataOut;		  	
	reg [11:0] jump_offset;	
	reg [7:0] svImm;
	reg pc_enable, rf_enable, alu_enable, im_enable, cu_enable, dm_enable;		  
	reg flag;

    // Control signals
    wire [1:0] SrcPc;
    wire SrcRW, SrcRB, SrcRA, RegW, SrcA, SrcB;
    wire [1:0] ALUOp;
    wire MemAddSrc, DataInSrc, MemW, MemR, TakeExt1, TakeExt2, byte_en;
    wire [1:0] WB;

    // Instruction parts
    reg [3:0] OpCode; // Change from wire to reg
    reg [2:0] Rd, Rs1, Rs2;
    reg [4:0] imm;
    reg mode;
    reg [15:0] extendedImm, signExtendedImm, zeroExtendedImm;                       
    reg [15:0] registers [7:0];
    reg [7:0] memory [511:0]; 

    // State machine states
    typedef enum reg [2:0] {
        FETCH,
        DECODE,
        EXECUTE,
        MEMORY,
        WRITEBACK
    } state_t;

    state_t state, next_state;

    // Instantiate Clock Generator
    ClockGenerator clock_gen(clock);
	
	
	// PC
	pc_module pc_mod(
	clock,
	1'b0,
	pc_enable,
	next_pc,
	PC
	); 
	
    // Instantiate Control Unit
    ControlUnit cu (
	.clk(clock), 
	.cu_enable(1'b1),
	.PC(PC),
        .opcode(OpCode),
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

    // Instantiate Instruction Memory
    instructionMemory ins_mem (
        .clock(clock),
        .address(PC),
		.im_enable(im_enable),
        .instruction(Instruction)
    );

    // Instantiate Register File
    registerFile reg_file (
	.clk(clock),
	.rst(1'b0),
        .RA(RA),
        .RB(RB),
        .RW(RW),
        .WD(BusW),
        .RegWrite(RegW),
		.rf_enable(rf_enable),
        .BusA(BusA),
        .BusB(BusB),
        .registers(registers)
    );

    // Instantiate ALU 
    ALU alu (
        .clk(clock),
        .A(A),
        .B(B),
        .ALU_op(ALUOp),
        .result(ALURes),
        .Z(ZF),
        .N(NF)
    );

    // Instantiate Data Memory       
    DataMemory data_mem (
	.clk(clock),
	.dm_enable(dm_enable),
        .address(Address),
        .Data_in(DataIn),
        .MemWrite(MemW),
        .MemRead(MemR),
        .byte_enable(byte_en),
        .Data_out(DataOut),
        .memory(memory)
    );
    integer counter;
    integer max_iterations = 30; // Number of times to display the message
    // Initializing PC and debugging display
    initial begin
        next_pc = 0;
		rf_enable = 1'b0;
		dm_enable = 1'b0;
		pc_enable = 1'b1;
		im_enable = 1'b1;
        counter = 0; // Initialize the counter
		#20   			
		pc_enable = 1'b0;
		im_enable = 1'b0;
        state = FETCH;
		#70
        forever begin
            if (counter < max_iterations) begin
                $display("Time: %0t, PC: %d, Instruction: %b, R1: %b, R7: %b, M[6]: %b, Rd: %h, SrcPc: %d", ($time-20),
				PC,Instruction, registers[1], registers[7], memory[6], Rd, SrcPc); // Display the current simulation time
            	#70; // Wait for 55 time units
                counter = counter + 1; // Increment the counter	  
            end else begin
                $finish; // End the simulation
            end
        end
    end

    // State machine to control the execution of instructions
    always @(posedge clock) begin
        case (state) 
            FETCH: begin
				assign pc_enable = 1'b0;
				im_enable = 1'b0;  
				dm_enable = 1'b0;
                OpCode <= Instruction[15:12];	
                if (OpCode == 4'b0100 || OpCode == 4'b0011 || OpCode == 4'b0101 || OpCode == 4'b0110 || OpCode == 4'b0111 || OpCode == 4'b1001
					|| OpCode == 4'b1010 || OpCode == 4'b1011 || OpCode == 4'b1000) begin
                    Rd <= Instruction[10:8];
                    Rs1 <= Instruction[7:5];
                    imm <= Instruction[4:0];
                    mode <= Instruction[11];
                end else if (OpCode == 4'b0000 || OpCode == 4'b0001 || OpCode == 4'b0010) begin
                    Rd <= Instruction[11:9];
                    Rs1 <= Instruction[8:6];
                    Rs2 <= Instruction[5:3];   	
				end						 
				else if (OpCode == 4'b1100 || OpCode  == 4'b1101) begin	
					jump_offset <= Instruction[11:0];
				end	  
				else if (OpCode == 4'b1111) begin 
					Rs1 <= Instruction[11:9];
					svImm <= Instruction[8:1];
				end
				#10
				rf_enable = 1'b1;
                state <= DECODE;
            end
            DECODE: begin
                // Decode instruction
				assign pc_enable = 1'b0;
				rf_enable = 1'b0;
                RA <= (SrcRA == 1'b0) ? Rs1 : 3'b111;
                RB <= (SrcRB == 1'b0) ? Rs2 : Rd;
                RW <= (SrcRW == 1'b0) ? Rd : 3'b111;   
				if(OpCode == 4'b1100) begin  
					pc_enable = 1'b1;
					im_enable = 1'b1;
					state <= FETCH;
				end	  						 
			else if (OpCode == 4'b1101) begin   
				state <= WRITEBACK;
			end	   
			else if (OpCode == 4'b1110) begin
				state <= WRITEBACK;
			end		
			else if (OpCode == 4'b1111) begin
				state <= MEMORY;
			end	
                state <= EXECUTE;
            end
            EXECUTE: begin
                // Execute instruction	
				assign pc_enable = 1'b0; 
				cu_enable = 1'b1;
				im_enable = 1'b0;
				rf_enable = 1'b0; 
                A <= (SrcA == 1'b0) ? BusA : 16'h0000;	 
				B <= (SrcB == 1'b0) ? BusB : {{11{imm[4]}}, imm};	
				if (OpCode == 4'b1001 || OpCode == 4'b1010 || OpCode == 4'b1011 || OpCode == 4'b1000) begin
					state <= WRITEBACK;
					end
				if (OpCode == 4'b0101 || OpCode == 4'b0110 || OpCode == 4'b0111 || OpCode == 4'b1111) begin
                	state <= MEMORY;
				end
			else begin	   
				state <= WRITEBACK;
				end
            	end
            MEMORY: begin 		 
                DataIn <= (DataInSrc == 1'b0) ? BusB : {{8{1'b0}}, svImm};	   
                Address <= (MemAddSrc == 1'b0) ? ALURes : BusA;
                // Memory operations	
				assign pc_enable = 1'b0;
				rf_enable = 1'b0; 
				dm_enable = 1'b1;
                state <= WRITEBACK;
            end
            WRITEBACK: begin  		 
               RW <= (SrcRW == 1'b0) ? Rd : 3'b111;
                case (WB)		
                    2'b00: BusW = ALURes;       // Write ALU result back to the register file
                    2'b01: BusW = DataOut;      // Write data from memory back to the register file
                    2'b10: BusW = PC + 4;       // Write PC + 4 back to the register file
                    default: BusW = 16'bxxxxxxxxxxxxxxxx;
                endcase	
				
                if (SrcPc == 2'b00) begin
                    next_pc <= PC + 1;
                end else if (SrcPc == 2'b01) begin
                    next_pc <= (mode == 1'b0) ? PC + imm : PC + {{11{imm[4]}}, imm};
                end else if (SrcPc == 2'b10) begin
                    next_pc <= {PC[15:12], jump_offset[11:0]};
                end else if (SrcPc == 2'b11) begin
                    next_pc <= BusA;
                end else begin
                    next_pc <= PC + 1;
                end		
				rf_enable = 1'b1;
				dm_enable = 1'b0; 
				assign pc_enable = 1'b1;
				im_enable = 1'b1;
				
				#10	
                state <= FETCH;
            end
        endcase
    end

endmodule
