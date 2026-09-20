class timing_test extends uvm_test;

  `uvm_component_utils(timing_test)

  timing_env env;
  screen_sequence seq;
  virtual timing_if	vif;

  function new(string name = "timing_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = timing_env::type_id::create("env", this);
    if (!uvm_config_db#(virtual timing_if)::get(this, "", "vif", vif))
      `uvm_fatal("TEST", "Did not get vif")
    uvm_config_db#(virtual timing_if)::set(this, "timing_env.timing_agent.*", "vif", vif);
    seq = screen_sequence::type_id::create("screen_sequence");
    seq.randomize();
  endfunction

  virtual task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask

endclass