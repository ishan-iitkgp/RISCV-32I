module extend (
    input [31:7] imm,// from instruction
    input [2:0]ImmSrc, //from control unit
    output reg [31:0] immext
);
    //reg e;
   // reg [11:0] finalimm;
    //reg [19:0] finalimmJ;
    always @(*)
    begin
        //First we have to rearrange the scattered 12 it immediate
        /*
        I type : 000
        S type : 001
        B type : 010
        U type : 011
        J type : 100
        */
        //once rearrangement is done, e is the sign bit, and we repeat the sign bit to get the extended immediate
        case (ImmSrc)
            3'b000: //I type- load type
                immext={{20{imm[31]}}, imm[31:20]};
            3'b001: //S type 
                immext={{20{imm[31]}}, imm[31:25], imm[11:7]};
            3'b010: //B type
                immext={{20{imm[31]}}, imm[7], imm[30:25], imm[11:8], 1'b0};
            3'b011: //U type
                immext={{imm[31:12]}, 12'b0};
            3'b100: //J type 
                immext={{12{imm[31]}}, imm[19:12], imm[20], imm[30:21], 1'b0};
            3'b101:  //Rtype for hazard unit
                immext= 32'b0;
            default: immext= 32'b0;// IMM_R (101) is unused because R-type instructions do not have an immediate.
        endcase
        
    end

endmodule