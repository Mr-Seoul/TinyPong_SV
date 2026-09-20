class timing_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(timing_scoreboard)

  uvm_tlm_analysis_fifo #(timing_transaction) expected_fifo;
  uvm_tlm_analysis_fifo #(timing_transaction) actual_fifo;

  timing_transaction expected;
  timing_transaction actual;

  function new(string name = "timing_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    expected_fifo = new("expected_fifo", this);
    actual_fifo   = new("actual_fifo", this);
  endfunction

  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);

    forever begin
      expected_fifo.get(expected);
      actual_fifo.get(actual);
      if (actual.hsync != expected.hsync || actual.vsync != expected.vsync)
        `uvm_error("FAIL", $sformatf("hsync=%0b, vsync=%0b, expected hsync=%0b, expected vsync=%0b",actual.hsync, actual.vsync, expected.hsync, expected.vsync))
    end
  endtask

endclass
