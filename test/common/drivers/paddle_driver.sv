class paddle_driver extends uvm_driver #(paddle_transaction);

  `uvm_component_utils(paddle_driver)

  uvm_analysis_port #(paddle_transaction) ap;
  paddle_transaction trans;
  bit SIDE = 0;
  typedef `VIF_TYPE VIF;
  VIF vif;

  function new(string name = "paddle_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(VIF)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "Could not get vif")
    if (!uvm_config_db#(bit)::get(this, "", "SIDE", SIDE))
      `uvm_fatal("DRV", "Could not get SIDE")
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

  virtual task drive_trans(paddle_transaction trans);
    if (SIDE) vif.driver_cb.paddleRightY <= trans.paddleY;
    else vif.driver_cb.paddleLeftY <= trans.paddleY;
    @(vif.driver_cb);
  endtask

endclass
