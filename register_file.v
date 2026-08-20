//Register file for the 32 bit RISC V Processor

// Register file for the 32-bit RISC-V Processor
module Register (
    input clk,
    input reset,           //  reset input ram ke lie 
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WriteData,
    input WriteEnable,
    output [31:0] R1,
    output [31:0] R2
);

    reg [31:0] rf [31:0];
    integer i;             

    // synchronous Write Logic (on positive edge of clock)
    always @(negedge clk or posedge reset) 
    begin
        if (reset) 
        begin
            for (i = 0; i < 32; i = i + 1) 
            begin
                rf[i] <= 32'b0;
            end
        end 
        else if (WriteEnable && (A3 != 5'b0)) 
        begin
            rf[A3] <= WriteData; // x0 is always 0
        end
    end

    
    assign R1 = (A1 == 5'b0) ? 32'b0 : rf[A1];
    assign R2 = (A2 == 5'b0) ? 32'b0 : rf[A2];

endmodule