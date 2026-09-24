interface game_manager_if (
    input logic clk
);

  logic rst;

  logic in; //not in DUT, but simplifies driver reuse

  logic input1;
  logic input2;

  logic signed [10:0] screenX;
  logic signed [10:0] screenY;
  logic screenDone;

  logic [1:0] outR;
  logic [1:0] outG;
  logic [1:0] outB;

    clocking driver_cb @(posedge clk);
        input outR, outG, outB;
        output in, screenX, screenY, screenDone;
        inout rst;
    endclocking

    clocking monitor_cb @(posedge clk);
        input rst, input1, input2, screenX, screenY, screenDone, outR, outG, outB;
    endclocking

endinterface
