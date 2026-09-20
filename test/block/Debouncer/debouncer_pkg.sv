package debouncer_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "common/transactions/bit_transaction.sv"
  `include "common/coverage_reporters/bit_coverage.sv"
  `include "common/sequences/bit_sequence.sv"
  `include "common/sequencers/bit_sequencer.sv"
  `include "common/drivers/frame_bit_driver.sv"
  `include "common/monitors/bit_monitor.sv"
  `include "classes/debouncer_agent.sv"
  `include "classes/debouncer_predictor.sv"
  `include "common/scoreboards/bit_scoreboard.sv"
  `include "classes/debouncer_env.sv"
  `include "classes/debouncer_test.sv"

endpackage
