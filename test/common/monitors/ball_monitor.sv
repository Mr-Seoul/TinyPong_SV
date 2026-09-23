class ball_monitor extends uvm_monitor;

  `uvm_component_utils(ball_monitor)

  uvm_analysis_port #(screen_button_paddle_transaction) in_ap;
  uvm_analysis_port #(ball_transaction) out_ap;
  screen_button_paddle_transaction in_trans;
  ball_transaction out_trans;
  typedef `VIF_TYPE VIF;
  VIF vif;

  function new(string name = "ball_monitor", uvm_component parent = null);
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
      in_trans = screen_button_paddle_transaction::type_id::create("in trans");
      in_trans.sc_trans.screenX = vif.monitor_cb.screenX;
      in_trans.sc_trans.screenY = vif.monitor_cb.screenY;
      in_trans.sc_trans.screenDone = vif.monitor_cb.screenDone;
      in_trans.pd_l_trans.paddleY = vif.monitor_cb.paddleLeftY;
      in_trans.pd_r_trans.paddleY = vif.monitor_cb.paddleRightY;
      in_trans.rst_trans.rst = vif.monitor_cb.rst;
      in_ap.write(in_trans);

      out_trans = ball_transaction::type_id::create("out trans");
      out_trans.inbound = vif.monitor_cb.inbound;
      out_trans.outLeftBound = vif.monitor_cb.outLeftBound;
      out_trans.outRightBound = vif.monitor_cb.outRightBound;
      out_ap.write(out_trans);
    end
  endtask

endclass
