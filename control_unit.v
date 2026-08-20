module controlunit (
    input [6:0] opcode,
    input reset,
    input func7_30th,
    //input branch,
    input [2:0] func3,

    output   PCSrc,               //for pc reset
    output  [1:0] ResultSrc,         //for rw mux
    //output  [2:0] MemCont,           //for memory 
    output  MemWrite,
    output [2:0] AluControl,            //for alu 
    output [1:0] AluSrc,
    output [2:0] func3_alu,
    output [2:0] ImmSrc,             //for imme
    output RegWrite,                 //for  register
    //output regreset,
    output B_type,                    //for pipelining 
    output L_type,
    output Jump
);
    
    assign PCSrc=reset;
    //assign PCSrc[0]= (branch&opcode[5]&opcode[6]&~opcode[2])|(opcode[5]&opcode[6]&opcode[2]);                   //(btype and branch) or (jtype or jalr)
    assign B_type=(opcode[5]&opcode[6]&~opcode[2]);                                                             //b type
    assign Jump=(opcode[5]&opcode[6]&opcode[2]);                                                                //jal or jalr
    assign ResultSrc[1]=(~opcode[5]&~opcode[6]&~opcode[4]);                                                     //load type
    assign ResultSrc[0]=(opcode[5]&~opcode[6]&opcode[4])|(~opcode[5]&~opcode[6]&opcode[4]);                     //r or u or immediate type
    //assign MemCont = func3 ;
    assign MemWrite = (opcode[5]&~opcode[6]&~opcode[4]);                                                        // only store instructions
    //assign regreset=reset;
    assign RegWrite= ~(opcode[5]&~opcode[3]&~opcode[4]&~opcode[2]);
    assign ImmSrc[0]=(opcode[2]&~opcode[3]&opcode[4])|(opcode[5]&~opcode[6]&~opcode[4])|(opcode[5]&opcode[4]&~opcode[2]);                         //u and s type or r type
    assign ImmSrc[1]=(opcode[2]&~opcode[3]&opcode[4])|(opcode[5]&opcode[6]&~opcode[2]);                          //u and b type
    assign ImmSrc[2]=(opcode[5]&opcode[3]&~opcode[4])|(opcode[5]&opcode[4]&~opcode[2]);                                                           //j type or r type
    assign AluControl[2]=(func7_30th)&(opcode[5]&opcode[4]&~opcode[2]);                                          //r type and subtraction
    assign AluControl[1]=(~opcode[6]&opcode[4]&~opcode[2]);                                                      //r and i type
    assign AluControl[0]=(~opcode[5]&opcode[4]&opcode[2]);                                                       //lui type
    assign func3_alu=func3;
    assign L_type = (~opcode[5]&~opcode[3]&~opcode[4]&opcode[1]&opcode[0]&~opcode[6]);                            //only l type 
    assign AluSrc[1]=~(opcode[5]&opcode[4]&~opcode[2]);                                                           //not r
    assign AluSrc[0]=(opcode[5]&opcode[3]&~opcode[4])|(opcode[5]&opcode[6]&~opcode[2])|(opcode[2]&~opcode[3]&~opcode[5]); //jal b auipc                                                    //not r

    
endmodule