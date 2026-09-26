class vga_test extends uvm_test;
  `uvm_component_utils(vga_test)

  vga_env env;
  reset_sequence rst_seq;
  bit_sequence bt1_seq, bt2_seq;
  virtual vga_if vif, bt1_vif, bt2_vif;
  int frames = 10;

  function new(string name = "vga_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = vga_env::type_id::create("env", this);
    if (!uvm_config_db#(virtual vga_if)::get(this, "", "vif", vif))
      `uvm_fatal("TEST", "Did not get vif")
    if (!uvm_config_db#(virtual vga_if)::get(this, "", "bt1_vif", bt1_vif))
      `uvm_fatal("TEST", "Did not get bt1_vif")
    if (!uvm_config_db#(virtual vga_if)::get(this, "", "bt2_vif", bt2_vif))
      `uvm_fatal("TEST", "Did not get bt2_vif")
    rst_seq = reset_sequence::type_id::create("reset_sequence");
    rst_seq.randomize();
    bt1_seq = bit_sequence::type_id::create("bt1_sequence");
    bt1_seq.num = frames;
    bt2_seq = bit_sequence::type_id::create("bt2_sequence");
    bt2_seq.num = frames;
  endfunction

  virtual task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    apply_reset();
    phase.drop_objection(this);
  endtask

  virtual task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    fork
      rst_seq.start(env.agent.rst_sequencer);
    join_none
    fork
      bt1_seq.start(env.agent.bt1_sequencer);
      bt2_seq.start(env.agent.bt2_sequencer);
    join
    phase.drop_objection(this);
  endtask

  virtual task apply_reset();
    bt1_vif.in <= 0;
    bt2_vif.in <= 0;
    vif.rst <= 1;
    repeat(5) @ (posedge vif.clk);
    vif.rst <= 0;
    repeat(5) @ (negedge vif.clk);
  endtask

endclass
