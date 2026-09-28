class frame_bit_driver #(int FRAME_LENGTH = 420000, int SIZE = 16) extends uvm_driver #(bit_transaction);

  `uvm_component_param_utils(frame_bit_driver #(FRAME_LENGTH, SIZE))

  uvm_analysis_port #(bit_transaction) ap;
  bit_transaction trans;
  typedef `VIF_TYPE VIF;
  VIF vif;
  

  function new(string name = "frame_bit_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(VIF)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "Could not get vif")
    if (FRAME_LENGTH < (1 << SIZE) + 4)
      `uvm_fatal("DRV", $sformatf("FRAME_LENGTH %0d is shorter than the %0d stable cycles the debouncer needs", FRAME_LENGTH, (1 << SIZE) + 4))
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

  virtual task drive_trans(bit_transaction trans);
    int stable_cycles = (1 << SIZE) + 4; //Cycles needed for debouncer

    repeat (FRAME_LENGTH - stable_cycles) begin
      vif.driver_cb.in  <= 1'($urandom_range(0, 1)); //Simulate mechanical noise
      @(vif.driver_cb);
    end
    repeat (stable_cycles) begin //Stable input that should be picked up
      vif.driver_cb.in  <= trans.in;
      @(vif.driver_cb);
    end
  endtask

endclass
