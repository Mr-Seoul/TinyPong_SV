class bit_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(bit_scoreboard)

  uvm_tlm_analysis_fifo #(bit_transaction) expected_fifo;
  uvm_tlm_analysis_fifo #(bit_rst_transaction) actual_fifo;

  function new(string name = "bit_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    expected_fifo = new("expected_fifo", this);
    actual_fifo   = new("actual_fifo", this);
  endfunction

  virtual task main_phase(uvm_phase phase);
    bit_transaction expected;
    bit_rst_transaction actual;

    forever begin
      expected_fifo.get(expected);
      actual_fifo.get(actual);
      if (actual.bt_trans.out !== expected.out)
        `uvm_error("FAIL", $sformatf("in=%0b, rst=%0b, expected out=%0b, got out=%0b",actual.bt_trans.in, actual.rst_trans.rst, expected.out, actual.bt_trans.out))
    end
  endtask

endclass
