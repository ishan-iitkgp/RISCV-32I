module Processor (
    input clk,
    input reset
);
    wire [31:0]  pc_if,pc_of,pc_ex, instruction_if,instruction_of, pcplus4_if,pcplus4_of,pcplus4_ex,pcplus4_ma,pcplus4_rw, aluresult_ex,aluresult_ma,aluresult_rw, rd1_of,rd1_ex_temp, rd2_of,rd2_ex_temp,writedata_ma_temp,immext_of,immext_ex, readdata_ma,readdata_rw;
    wire [1:0] ResultSrc_of,ResultSrc_ex,ResultSrc_ma,ResultSrc_rw, Alusrc_of,Alusrc_ex,F1,F2;
    wire [2:0] Alucontrol_of,Alucontrol_ex, ImmSrc, func3_alu_of,func3_alu_ex,MemCont;
    wire F3,MemWrite_of,MemWrite_ex,MemWrite_ma, RegWrite_of,RegWrite_ex,RegWrite_ma,RegWrite_rw, branch,B_type_of,L_type_of,L_type_ex,B_type_ex,Jump_of,Jump_ex,temp;
    reg [31:0] result,rd1_ex,rd2_ex,writedata_ma;
    wire [1:0] PCSrc;
    wire[4:0] rd_ex,rd_ma,rd_rw,rs1_ex,rs2_ex,rs2_ma;
    wire bubble_l1,bubble_l2,stall_if_of,stall_pc;

    if_of l1 (.clk(clk),.pcplus4(pcplus4_if),.pc(pc_if),.instr(instruction_if),.reset(reset),.bubble(bubble_l1),.stall(stall_if_of),.pcplus4_out(pcplus4_of),.pc_out(pc_of),.instr_out(instruction_of));
    of_ex l2 (.clk(clk),.pcplus4(pcplus4_of),.imm(immext_of),.ltype(L_type_of),.ltype_out(L_type_ex),.rd(instruction_of[11:7]),.pc(pc_of),.rd2(rd2_of),.rd1(rd1_of),.AluControl(Alucontrol_of),.AluSrc(Alusrc_of),.func3_alu(func3_alu_of),.Btype(B_type_of),.Jump(Jump_of),.MemWrite(MemWrite_of),.Resultsrc(ResultSrc_of),.RegWrite(RegWrite_of),.reset(reset),.bubble(bubble_l2),.rs1(instruction_of[19:15]),.rs2(instruction_of[24:20]),
    .pcplus4_out(pcplus4_ex),.imm_out(immext_ex),.rd_out(rd_ex),.pc_out(pc_ex),.rd2_out(rd2_ex_temp),.rd1_out(rd1_ex_temp),.AluControl_out(Alucontrol_ex),.AluSrc_out(Alusrc_ex),.func3_alu_out(func3_alu_ex),.Btype_out(B_type_ex),.Jump_out(Jump_ex),.MemWrite_out(MemWrite_ex),.Resultsrc_out(ResultSrc_ex),.RegWrite_out(RegWrite_ex),.rs1_out(rs1_ex),.rs2_out(rs2_ex));
    ex_ma l3 (.clk(clk),.pcplus4(pcplus4_ex),.rd(rd_ex),.Writedata(rd2_ex),.AluResult(aluresult_ex),.func3_alu(func3_alu_ex),.MemWrite(MemWrite_ex),.Resultsrc(ResultSrc_ex),.RegWrite(RegWrite_ex),
    .pcplus4_out(pcplus4_ma),.rs2(rs2_ex),.rs2_out(rs2_ma),.rd_out(rd_ma),.Writedata_out(writedata_ma_temp),.AluResult_out(aluresult_ma),.Memcontrol_out(MemCont),.MemWrite_out(MemWrite_ma),.Resultsrc_out(ResultSrc_ma),.RegWrite_out(RegWrite_ma),.reset(reset));
    ma_rb l4 (.clk(clk),.pcplus4(pcplus4_ma),.rd(rd_ma),.Readdata(readdata_ma),.AluResult(aluresult_ma),.Resultsrc(ResultSrc_ma),.RegWrite(RegWrite_ma),.
    pcplus4_out(pcplus4_rw),.rd_out(rd_rw),.Readdata_out(readdata_rw),.AluResult_out(aluresult_rw),.Resultsrc_out(ResultSrc_rw),.RegWrite_out(RegWrite_rw),.reset(reset));
    
    pc pc1(.clk(clk), .pcplus4(pcplus4_if), .pcsrc(PCSrc), .aluresult(aluresult_ex), .pcnxt(pc_if),.stall(stall_pc));
    pcplus4 pcplus4_1(.pc(pc_if), .pcplus(pcplus4_if));
    instr_mem instruction_memory1(.pc(pc_if), .instr(instruction_if));
    controlunit controlunit1(.opcode(instruction_of[6:0]),.L_type(L_type_of),.func3(instruction_of[14:12]), .reset(reset), .func7_30th(instruction_of[30]), .B_type(B_type_of), .func3_alu(func3_alu_of), .ResultSrc(ResultSrc_of), .MemWrite(MemWrite_of), .AluSrc(Alusrc_of), .ImmSrc(ImmSrc), .RegWrite(RegWrite_of), .PCSrc(PCSrc[1]), .AluControl(Alucontrol_of), .Jump(Jump_of));
    Register register1(.clk(clk), .reset(reset), .A1(instruction_of[19:15]), .A2(instruction_of[24:20]), .A3(rd_rw), .WriteData(result), .WriteEnable(RegWrite_rw), .R1(rd1_of), .R2(rd2_of));
    extend extend1(.imm(instruction_of[31:7]), .ImmSrc(ImmSrc), .immext(immext_of));
    alu alu1(.RD1(rd1_ex), .RD2(rd2_ex), .PC(pc_ex), .Imm(immext_ex),  .AluControl(Alucontrol_ex), .AluSrc(Alusrc_ex), .func3(func3_alu_ex), .AluResultFinal(aluresult_ex), .branch(branch));
    data_mem data_memory1(.clk(clk), .MemWrite(MemWrite_ma), .address(aluresult_ma), .readdata(readdata_ma), .writedata(writedata_ma), .MemCont(MemCont));
    hazard_unit h1 (.rs1_of(instruction_of[19:15]),.rs2_of(instruction_of[24:20]),.rs1_ex(rs1_ex),.rs2_ex(rs2_ex),.rs2_ma(rs2_ma),.rd_ex(rd_ex),.rd_ma(rd_ma),.rd_rw(rd_rw),.branch(PCSrc[0]),.ltype_ex(L_type_ex),.RegWrite_rw(RegWrite_rw),.RegWrite_ma(RegWrite_ma),.MemWrite_ma(MemWrite_ma),.ImmSrc(ImmSrc),
    .Stallpc(stall_pc),.Stall_if_of(stall_if_of),.Flush_if_of(bubble_l1),.Flush_of_ex(bubble_l2),.Forward_1_ex(F1),.Forward_2_ex(F2),.Forward_ma(F3));

    assign temp=(branch&B_type_ex);
    assign PCSrc[0]=(Jump_ex|temp); 
    always @(*) 
    begin 
 
        case (ResultSrc_rw)
            2'b00: result=pcplus4_rw;
            2'b01: result=aluresult_rw;
            2'b10: result=readdata_rw;
            default: result=pcplus4_rw;
        endcase

        case (F1)
            2'b00: rd1_ex=rd1_ex_temp;
            2'b01: rd1_ex=aluresult_ma;
            2'b10: rd1_ex=result;
            2'b11: rd1_ex=aluresult_ma;
        endcase 

        case (F2)
            2'b00: rd2_ex=rd2_ex_temp;
            2'b01: rd2_ex=aluresult_ma;
            2'b10: rd2_ex=result;
            2'b11: rd2_ex=aluresult_ma;
        endcase

        case (F3)
            1'b0: writedata_ma=writedata_ma_temp;
            1'b1: writedata_ma=result;
        endcase
    end
endmodule

