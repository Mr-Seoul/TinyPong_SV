class paddle_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(paddle_scoreboard)

  uvm_tlm_analysis_fifo #(paddle_transaction) expected_fifo;
  uvm_tlm_analysis_fifo #(paddle_transaction) actual_fifo;

  function new(string name = "paddle_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    expected_fifo = new("expected_fifo", this);
    actual_fifo   = new("actual_fifo", this);
  endfunction
  
  virtual task main_phase(uvm_phase phase);
    paddle_transaction expected;
    paddle_transaction actual;

    forever begin
      expected_fifo.get(expected);
      actual_fifo.get(actual);
      if (!( actual.paddleY === expected.paddleY && actual.inbound === expected.inbound && actual.diffX === expected.diffX ))
        `uvm_error("FAIL", $sformatf("paddleY=%0d, inbound=%0b, diffX = %0d. Expected: paddleY=%0d, inbound=%0b, diffX = %0d,",
                                    actual.paddleY, actual.inbound, actual.diffX, expected.paddleY, expected.inbound, expected.diffX))
    end
  endtask

  virtual function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    if (expected_fifo.used() != 0 || actual_fifo.used() != 0)
      `uvm_error("COUNT", $sformatf("Synchronisation issue in predictor and monitor: %0d expected transactions, %0d actual transactions",
                                    expected_fifo.used(), actual_fifo.used()))
  endfunction

endclass