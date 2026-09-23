class paddle_test extends uvm_test;
  `uvm_component_utils(paddle_test)

  paddle_env env;
  screen_sequence sc_seq;
  bit_sequence bt_seq;
  reset_sequence rst_seq;
  virtual paddle_if vif;

  function new(string name = "paddle_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = paddle_env::type_id::create("env", this);
    if (!uvm_config_db#(virtual paddle_if)::get(this, "", "vif", vif))
      `uvm_fatal("TEST", "Did not get vif")
    bt_seq = bit_sequence::type_id::create("bit_sequence");
    bt_seq.randomize();
    rst_seq = reset_sequence::type_id::create("reset_sequence");
    rst_seq.randomize();
    sc_seq = screen_sequence::type_id::create("screen_sequence");
    sc_seq.randomize();
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
      bt_seq.start(env.agent.bt_sequencer);
      rst_seq.start(env.agent.rst_sequencer);
    join
    phase.drop_objection(this);
  endtask

  virtual task apply_reset();
    vif.in <= 0;
    vif.screenDone <= 0;
    vif.screenX <= 0;
    vif.screenY <= 0;
    vif.rst <= 1;
    repeat(5) @ (posedge vif.clk);
    vif.rst <= 0;
    repeat(5) @ (negedge vif.clk);
  endtask

endclass
