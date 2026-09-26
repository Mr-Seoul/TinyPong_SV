interface vga_if (
    input logic clk
);

  logic rst;
  logic in; //not in DUT, standardized driver reuse

  logic input1;
  logic input2;

  logic [1:0] outR;
  logic [1:0] outG;
  logic [1:0] outB;

  logic hsync;
  logic vsync;

    clocking driver_cb @(posedge clk);
        output in;
        inout rst;
        input hsync, vsync;
    endclocking

    clocking monitor_cb @(posedge clk);
        input rst, input1, input2, outR, outG, outB, hsync, vsync;
    endclocking

endinterface
