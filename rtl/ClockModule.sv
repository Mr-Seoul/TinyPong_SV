module clockModule
(
    input logic clk,
    input logic rst,

    output logic slowClk
);

logic [1:0] clockCountReg = 0;

//Slow clock 4x to test on basys 3
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        clockCountReg <= 0;
    end else begin
        clockCountReg <= clockCountReg + 1;
    end
end

always_comb begin
    slowClk = (clockCountReg == 3);
end

endmodule