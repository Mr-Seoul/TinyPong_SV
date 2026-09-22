module tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import ball_pkg::*;

  logic clk = 0;
  always #5 clk = ~clk;

  ball_if dut_if (.clk(clk));

  ball dut (
      .clk(clk),
      .rst(dut_if.rst),

      .updateLogic(dut_if.screenDone),

      .screenX(dut_if.screenX),
      .screenY(dut_if.screenY),

      .paddleLeftY (dut_if.paddleLeftY),
      .paddleRightY(dut_if.paddleRightY),

      .inbound(dut_if.inbound),

      .outLeftBound (dut_if.outLeftBound),
      .outRightBound(dut_if.outRightBound)
  );

  initial begin
    uvm_config_db#(virtual ball_if)::set(null, "*", "vif", dut_if);
    run_test();
  end

endmodule
