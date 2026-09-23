`ifndef SYNCHRONIZER_SV
`define SYNCHRONIZER_SV

module synchronizer
#(
    parameter DEFAULT = 0
)
(
    input logic clk,
    input logic rst,

    input logic in,
    output logic out
);

logic [1:0] syncReg = { DEFAULT[0], DEFAULT[0] };

always_comb begin
    out = syncReg[1];
end

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        syncReg <= {DEFAULT[0], DEFAULT[0]};
    end else begin
        //Sync pipeline
        syncReg[0] <= in;
        syncReg[1] <= syncReg[0];
    end
end

endmodule

`endif