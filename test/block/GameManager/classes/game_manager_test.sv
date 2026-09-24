class game_manager_test extends uvm_test;
  `uvm_component_utils(game_manager_test)

  game_manager_env env;
  screen_sequence sc_seq;
  reset_sequence rst_seq;
  bit_sequence bt1_seq, bt2_seq;
  virtual game_manager_if vif, bt1_vif, bt2_vif;

  function new(string name = "game_manager_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = game_manager_env::type_id::create("env", this);
    if (!uvm_config_db#(virtual game_manager_if)::get(this, "", "vif", vif))
      `uvm_fatal("TEST", "Did not get vif")
    if (!uvm_config_db#(virtual game_manager_if)::get(this, "", "bt1_vif", bt1_vif))
      `uvm_fatal("TEST", "Did not get bt1_vif")
    if (!uvm_config_db#(virtual game_manager_if)::get(this, "", "bt2_vif", bt2_vif))
      `uvm_fatal("TEST", "Did not get bt2_vif")
    sc_seq = screen_sequence::type_id::create("screen_sequence");
    sc_seq.randomize();
    rst_seq = reset_sequence::type_id::create("reset_sequence");
    rst_seq.randomize();
    bt1_seq = bit_sequence::type_id::create("bt1_sequence");
    bt1_seq.randomize();
    bt2_seq = bit_sequence::type_id::create("bt2_sequence");
    bt2_seq.randomize();
  endfunction

  virtual task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    apply_reset();
    phase.drop_objection(this);
  endtask

  virtual task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    fork
      sc_seq.start(env.agent.sc_sequencer);
      rst_seq.start(env.agent.rst_sequencer);
      bt1_seq.start(env.agent.bt1_sequencer);
      bt2_seq.start(env.agent.bt2_sequencer);
    join
    phase.drop_objection(this);
  endtask

  virtual task apply_reset();
    bt1_vif.in <= 0;
    bt2_vif.in <= 0;
    vif.screenDone <= 0;
    vif.screenX <= 0;
    vif.screenY <= 0;
    vif.rst <= 1;
    repeat(5) @ (posedge vif.clk);
    vif.rst <= 0;
    repeat(5) @ (negedge vif.clk);
  endtask

endclass
