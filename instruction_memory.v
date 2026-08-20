//instruction memory for the 32bit riscv processor

module instr_mem (
    input [31:0] pc,
    output [31:0] instr
);
    //so that we can load all the instructions into the program.mem file which will be read eventually and thats our iput for the processor
    initial
    $readmemh("forwarding_hazards_tb.txt",instrmem);

    reg [31:0] instrmem [0:1023];
    assign instr = instrmem[pc[11:2]];

endmodule