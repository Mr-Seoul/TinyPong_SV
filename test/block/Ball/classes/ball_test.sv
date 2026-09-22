class ball_test extends uvm_test;
  `uvm_component_utils(ball_test)

  ball_env env;
  screen_sequence sc_seq;
  paddle_sequence left_paddle_seq;
  paddle_sequence right_paddle_seq;
  bit_sequence bt_seq;
  virtual ball_if vif;

  function new(string name = "ball_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ball_env::type_id::create("env", this);
    if (!uvm_config_db#(virtual ball_if)::get(this, "", "vif", vif))
      `uvm_fatal("TEST", "Did not get vif")
    sc_seq = screen_sequence::type_id::create("screen_sequence");
    sc_seq.randomize();
    left_paddle_seq = paddle_sequence::type_id::create("left_paddle_sequence");
    left_paddle_seq.randomize();
    right_paddle_seq = paddle_sequence::type_id::create("right_paddle_sequence");
    right_paddle_seq.randomize();
    bt_seq = bit_sequence::type_id::create("bit_sequence");
    bt_seq.randomize();
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
      left_paddle_seq.start(env.agent.left_paddle_sequencer);
      right_paddle_seq.start(env.agent.right_paddle_sequencer);
      bt_seq.start(env.agent.bt_sequencer);
    join
    phase.drop_objection(this);
  endtask

  virtual task apply_reset();
    vif.screenDone <= 0;
    vif.screenX <= 0;
    vif.screenY <= 0;
    vif.paddleLeftY <= 240;
    vif.paddleRightY <= 240;
    vif.rst <= 1;
    repeat(5) @ (posedge vif.clk);
    vif.rst <= 0;
    repeat(5) @ (negedge vif.clk);
  endtask

endclass
