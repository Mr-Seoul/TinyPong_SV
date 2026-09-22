module tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import paddle_pkg::*;

  localparam PADDLE_SIDE = 0; // Left = 0, Right = 1

  logic clk = 0;
  always #5 clk = ~clk;

  paddle_if #(.PADDLE_SIDE(PADDLE_SIDE)) dut_if (.clk(clk));

  paddle #(.PADDLE_SIDE(PADDLE_SIDE)) dut (
      .clk(clk),
      .rst(dut_if.rst),

      .updateLogic(dut_if.screenDone),
      .buttonUp   (dut_if.in),

      .screenX(dut_if.screenX),
      .screenY(dut_if.screenY),

      .paddleY(dut_if.paddleY),
      .inbound(dut_if.inbound),

      .diffX(dut_if.diffX)
  );

  initial begin
    uvm_config_db#(virtual paddle_if)::set(null, "*", "vif", dut_if);
    uvm_config_db#(int)::set(null, "*", "SIDE", PADDLE_SIDE);
    run_test();
  end

endmodule
