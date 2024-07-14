module ControlUnit (
	input clk,
	input reg cu_enable,
	input reg [15:0] PC,
    input [3:0] opcode,   // Opcode from the instruction
    input mode,           // Mode bit for certain instructions
    input ZF,
	input NF,
	output reg [1:0] SrcPc,
    output reg SrcRW,
    output reg SrcRB,
    output reg SrcRA,
    output reg RegW,
    output reg SrcA,
    output reg SrcB,
    output reg [1:0] ALUOp,
	output reg MemAddSrc,
	output reg DataInSrc,
	output reg MemW,
    output reg MemR,
    output reg [1:0] WB,
    output reg TakeExt1,
    output reg TakeExt2,
	output reg byte_en
);

always @(posedge clk && PC) begin
	if (cu_enable == 1'b1) begin
	        case (opcode)
	            4'b0000: begin // AND
	                
					SrcPc = 2'b00;
	                SrcRW = 0;
	    			SrcRB = 0;
	    			SrcRA = 0;
	    			RegW  = 1;
	    			SrcA  = 0;
	    			SrcB  = 0;
	    			ALUOp = 2'b10; 
					MemW  = 0;
	    			MemR  = 0;
	    			WB 	  = 2'b00;
	            end
	            4'b0001: begin // ADD
	                SrcPc = 2'b00;
	                SrcRW = 0;
	    			SrcRB = 0;
	    			SrcRA = 0;
	    			RegW  = 1;
	    			SrcA  = 0;
	    			SrcB  = 0;
	    			ALUOp = 2'b00;
					MemW  = 0;
	    			MemR  = 0;
	    			WB 	  = 2'b00;
	            end
	            4'b0010: begin // SUB
	                SrcPc = 2'b00;
	                SrcRW = 0;
	    			SrcRB = 0;
	    			SrcRA = 0;
	    			RegW  = 1;
	    			SrcA  = 0;
	    			SrcB  = 0;
	    			ALUOp = 2'b01;
					MemW  = 0;
	    			MemR  = 0;
	    			WB 	  = 2'b00;
	            end
	            4'b0011: begin // ANDI
	                SrcPc = 2'b00;
	                SrcRW = 0;
	    			SrcRA = 0;
	    			RegW  = 1;
	    			SrcA  = 0;
	    			SrcB  = 1;
	    			ALUOp = 2'b10;
					MemW  = 0;
	    			MemR  = 0;
	    			WB 	  = 2'b00;
	    			TakeExt1  =	0;
	            end
	            4'b0100: begin // ADDI
	                SrcPc = 2'b00;
	                SrcRW = 0;
	    			SrcRA = 0;
	    			RegW  = 1;
	    			SrcA  = 0;
	    			SrcB  = 1;
	    			ALUOp = 2'b00;
					MemW  = 0;
	    			MemR  = 0;
	    			WB 	  = 2'b00;
					TakeExt1  = 0;
	            end
	            4'b0101: begin // LW
	                SrcPc = 2'b00;
	                SrcRW = 0;
	    			SrcRA = 0;
	    			RegW  = 1;
	    			SrcA  = 0;
	    			SrcB  = 1;
	    			ALUOp = 2'b00;
					MemAddSrc = 0;
					MemW  = 0;
	    			MemR  = 1;
	    			WB 	  = 2'b01;
	    			TakeExt1  =	0;
	    			TakeExt2  =	0;
					byte_en   = 0;
	            end
	            4'b0110: begin // LBu or LBs
	                SrcPc = 2'b00;
	                SrcRW = 0;
	    			SrcRB = 0;
	    			SrcRA = 0;
	    			RegW  = 1;
	    			SrcA  = 0;
	    			SrcB  = 1;
	    			ALUOp = 2'b00;
					MemAddSrc = 0;
					MemW  = 0;
	    			MemR  = 1;
	    			WB 	  = 2'b01;
	    			TakeExt1  =	0;
	    			TakeExt2  =	1;
					byte_en   =	1;
	            end
	            4'b0111: begin // SW
	                SrcPc = 2'b00;
	    			SrcRB = 1;
	    			SrcRA = 0;
	    			RegW  = 0;
	    			SrcA  = 0;
	    			SrcB  = 1;
	    			ALUOp = 2'b00;
					MemAddSrc = 0;
					DataInSrc =	0;
					MemW  = 1;
	    			MemR  = 0;
	    			TakeExt1  =	0;
					byte_en   = 0;
	            end
	            4'b1000: begin // BGT or BGTZ
	                if ( mode) begin
						SrcA = 1;
					end 
					else begin
					 	SrcA = 0;
					end
					if ( (NF == 1) && (ZF == 0)) begin
						SrcPc = 2'b01;
					end
					else begin
						SrcPc = 2'b00;
					end
					
	    			SrcRB = 1;
	    			SrcRA = 0; 
					
	    			RegW  = 0;
					
	    			SrcA = 	mode;
	    			SrcB  = 0;
	    			ALUOp = 2'b01;
					MemW  = 0;
	    			MemR  = 0;
	    			TakeExt1  =	1;
						
	            end
	            4'b1001: begin // BLT or BLTZ
	                if ( mode) begin
						SrcA = 1;
					end 
					else begin
					 	SrcA = 0;
					end
					if (NF == 0 && ZF == 0) begin
						SrcPc = 2'b01;
					end else begin
						SrcPc = 2'b00;
					end
					
	    			SrcRB = 1;
	    			SrcRA = 0;
	    			RegW  = 0;
	    			SrcA = 	mode;
	    			SrcB  = 0;
	    			ALUOp = 2'b01;
					MemW  = 0;
	    			MemR  = 0;
	    			TakeExt1  =	1;
	            end
	            4'b1010: begin // BEQ or BEQZ
	                if ( mode) begin
						SrcA = 1;
					end 
					else begin
					 	SrcA = 0;
					end
					if (ZF == 1) begin
						SrcPc = 2'b01;
					end else begin
						SrcPc = 2'b00;
					end
					
	    			SrcRB = 1;
	    			SrcRA = 0;
	    			RegW  = 0;
	    			SrcA = 	mode;
	    			SrcB  = 0;
	    			ALUOp = 2'b01;
					MemW  = 0;
	    			MemR  = 0;
	    			TakeExt1  =	1;
	            end
	            4'b1011: begin // BNE or BNEZ
	                if ( mode) begin
						SrcA = 1;
					end 
					else begin
					 	SrcA = 0;
					end
					if (ZF != 1) begin
						SrcPc = 2'b01;
					end
					else begin
						SrcPc = 2'b00;
					end
					
	    			SrcRB = 1;
	    			SrcRA = 0;
	    			RegW  = 0;
	    			SrcA = 	mode;
	    			SrcB  = 0;
	    			ALUOp = 2'b01;
					MemW  = 0;
	    			MemR  = 0;
	    			TakeExt1  =	1;
	            end
	            4'b1100: begin // JMP
	                SrcPc = 2'b10;
	    			RegW  = 0;
					MemW  = 0;
	    			MemR  = 0;
	    			WB 	  = 2'b00;
	            end
	            4'b1101: begin // CALL
	                SrcPc = 2'b10;
	                SrcRW = 1;
	    			RegW  = 1;
					MemW  = 0;
	    			MemR  = 0;
	    			WB 	  = 2'b10;
	            end
	            4'b1110: begin // RET
	                SrcPc = 2'b11;
					SrcRA = 1;
					RegW  = 0;
					MemW  = 0;
					MemR  = 0;
					
					
	            end
	            4'b1111: begin // Sv
	                SrcPc = 2'b00;
					SrcRA = 0;
					RegW  = 0;
					MemAddSrc = 1;
					DataInSrc = 1;
					MemW  = 1;
					MemR  = 0;
	            end
	            
endcase
end
    end
endmodule
