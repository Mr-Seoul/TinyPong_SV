class timing_predictor extends uvm_subscriber #(screen_transaction);

  `uvm_component_utils(timing_predictor)
  uvm_analysis_port #(timing_transaction) ap;

  function new(string name = "timing_predictor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
  endfunction

  virtual function void write(screen_transaction trans);
    timing_transaction expected = timing_transaction::type_id::create("expected");

    expected.hsync = !(trans.screenX > 655  && trans.screenX < 752);
    expected.vsync = !(trans.screenY > 489  && trans.screenY < 492);

    ap.write(expected);
  endfunction

endclass
