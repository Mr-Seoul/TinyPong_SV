class paddle_monitor extends uvm_monitor;

  `uvm_component_utils(paddle_monitor)

  uvm_analysis_port #(screen_button_transaction) in_ap;
  uvm_analysis_port #(paddle_transaction) out_ap;
  screen_button_transaction in_trans;
  paddle_transaction out_trans;
  typedef `VIF_TYPE VIF;
  VIF vif;

  function new(string name = "paddle_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(VIF)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "Could not get vif")
    in_ap = new("in_ap", this);
    out_ap = new("out_ap", this);
  endfunction

  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    forever begin
      @(vif.monitor_cb);
      in_trans = screen_button_transaction::type_id::create("in trans");
      in_trans.bt_trans.in = vif.monitor_cb.in;
      in_trans.bt_trans.rst = vif.monitor_cb.rst;
      in_trans.sc_trans.screenX = vif.monitor_cb.screenX;
      in_trans.sc_trans.screenY = vif.monitor_cb.screenY;
      in_trans.sc_trans.screenDone = vif.monitor_cb.screenDone;
      in_ap.write(in_trans);
      
      out_trans = paddle_transaction::type_id::create("out trans");
      out_trans.paddleY = vif.monitor_cb.paddleY;
      out_trans.inbound = vif.monitor_cb.inbound;
      out_trans.diffX = vif.monitor_cb.diffX;
      out_ap.write(out_trans);
    end
  endtask

endclass
