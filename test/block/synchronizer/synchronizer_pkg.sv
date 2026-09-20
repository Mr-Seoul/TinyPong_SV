package synchronizer_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "common/transactions/bit_transaction.sv"
  `include "common/coverage/bit_coverage.sv"
  `include "common/sequences/bit_sequence.sv"
  `include "common/sequencers/bit_sequencer.sv"
  `include "common/drivers/chain_bit_driver.sv"
  `include "common/monitors/bit_monitor.sv"
  `include "classes/synchronizer_agent.sv"
  `include "classes/synchronizer_predictor.sv"
  `include "common/scoreboards/bit_scoreboard.sv"
  `include "classes/synchronizer_env.sv"
  `include "classes/synchronizer_test.sv"

endpackage
