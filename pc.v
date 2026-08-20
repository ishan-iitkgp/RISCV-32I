module pc (
    input clk,
    input [31:0] pcplus4,
    input [31:0] aluresult,
    input [1:0]pcsrc,
    input stall,

    output reg[31:0] pcnxt
);
    reg [31:0] pctemp;
    always @(*) 
    begin
        case (pcsrc[0])
            1'b0: pctemp=pcplus4;
            1'b1: pctemp=aluresult;
            default:pctemp=pcplus4; 
        endcase
        if(pcsrc[1])
        begin
            pctemp=32'b0;
        end
    end
    always @(posedge clk) 
    begin
        if (stall) pcnxt<=pcnxt;
        else pcnxt<=pctemp;
    end
    
endmodule