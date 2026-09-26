class vga_frame_driver extends uvm_driver #(bit_transaction);

  `uvm_component_utils(vga_frame_driver)

  uvm_analysis_port #(bit_transaction) ap;
  bit_transaction trans;
  typedef `VIF_TYPE VIF;
  VIF vif, screen_vif;
  int screen_x, screen_y, num = 0;
  bit x_sync, y_sync, prev_hsync = 1, prev_vsync = 1;

  function new(string name = "vga_frame_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(VIF)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "Could not get vif")
    if (!uvm_config_db#(VIF)::get(this, "", "screen_vif", screen_vif))
      `uvm_fatal("DRV", "Could not get screen_vif")
    ap = new("ap", this);
  endfunction

  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    forever begin
      seq_item_port.get_next_item(trans);
      ap.write(trans);
      drive_trans(trans);
      seq_item_port.item_done();
      num++;
      `uvm_info("DRV",$sformatf("Item done: 0x%0d",num), UVM_NONE)
    end
  endtask

  virtual task drive_trans(bit_transaction trans);
    int position, stable_start = 420000 - (1 << 16) - 8;
    do begin 
      @(screen_vif.driver_cb);
      //Increment screen indices
      screen_x = (screen_x == 799) ? 0 : screen_x + 1;
      if (screen_x == 0) begin
        screen_y = (screen_y == 524) ? 0 : screen_y + 1;
      end 

      //Honing for hsync / vsync
      if (!x_sync && prev_hsync && !screen_vif.driver_cb.hsync) begin
        screen_x = 656;
        x_sync = 1;
      end
      if (x_sync && !y_sync && prev_vsync && !screen_vif.driver_cb.vsync) begin
        screen_y = 490;
        y_sync = 1;
      end
      prev_hsync = screen_vif.driver_cb.hsync;
      prev_vsync = screen_vif.driver_cb.vsync;

      if (screen_vif.driver_cb.rst) begin 
        //when reset, the driver is now unsynchronized. 
        //In this driver I want to follow the hsync and vsync signals since they need to be integrated correctly
        //so no assumptions are made for the screenX and screenY
        x_sync = 0;
        y_sync = 0;
      end

      position = screen_y * 800 + screen_x;
      if (!(x_sync && y_sync)) begin //No input until synced with hsync / vsync
        vif.driver_cb.in <= 1'b0;
      end else if (position < stable_start) begin //Add noise for debouncer
        vif.driver_cb.in <= 1'($urandom_range(0, 1));
      end else begin //Stable input until end of frame
        vif.driver_cb.in <= trans.in;
      end
    end while (!(x_sync && y_sync && position == 419999)); //Continue until end of frame, so next transaction starts synchronized
  endtask

endclass
