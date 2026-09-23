module tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import synchronizer_pkg::*;

  localparam DEFAULT = 0;

  logic clk = 0;
  always #5 clk = ~clk;

  synchronizer_if #(.DEFAULT(DEFAULT)) dut_if (.clk(clk));

  synchronizer #(.DEFAULT(DEFAULT)) dut (
      .clk(clk),
      .rst(dut_if.rst),
      .in (dut_if.in),
      .out(dut_if.out)
  );

  initial begin
    uvm_config_db#(virtual synchronizer_if)::set(null, "*", "vif", dut_if);
    run_test();
  end

endmodule
