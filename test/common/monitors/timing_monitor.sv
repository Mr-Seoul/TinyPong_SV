class timing_monitor extends uvm_monitor;

  `uvm_component_utils(timing_monitor)

  typedef `VIF_TYPE VIF;
  VIF vif;

  uvm_analysis_port #(timing_transaction) timing_ap;
  uvm_analysis_port #(screen_transaction) screen_ap;

  function new(string name = "timing_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(VIF)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "Could not get vif")
    timing_ap = new("timing_ap", this);
    screen_ap = new("screen_ap", this);
  endfunction

  virtual task main_phase(uvm_phase phase);
    timing_transaction timingTrans;
    screen_transaction screenTrans;
    super.main_phase(phase);
    forever begin
      @(vif.monitor_cb);
      screenTrans = screen_transaction::type_id::create("screenTrans");
      screenTrans.screenX  = vif.monitor_cb.screenX;
      screenTrans.screenY = vif.monitor_cb.screenY;
      screen_ap.write(screenTrans);
      timingTrans = timing_transaction::type_id::create("timingTrans");
      timingTrans.hsync  = vif.monitor_cb.hsync;
      timingTrans.vsync = vif.monitor_cb.vsync;
      timing_ap.write(timingTrans);
    end
  endtask

endclass
