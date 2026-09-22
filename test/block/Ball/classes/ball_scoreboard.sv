class ball_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(ball_scoreboard)

  uvm_tlm_analysis_fifo #(ball_transaction) expected_fifo;
  uvm_tlm_analysis_fifo #(ball_transaction) actual_fifo;

  function new(string name = "ball_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    expected_fifo = new("expected_fifo", this);
    actual_fifo   = new("actual_fifo", this);
  endfunction

  virtual task main_phase(uvm_phase phase);
    ball_transaction expected;
    ball_transaction actual;

    forever begin
      expected_fifo.get(expected);
      actual_fifo.get(actual);
      if (!( actual.inbound === expected.inbound && actual.outLeftBound === expected.outLeftBound && actual.outRightBound === expected.outRightBound ))
        `uvm_error("FAIL", $sformatf("inbound=%0b, outLeftBound=%0b, outRightBound=%0b. Expected: inbound=%0b, outLeftBound=%0b, outRightBound=%0b",
                                    actual.inbound, actual.outLeftBound, actual.outRightBound, expected.inbound, expected.outLeftBound, expected.outRightBound))
    end
  endtask

  virtual function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    if (expected_fifo.used() != 0 || actual_fifo.used() != 0)
      `uvm_error("COUNT", $sformatf("Synchronisation issue in predictor and monitor: %0d transactions expected, %0d transactions actual",
                                    expected_fifo.used(), actual_fifo.used()))
  endfunction

endclass
