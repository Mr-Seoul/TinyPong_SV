class synchronizer_predictor extends uvm_subscriber #(bit_rst_transaction);

  `uvm_component_utils(synchronizer_predictor)
  uvm_analysis_port #(bit_transaction) ap;
  
  localparam bit DEFAULT = 0; 
  bit [1:0] stages = {DEFAULT, DEFAULT};

  function new(string name = "synchronizer_predictor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
  endfunction

  virtual function void write(bit_rst_transaction trans);
    bit_transaction expected = bit_transaction::type_id::create("expected");
    //Handle reset
    if (trans.rst_trans.rst) begin
      stages = {DEFAULT, DEFAULT};
    end
    expected.out = stages[1];
    //Update sync pipeline
    if (!trans.rst_trans.rst) begin
      stages = {stages[0], trans.bt_trans.in};
    end

    ap.write(expected);
  endfunction

endclass
