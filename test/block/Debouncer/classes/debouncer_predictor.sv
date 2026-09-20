
class debouncer_predictor extends uvm_subscriber #(bit_transaction);

  `uvm_component_utils(debouncer_predictor)
  uvm_analysis_port #(bit_transaction) ap;
  int count = 0;
  bit out_reg = 0;
  

  function new(string name = "debouncer_predictor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
  endfunction

  virtual function void write(bit_transaction trans);
    bit_transaction expected = bit_transaction::type_id::create("expected");
    int max_count = (1 << 16) - 1;

    if (trans.rst) begin
      count = 0;
      out_reg = 0;
    end

    expected.out = out_reg;

    if (!trans.rst) begin
      if (trans.in == out_reg) begin
        count = 0;
      end else begin
        if (count == max_count) out_reg = trans.in;
        count = (count == max_count) ? 0 : count + 1;
      end
    end

    ap.write(expected);
  endfunction

endclass
