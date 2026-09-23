class bit_monitor extends uvm_monitor;

  `uvm_component_utils(bit_monitor)
  uvm_analysis_port #(bit_rst_transaction) ap;
  typedef `VIF_TYPE VIF;
  VIF vif;

  function new(string name = "bit_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(VIF)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "Could not get vif")
    ap = new("ap", this);
  endfunction

  virtual task main_phase(uvm_phase phase);
    bit_rst_transaction trans;
    super.main_phase(phase);
    forever begin
      @(vif.monitor_cb);
      trans = bit_rst_transaction::type_id::create("trans");
      trans.bt_trans.in  = vif.monitor_cb.in;
      trans.bt_trans.out = vif.monitor_cb.out;
      trans.rst_trans.rst = vif.monitor_cb.rst;
      ap.write(trans);
    end
  endtask

endclass
