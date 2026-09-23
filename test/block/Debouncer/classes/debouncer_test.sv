class debouncer_test extends uvm_test;

  `uvm_component_utils(debouncer_test)

  debouncer_env env;
  bit_sequence seq;
  reset_sequence rst_seq;
  virtual debouncer_if vif;

  function new(string name = "debouncer_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = debouncer_env::type_id::create("env", this);
    if (!uvm_config_db#(virtual debouncer_if)::get(this, "", "vif", vif))
      `uvm_fatal("TEST", "Did not get vif")
    uvm_config_db#(virtual debouncer_if)::set(this, "debouncer_env.debouncer_agent.*", "vif", vif);
    seq = bit_sequence::type_id::create("bit_sequence");
    seq.randomize();
    rst_seq = reset_sequence::type_id::create("reset_sequence");
    rst_seq.randomize();
  endfunction

  virtual task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    apply_reset();
    phase.drop_objection(this);
  endtask

  virtual task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    fork
      seq.start(env.agent.sequencer);
      rst_seq.start(env.agent.rst_sequencer);
    join
    phase.drop_objection(this);
  endtask

  virtual task apply_reset();
    vif.in <= 0;
    vif.rst <= 1;
    repeat(5) @ (posedge vif.clk);
    vif.rst <= 0;
    repeat(5) @ (negedge vif.clk);
  endtask

endclass
