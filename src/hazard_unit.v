module hazard_unit (
    input [4:0] rs1_of,
    input [4:0] rs2_of,                   ////?????
    input [4:0] rs1_ex,
    input [4:0] rs2_ex,
    input [4:0] rs2_ma,
    input [4:0] rd_ex,
    input [4:0] rd_ma,
    input [4:0] rd_rw,
    input branch,
    input ltype_ex,
    //input [1:0]ResultSrc, ///????
    input RegWrite_rw,
    input RegWrite_ma,
    input MemWrite_ma,
    input [2:0] ImmSrc,

    output reg Stallpc,
    output reg Stall_if_of,
    output reg Flush_if_of,
    output reg Flush_of_ex,                  //for control hazards
    output reg [1:0] Forward_1_ex,
    output reg [1:0] Forward_2_ex,
    output reg Forward_ma                   //for data hazards

) ;
    reg t1,t2;

    always @(*)
    begin
        Forward_1_ex[0]=(rd_ma==rs1_ex)&(RegWrite_ma)&(|rd_ma);    //for data hazards
        Forward_2_ex[0]=(rd_ma==rs2_ex)&(RegWrite_ma)&(|rd_ma);
        Forward_1_ex[1]=(rd_rw==rs1_ex)&(RegWrite_rw)&(|rd_rw);
        Forward_2_ex[1]=(rd_rw==rs2_ex)&(RegWrite_rw)&(|rd_rw);
        Forward_ma=(rs2_ma==rd_rw)&(RegWrite_rw)&(|rd_rw)&(MemWrite_ma);  

        t1=((ImmSrc==000)|(ImmSrc==101)|(ImmSrc==010)|(ImmSrc==001));   //for rs1
        t2=((ImmSrc==101)|(ImmSrc==010)|(ImmSrc==001));                 //for rs2
        
        Flush_if_of=branch;                                        //for control hazard
        Flush_of_ex=branch|((ltype_ex)&(((rd_ex==rs1_of)&(t1))|((rd_ex==rs2_of)&(t2))));
        Stallpc=(ltype_ex)&(((rd_ex==rs1_of)&(t1))|((rd_ex==rs2_of)&(t2)));
        Stall_if_of=(ltype_ex)&(((rd_ex==rs1_of)&(t1))|((rd_ex==rs2_of)&(t2)));
    end 
endmodule