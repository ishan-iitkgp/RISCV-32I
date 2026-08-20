module if_of (
    input clk,
    input [31:0] pcplus4,
    input [31:0] pc,
    input [31:0] instr,
    input reset,
    input bubble,
    input stall,

    output reg [31:0] pcplus4_out,
    output reg [31:0] pc_out,
    output reg [31:0] instr_out
);
    always @(posedge clk or posedge reset) 
    begin
        if (reset )
            begin
                pc_out<=32'b0;
                instr_out<=32'h00000013;
                pcplus4_out<=32'b0;
            end
        else if (bubble )
            begin
                pc_out<=32'b0;
                instr_out<=32'h00000013;
                pcplus4_out<=32'b0;
            end
        else if (stall)
            begin
                pc_out<=pc_out;
                instr_out<=instr_out;
                pcplus4_out<=pcplus4_out;
            end
        else 
            begin
                pc_out<=pc;
                instr_out<=instr;
                pcplus4_out<=pcplus4;
            end
    end
endmodule

module of_ex (
    input clk,
    input [31:0] pcplus4,              //data control units
    input [31:0] imm,
    input [4:0] rd,
    input [31:0] pc, 
    input [31:0] rd2, 
    input [31:0] rd1,                   
    input [2:0] AluControl,            //control units
    input [1:0] AluSrc,
    input [2:0] func3_alu,
    input [4:0] rs1,
    input [4:0] rs2,
    input Btype,
    input Jump,
    input MemWrite,
    input [1:0] Resultsrc,
    input RegWrite,
    input reset,
    input bubble,
    input ltype,


    output reg [31:0] pcplus4_out,              //data control units
    output reg [31:0] imm_out,
    output reg [4:0] rd_out,
    output reg [31:0] pc_out, 
    output reg [31:0] rd2_out,
    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out, 
    output reg [31:0] rd1_out,                   
    output reg [2:0] AluControl_out,            //control units
    output reg [1:0] AluSrc_out,
    output reg [2:0] func3_alu_out,
    output reg Btype_out,
    output reg Jump_out,
    output reg MemWrite_out,
    output reg [1:0] Resultsrc_out,
    output reg RegWrite_out, 
    output reg ltype_out
);
    always @(posedge clk or posedge reset) begin
    if (reset) begin
        // asynch rset-
        // Data path
        pc_out         <= 32'b0;
        pcplus4_out    <= 32'b0;
        imm_out        <= 32'b0;
        rd1_out        <= 32'b0;
        rd2_out        <= 32'b0;
        rd_out         <= 5'b0;
        rs1_out        <= 5'b0;
        rs2_out        <= 5'b0;
        
        // Control path 
        Resultsrc_out  <= 2'b0;
        MemWrite_out   <= 1'b0;
        RegWrite_out   <= 1'b1;
        AluControl_out <= 3'b0;
        AluSrc_out     <= 2'b0;
        func3_alu_out  <= 3'b0;
        Btype_out      <= 1'b0;
        Jump_out       <= 1'b0;
        ltype_out      <= 1'b0;

    end else if (bubble) begin
        //  synch bubbble
        // Pushing 0s through the control path turns the flushed instruction into a NOP.
        // Data path in terms of nop instruction 
        pc_out         <= 32'b0;
        pcplus4_out    <= 32'b0;
        imm_out        <= 32'b0;
        rd1_out        <= 32'b0;
        rd2_out        <= 32'b0;
        rd_out         <= 5'b0;
        rs1_out        <= 5'b0;
        rs2_out        <= 5'b0;
        
        // Control path
        Resultsrc_out  <= 2'b0;
        MemWrite_out   <= 1'b0; 
        RegWrite_out   <= 1'b1;
        AluControl_out <= 3'b0;
        AluSrc_out     <= 2'b0;
        func3_alu_out  <= 3'b0;
        Btype_out      <= 1'b0;
        Jump_out       <= 1'b0;
        ltype_out      <= 1'b0;

    end else begin
        // Data pth
        pc_out         <= pc;
        pcplus4_out    <= pcplus4;
        imm_out        <= imm;
        rd1_out        <= rd1;
        rd2_out        <= rd2;
        rd_out         <= rd;
        rs1_out        <= rs1;
        rs2_out        <= rs2;
        
        // Control path
        Resultsrc_out  <= Resultsrc;
        MemWrite_out   <= MemWrite;
        RegWrite_out   <= RegWrite;
        AluControl_out <= AluControl;
        AluSrc_out     <= AluSrc;
        func3_alu_out  <= func3_alu;
        Btype_out      <= Btype;
        Jump_out       <= Jump;
        ltype_out      <= ltype;
    end
end

endmodule

module ex_ma (
    input clk,
    input [31:0] pcplus4,              //data control units
    input [4:0] rd,
    input [31:0] Writedata,
    input [31:0] AluResult,
    input [2:0] func3_alu,             //control units
    input MemWrite,
    input [1:0] Resultsrc,
    input RegWrite,
    input reset,
    input [4:0] rs2,

    output reg [31:0] pcplus4_out,          //data control units
    output reg [4:0] rd_out,
    output reg [4:0] rs2_out,
    output reg [31:0] Writedata_out,
    output reg [31:0] AluResult_out,
    output reg [2:0] Memcontrol_out,         //control units
    output reg MemWrite_out,
    output reg [1:0] Resultsrc_out,
    output reg RegWrite_out
);
    always @(posedge clk or posedge reset) begin 
    if (reset) begin
        pcplus4_out    <= 32'b0;
        rd_out         <= 5'b0;
        Writedata_out  <= 32'b0;
        AluResult_out  <= 32'b0;
        Memcontrol_out <= 3'b0;
        MemWrite_out   <= 1'b0;
        Resultsrc_out  <= 2'b0;
        RegWrite_out   <= 1'b0;
        rs2_out        <= 5'b0;
    end 
    else 
    begin
        pcplus4_out    <=pcplus4;
        rd_out         <=rd;
        AluResult_out  <=AluResult;
        Writedata_out  <=Writedata;
        Memcontrol_out <=func3_alu;
        MemWrite_out   <=MemWrite;
        Resultsrc_out  <=Resultsrc;
        RegWrite_out   <=RegWrite;
        rs2_out        <= rs2;
    end
    end
    
endmodule

module ma_rb (
    input clk,
    input [31:0] pcplus4,                 //data units
    input [4:0] rd,
    input [31:0] Readdata,
    input [31:0] AluResult,
    input [1:0] Resultsrc,                //control units 
    input RegWrite,
    input reset,
    
    output reg [31:0] pcplus4_out,            //data units
    output reg [4:0] rd_out,
    output reg [31:0] Readdata_out,    
    output reg [31:0] AluResult_out,     
    output reg [1:0] Resultsrc_out,           //control units
    output reg RegWrite_out
);
    always @(posedge clk) begin
    if (reset) begin
        AluResult_out<=32'b0;
        Resultsrc_out<=00;
        pcplus4_out<=32'b0;
        Readdata_out<=32'b0;
        RegWrite_out<=1'b0;
        rd_out<=5'b0;
    end
    else begin
        AluResult_out<=AluResult;
        Resultsrc_out<=Resultsrc;
        pcplus4_out<=pcplus4;
        Readdata_out<=Readdata;
        RegWrite_out<=RegWrite;
        rd_out<=rd;
    end
    end
endmodule
