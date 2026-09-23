`ifndef VGA_TIMING_SV
`define VGA_TIMING_SV

module VGATiming
(
    input logic signed [10:0] screenX,
    input logic signed [10:0] screenY,

    output logic hsync,
    output logic vsync
);

always_comb 
begin
    hsync = 1;
    vsync = 1;
    if (screenX > 655 && screenX < 752) begin
        hsync = 0;
    end 
    if (screenY > 489 && screenY < 492) begin
        vsync = 0;
    end 
end

endmodule

`endif