module tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import timing_pkg::*;

  logic clk = 0;
  always #5 clk = ~clk;

  timing_if dut_if (.clk(clk));

  VGATiming dut (
      .screenX(dut_if.screenX),
      .screenY(dut_if.screenY),
      .hsync  (dut_if.hsync),
      .vsync  (dut_if.vsync)
  );

  initial begin
    uvm_config_db#(virtual timing_if)::set(null, "*", "vif", dut_if);
    run_test();
  end

endmodule