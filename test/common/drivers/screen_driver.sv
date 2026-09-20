class screen_driver extends uvm_driver #(screen_transaction);

  `uvm_component_utils(screen_driver)

  uvm_analysis_port #(screen_transaction) ap;
  screen_transaction trans;
  typedef `VIF_TYPE VIF;
  VIF vif;

  function new(string name = "screen_driver", uvm_component parent = null);
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

  virtual task drive_trans(screen_transaction trans);
    vif.driver_cb.screenX <= trans.screenX;
    vif.driver_cb.screenY <= trans.screenY;
    vif.driver_cb.screenDone <= trans.screenDone;
    @(vif.driver_cb);
  endtask

endclass
