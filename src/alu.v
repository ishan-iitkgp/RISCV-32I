// Implementation of the ALU for the 32-bit RISC-V Processor
// Behavioral description
// actual hardware implementation is mentioned in comments
module alu(
    input [31:0] RD1,
    input [31:0] RD2,
    input [31:0] PC,
    input [31:0] Imm,
    input [2:0] AluControl,
    input [1:0] AluSrc,
    input [2:0] func3,
    //input AluControl[2],//31st bit for functions having same opcode
    output reg branch,
    output reg [31:0] AluResultFinal
);

    wire [31:0] res;
    reg [31:0] AluResult;
    wire cout;
    wire [31:0] SrcA;
    wire [31:0] SrcB;
   
    //wire [31:0] b_operand;
    //ALUc[0]=lui ALUc[1]=B type instructions
    assign SrcA = AluSrc[0] ? PC : RD1;
    assign SrcB = AluSrc[1] ? Imm : RD2;
    //assign b_operand = AluControl[2] ? ~SrcB : SrcB; 
   
    rca32 a0(res, cout, SrcA, SrcB, AluControl[2]);          //instantiating the rca32 to calculate the sum/difference, AluControl[2] being the instr30
    //always block
    always @(*) 
    begin
        case (func3) //implemented using a 8 input mux with 3 bit select line.
            3'b000: AluResult = res;
            3'b001: AluResult = SrcA<<SrcB[4:0];
            3'b010: if ($signed(SrcA)<$signed(SrcB))  //comparison can be implemented using the adder/subtractor, do a-b and store a flag=1 if res<0
            begin
                AluResult= 32'd1;
            end 
            else 
            begin
                AluResult= 32'd0;
            end             
            3'b011: if (SrcA<SrcB) 
            begin
                AluResult= 32'd1;
            end 
            else 
            begin
                AluResult= 32'd0;
            end 
            3'b100: AluResult = SrcA ^ SrcB;
            3'b101: AluResult = AluControl[2]==0? SrcA>>SrcB[4:0] : $signed(SrcA)>>>SrcB[4:0]; 
            3'b110: AluResult = SrcA | SrcB;
            3'b111: AluResult = SrcA & SrcB;
            default: AluResult=32'd0;
        endcase

        //branch decision
        branch = 1'b0;                     //default 
        if (RD1==RD2 && func3==3'b000)
        begin
            branch=1'b1;
        end
        else if (RD1!=RD2 && func3==3'b001)
        begin
            branch=1'b1;
        end
        else if ($signed(RD1)<$signed(RD2) && func3==3'b100)
        begin
            branch=1'b1;
        end
        else if ($signed(RD1)>=$signed(RD2) && func3==3'b101)
        begin
            branch=1'b1;
        end
        else if (RD1<RD2 && func3==3'b110)
        begin
            branch=1'b1;
        end
        else if (RD1>=RD2 && func3==3'b111)
        begin
            branch=1'b1;
        end
        ///

        case (AluControl[1:0])
            2'b10: AluResultFinal = AluResult ;
            2'b01: AluResultFinal = SrcB ;
            2'b00: AluResultFinal = res;
            2'b11: AluResultFinal = 32'b0;
        endcase

    end

endmodule





// full adder described in a structural way
module fulladder (
    output s,
    output c_out,
    input a,
    input b, 
    input c_in
);
    wire t1, t2, t3, t4, temp;
    //s=a^b^c_in;
    xor g6(t4, a, b);
    xor g7(s, t4, c_in);

    //c_out=a&&b || b&&c_in || c_in&&a;
    and g1(t1, a, b);
    and g2(t2, b, c_in);
    and g3(t3, c_in, a);
    or g4(temp, t1, t2);
    or g5(c_out, t3, temp);
    
endmodule

// rca described in a structural way
module rca32(
    output [31:0]sum,
    output c_out,
    input [31:0]A,
    input [31:0]B,
    input c_in    
);
    wire [30:0] t;
    wire [31:0] B1;
    assign B1 = B ^ {32{c_in}};
    //B1 is our actual arhgument now
    fulladder f0(sum[0], t[0], A[0], B1[0], c_in);
    fulladder f1(sum[1], t[1], A[1], B1[1], t[0]);
    fulladder f2(sum[2], t[2], A[2], B1[2], t[1]);
    fulladder f3(sum[3], t[3], A[3], B1[3], t[2]);
    fulladder f4(sum[4], t[4], A[4], B1[4], t[3]);
    fulladder f5(sum[5], t[5], A[5], B1[5], t[4]);
    fulladder f6(sum[6], t[6], A[6], B1[6], t[5]);
    fulladder f7(sum[7], t[7], A[7], B1[7], t[6]);
    fulladder f8(sum[8], t[8], A[8], B1[8], t[7]);
    fulladder f9(sum[9], t[9], A[9], B1[9], t[8]);
    fulladder f10(sum[10], t[10], A[10], B1[10], t[9]);
    fulladder f11(sum[11], t[11], A[11], B1[11], t[10]);
    fulladder f12(sum[12], t[12], A[12], B1[12], t[11]);
    fulladder f13(sum[13], t[13], A[13], B1[13], t[12]);
    fulladder f14(sum[14], t[14], A[14], B1[14], t[13]);
    fulladder f15(sum[15], t[15], A[15], B1[15], t[14]);
    fulladder f16(sum[16], t[16], A[16], B1[16], t[15]);
    fulladder f17(sum[17], t[17], A[17], B1[17], t[16]);
    fulladder f18(sum[18], t[18], A[18], B1[18], t[17]);
    fulladder f19(sum[19], t[19], A[19], B1[19], t[18]);
    fulladder f20(sum[20], t[20], A[20], B1[20], t[19]);
    fulladder f21(sum[21], t[21], A[21], B1[21], t[20]);
    fulladder f22(sum[22], t[22], A[22], B1[22], t[21]);
    fulladder f23(sum[23], t[23], A[23], B1[23], t[22]);
    fulladder f24(sum[24], t[24], A[24], B1[24], t[23]);
    fulladder f25(sum[25], t[25], A[25], B1[25], t[24]);
    fulladder f26(sum[26], t[26], A[26], B1[26], t[25]);
    fulladder f27(sum[27], t[27], A[27], B1[27], t[26]);
    fulladder f28(sum[28], t[28], A[28], B1[28], t[27]);
    fulladder f29(sum[29], t[29], A[29], B1[29], t[28]);
    fulladder f30(sum[30], t[30], A[30], B1[30], t[29]);
    fulladder f31(sum[31], c_out, A[31], B1[31], t[30]);
    
endmodule
