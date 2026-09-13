module debouncer
#(
    parameter SIZE
)

(
    input logic clk,
    input logic rst,

    input logic in,
    output logic out
);


integer MAXCOUNT = (2 << SIZE)- 1;

logic [SIZE-1:0] count = 0;
logic [2:0] sync = 0;
logic outReg = 0;

always_comb begin
    out = outReg;
end

always_ff @(posedge clk or negedge rst) begin
    if (rst) begin
        outReg <= 0;
    end else begin
        count <= 0;
        if (in != outReg) begin
            count <= count + 1;
            if (count == MAXCOUNT) begin
                outReg <= in;
            end
        end 
    end
end

endmodule