interface timing_if (
    input logic clk
);

    logic signed [10:0] screenX;
    logic signed [10:0] screenY;
    bit screenDone; //Not exact name in DUT, but standardizes interface

    logic hsync;
    logic vsync;

    clocking driver_cb @(posedge clk);
        input hsync,vsync;
        output screenX,screenY,screenDone;
    endclocking

    clocking monitor_cb @(posedge clk);
        input hsync,vsync,screenX,screenY,screenDone;
    endclocking

endinterface
