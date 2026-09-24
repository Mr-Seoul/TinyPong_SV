class game_manager_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(game_manager_scoreboard)

  uvm_tlm_analysis_fifo #(vga_transaction) expected_fifo, actual_fifo;

  function new(string name = "game_manager_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    expected_fifo = new("expected_fifo", this);
    actual_fifo   = new("actual_fifo", this);
  endfunction

  virtual task main_phase(uvm_phase phase);
    vga_transaction expected;
    vga_transaction actual;

    forever begin
      expected_fifo.get(expected);
      actual_fifo.get(actual);
      if (!( actual.r === expected.r && actual.g === expected.g && actual.b === expected.b ))
        `uvm_error("FAIL", $sformatf("r=0x%0d, g=0x%0d, b=0x%0d. Expected: r=0x%0d, g=0x%0d, b=0x%0d",
                                    actual.r, actual.g, actual.b, expected.r, expected.g, expected.b))
    end
  endtask

  virtual function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    if (expected_fifo.used() != 0 || actual_fifo.used() != 0)
      `uvm_error("COUNT", $sformatf("Synchronisation issue in predictor and monitor: %0d expected transactions, %0d actual transactions",
                                    expected_fifo.used(), actual_fifo.used()))
  endfunction

endclass
