module tb_processor;

reg clk;
reg reset;

Processor dut(
    .clk(clk),
    .reset(reset)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    #16;
    reset = 0;
end

initial begin
    $dumpfile("processor.vcd");
    $dumpvars(0, tb_processor);

    #200;
    $finish;
end

endmodule