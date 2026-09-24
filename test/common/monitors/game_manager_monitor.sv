class game_manager_monitor extends uvm_monitor;

  `uvm_component_utils(game_manager_monitor)

  uvm_analysis_port #(screen_buttons_transaction) in_ap;
  uvm_analysis_port #(vga_transaction) out_ap;
  screen_buttons_transaction in_trans;
  vga_transaction out_trans;
  typedef `VIF_TYPE VIF;
  VIF vif;

  function new(string name = "game_manager_monitor", uvm_component parent = null);
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
      in_trans = screen_buttons_transaction::type_id::create("in trans");
      in_trans.sc_trans.screenX = vif.monitor_cb.screenX;
      in_trans.sc_trans.screenY = vif.monitor_cb.screenY;
      in_trans.sc_trans.screenDone = vif.monitor_cb.screenDone;
      in_trans.rst_trans.rst = vif.monitor_cb.rst;
      in_trans.bt1_trans.in = vif.monitor_cb.input1;
      in_trans.bt2_trans.in = vif.monitor_cb.input2;
      in_ap.write(in_trans);

      out_trans = vga_transaction::type_id::create("out trans");
      out_trans.r = vif.monitor_cb.outR;
      out_trans.g = vif.monitor_cb.outG;
      out_trans.b = vif.monitor_cb.outB;
      out_ap.write(out_trans);
    end
  endtask

endclass
