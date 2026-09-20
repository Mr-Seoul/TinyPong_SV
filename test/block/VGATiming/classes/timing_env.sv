class timing_env extends uvm_env;

  `uvm_component_utils(timing_env)

  timing_agent agent;
  timing_scoreboard scoreboard;
  timing_predictor predictor;


  function new(string name = "timing_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = timing_agent::type_id::create("agent", this);
    predictor = timing_predictor::type_id::create("predictor", this);
    scoreboard = timing_scoreboard::type_id::create("scoreboard", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.monitor.screen_ap.connect(predictor.analysis_export);
    agent.monitor.timing_ap.connect(scoreboard.actual_fifo.analysis_export);
    predictor.ap.connect(scoreboard.expected_fifo.analysis_export);
  endfunction

endclass
