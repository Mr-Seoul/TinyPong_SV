class synchronizer_env extends uvm_env;

  `uvm_component_utils(synchronizer_env)

  synchronizer_agent agent;
  synchronizer_predictor predictor;
  bit_scoreboard scoreboard;

  function new(string name = "synchronizer_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = synchronizer_agent::type_id::create("agent", this);
    predictor = synchronizer_predictor::type_id::create("predictor", this);
    scoreboard = bit_scoreboard::type_id::create("scoreboard", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.monitor.ap.connect(predictor.analysis_export);
    agent.monitor.ap.connect(scoreboard.actual_fifo.analysis_export);
    predictor.ap.connect(scoreboard.expected_fifo.analysis_export);
  endfunction

endclass
