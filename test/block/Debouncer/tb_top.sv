module tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import debouncer_pkg::*;

  logic clk = 0;
  always #5 clk = ~clk;

  debouncer_if dut_if (.clk(clk));

  debouncer #(.SIZE(16)) dut (
      .clk(clk),
      .rst(dut_if.rst),
      .in (dut_if.in),
      .out(dut_if.out)
  );

  initial begin
    uvm_config_db#(virtual debouncer_if)::set(null, "*", "vif", dut_if);
    run_test();
  end

endmodule
