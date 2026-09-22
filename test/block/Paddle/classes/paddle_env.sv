class paddle_env extends uvm_env;
  `uvm_component_utils(paddle_env)

  paddle_agent agent;
  paddle_scoreboard scoreboard;
  paddle_predictor predictor;
  virtual paddle_if vif;

  function new(string name = "paddle_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual paddle_if)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "Could not get vif")
    agent = paddle_agent::type_id::create("agent", this);
    predictor = paddle_predictor::type_id::create("predictor", this);
    scoreboard = paddle_scoreboard::type_id::create("scoreboard", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.monitor.in_ap.connect(predictor.analysis_export);
    agent.monitor.out_ap.connect(scoreboard.actual_fifo.analysis_export);
    predictor.ap.connect(scoreboard.expected_fifo.analysis_export);
  endfunction

endclass
