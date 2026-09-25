class ball_env extends uvm_env;
  `uvm_component_utils(ball_env)

  ball_agent agent;
  ball_scoreboard scoreboard;
  ball_predictor predictor;
  virtual ball_if vif;

  function new(string name = "ball_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ball_if)::get(this, "", "vif", vif))
      `uvm_fatal("ENV", "Could not get vif")
    agent = ball_agent::type_id::create("agent", this);
    predictor = ball_predictor::type_id::create("predictor", this);
    scoreboard = ball_scoreboard::type_id::create("scoreboard", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.monitor.in_ap.connect(predictor.analysis_export);
    agent.monitor.out_ap.connect(scoreboard.actual_fifo.analysis_export);
    predictor.ap.connect(scoreboard.expected_fifo.analysis_export);
    predictor.ap.connect(agent.coverage_reporter.predictor_export);
  endfunction

endclass
