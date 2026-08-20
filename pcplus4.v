module pcplus4 (
    input [31:0] pc,
    output [31:0] pcplus
);
    wire temp;
    rca32 rca(pcplus,temp,pc,32'd4,1'b0);
endmodule
