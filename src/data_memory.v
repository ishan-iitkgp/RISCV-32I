//data memory for the 32bit riscv processor
//read and implement again
//need to add sb, shlb, lh

module data_mem(
    input clk,
    input MemWrite,
    input [2:0]MemCont,                //funct3 from the riscv 
    input [31:0] address,
    input [31:0] writedata,
    output reg [31:0] readdata
);
 
    // 4 block to maintain the sb sw blah blah ops
    reg [7:0] datamem0 [0:1023]; 
    reg [7:0] datamem1 [0:1023]; 
    reg [7:0] datamem2 [0:1023]; 
    reg [7:0] datamem3 [0:1023];

    // helps to shift words 
    wire [9:0] word_idx = address[11:2];
    wire [1:0] byte_offset = address[1:0];

    
    wire [31:0] raw_word = {datamem3[word_idx], datamem2[word_idx], datamem1[word_idx], datamem0[word_idx]};

    //rightshift so the target is at the bottom                                   //store operation
    wire [31:0] shifted_word = raw_word >> (8 * byte_offset);
    always @(*) begin
        case (MemCont)
            3'b000: // lb (Load Byte, Sign-Extended)
                readdata = {{24{shifted_word[7]}}, shifted_word[7:0]};                
            3'b001: // lh (Load Halfword, Sign-Extended)
                readdata = {{16{shifted_word[15]}}, shifted_word[15:0]};                
            3'b010: // lw (Load Word)
                readdata = raw_word; 
            3'b100: // lbu (Load Byte Unsigned, Zero-Extended)
                readdata = {24'b0, shifted_word[7:0]};                
            3'b101: // lhu (Load Halfword Unsigned, Zero-Extended)
                readdata = {16'b0, shifted_word[15:0]};
            default: 
                readdata = 32'h00000000;
        endcase
    end


    wire is_sb = (MemCont == 3'b000);                                            //read operation  
    wire is_sh = (MemCont == 3'b001);
    wire is_sw = (MemCont == 3'b010);

    // creating strobe mask 
    wire e0 = MemWrite & (is_sw | (byte_offset == 2'b00));      
    wire e1 = MemWrite & (is_sw | (is_sh & (byte_offset == 2'b00)) | (is_sb & (byte_offset == 2'b01)));
    wire e2 = MemWrite & (is_sw | (is_sh & (byte_offset == 2'b10)) | (is_sb & (byte_offset == 2'b10)));
    wire e3 = MemWrite & (is_sw | (is_sh & (byte_offset == 2'b10)) | (is_sb & (byte_offset == 2'b11)));

    
    // mux type alignment ot shift the bits 
    wire [31:0] aligned_data = writedata << (8 * byte_offset);

    // writes based on strobe mask
    always @(posedge clk) begin
        if (e0) datamem0[word_idx] <= aligned_data[7:0];
        if (e1) datamem1[word_idx] <= aligned_data[15:8];
        if (e2) datamem2[word_idx] <= aligned_data[23:16];
        if (e3) datamem3[word_idx] <= aligned_data[31:24];
    end

endmodule