module tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import game_manager_pkg::*;

  logic clk = 0;
  always #5 clk = ~clk;

  game_manager_if dut_if (.clk(clk));
  game_manager_if bt1_if (.clk(clk));
  game_manager_if bt2_if (.clk(clk));

  assign dut_if.input1 = bt1_if.in;
  assign dut_if.input2 = bt2_if.in;

  gameManager dut (
      .clk(clk),
      .rst(dut_if.rst),

      .outR(dut_if.outR),
      .outG(dut_if.outG),
      .outB(dut_if.outB),

      .screenX(dut_if.screenX),
      .screenY(dut_if.screenY),

      .screenDone(dut_if.screenDone),

      .input1(dut_if.input1),
      .input2(dut_if.input2)
  );

  initial begin
    uvm_config_db#(virtual game_manager_if)::set(null, "*", "vif", dut_if);
    uvm_config_db#(virtual game_manager_if)::set(null, "uvm_test_top.env.agent.bt1_driver", "vif", bt1_if);
    uvm_config_db#(virtual game_manager_if)::set(null, "uvm_test_top.env.agent.bt2_driver", "vif", bt2_if);
    uvm_config_db#(virtual game_manager_if)::set(null, "uvm_test_top", "bt1_vif", bt1_if);
    uvm_config_db#(virtual game_manager_if)::set(null, "uvm_test_top", "bt2_vif", bt2_if);
    run_test();
  end

endmodule
