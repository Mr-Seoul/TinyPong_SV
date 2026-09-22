package paddle_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "common/transactions/bit_transaction.sv"
  `include "common/transactions/screen_transaction.sv"
  `include "common/transactions/screen_button_transaction.sv"
  `include "common/transactions/paddle_transaction.sv"
  `include "common/sequences/bit_sequence.sv"
  `include "common/sequences/screen_sequence.sv"
  `include "common/sequencers/bit_sequencer.sv"
  `include "common/sequencers/screen_sequencer.sv"
  `include "common/drivers/screen_driver.sv"
  `include "common/drivers/single_bit_driver.sv"
  `include "common/monitors/paddle_monitor.sv"
  `include "common/coverage/paddle_coverage.sv"
  `include "classes/paddle_agent.sv"
  `include "classes/paddle_predictor.sv"
  `include "classes/paddle_scoreboard.sv"
  `include "classes/paddle_env.sv"
  `include "classes/paddle_test.sv"

endpackage
