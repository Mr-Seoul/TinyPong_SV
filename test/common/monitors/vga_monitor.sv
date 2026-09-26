class vga_monitor extends uvm_monitor;

  `uvm_component_utils(vga_monitor)

  uvm_analysis_port #(screen_buttons_transaction) in_ap;
  uvm_analysis_port #(vga_transaction) colour_ap;
  uvm_analysis_port #(timing_transaction) timing_ap;
  typedef `VIF_TYPE VIF;
  VIF vif;
  
  int screen_x, screen_y;
  bit x_sync, y_sync, old_hsync = 1, old_vsync = 1;

  function new(string name = "vga_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(VIF)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "Could not get vif")
    in_ap = new("in_ap", this);
    colour_ap = new("colour_ap", this);
    timing_ap = new("timing_ap", this);
  endfunction

  virtual task main_phase(uvm_phase phase);
    screen_buttons_transaction in_trans;
    vga_transaction colour_trans;
    timing_transaction timing_trans;
    bit synced;
    super.main_phase(phase);
    forever begin //The monitor only writes if it is synced to the hsync / vsync signals
      @(vif.monitor_cb);
      synced = x_sync && y_sync;
      //Increment screen indices
      screen_x = (screen_x == 799) ? 0 : screen_x + 1;
      if (screen_x == 0) begin
        screen_y = (screen_y == 524) ? 0 : screen_y + 1;
      end

      if (!x_sync && old_hsync && !vif.monitor_cb.hsync) begin //Sync to hsync
        screen_x = 656;
        x_sync = 1;
      end
      if (x_sync && !y_sync && old_vsync && !vif.monitor_cb.vsync) begin //Sync to vsync
        screen_y = 490;
        y_sync = 1;
      end
      old_hsync = vif.monitor_cb.hsync;
      old_vsync = vif.monitor_cb.vsync;

      if (vif.monitor_cb.rst) begin //handle reset
        x_sync = 0;
        y_sync = 0;
      end
      //Only start monitoring once synced with DUT
      if (x_sync && y_sync) begin
        //First sample inputs
        in_trans = screen_buttons_transaction::type_id::create("in trans");
        in_trans.sc_trans.screenX = 11'(screen_x);
        in_trans.sc_trans.screenY = 11'(screen_y);
        in_trans.sc_trans.screenDone = screen_x == 799 && screen_y == 524;
        in_trans.rst_trans.rst = !synced;
        in_trans.bt1_trans.in = vif.monitor_cb.input1;
        in_trans.bt2_trans.in = vif.monitor_cb.input2;
        in_ap.write(in_trans);

        //then sample colour transactions
        colour_trans = vga_transaction::type_id::create("colour trans");
        colour_trans.r = vif.monitor_cb.outR;
        colour_trans.g = vif.monitor_cb.outG;
        colour_trans.b = vif.monitor_cb.outB;
        colour_ap.write(colour_trans);

        //Then sample the timing output
        timing_trans = timing_transaction::type_id::create("timing trans");
        timing_trans.hsync = vif.monitor_cb.hsync;
        timing_trans.vsync = vif.monitor_cb.vsync;
        timing_ap.write(timing_trans);
      end
    end
  endtask

endclass
