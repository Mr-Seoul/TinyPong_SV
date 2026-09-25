class reset_driver #(int MIN = 1, int MAX = 10) extends uvm_driver #(reset_transaction);

  `uvm_component_param_utils(reset_driver #(MIN, MAX))

  uvm_analysis_port #(reset_transaction) ap;
  reset_transaction trans;
  typedef `VIF_TYPE VIF;
  VIF vif;

  function new(string name = "reset_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(VIF)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "Could not get vif")
    ap = new("ap", this);
  endfunction

  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    forever begin
      seq_item_port.get_next_item(trans);
      ap.write(trans);
      drive_trans(trans);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_trans(reset_transaction trans);
    vif.driver_cb.rst <= trans.rst;
    @(vif.driver_cb);
    vif.driver_cb.rst <= 1'b0;
    repeat ($urandom_range(MIN, MAX)) @(vif.driver_cb); //Wait a while so resets are infrequent
  endtask

endclass
