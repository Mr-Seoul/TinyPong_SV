class timing_agent extends uvm_agent;

  `uvm_component_utils(timing_agent)

  screen_sequencer sequencer;
  screen_driver driver;
  timing_monitor monitor;
  timing_coverage coverage_reporter;

  function new(string name = "timing_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sequencer = screen_sequencer::type_id::create("screen_sequencer", this);
    driver = screen_driver::type_id::create("screen_driver", this);
    monitor = timing_monitor::type_id::create("timing_monitor", this);
    coverage_reporter = timing_coverage::type_id::create("timing_coverage", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
    driver.ap.connect(coverage_reporter.input_export);
    monitor.timing_ap.connect(coverage_reporter.output_export);
  endfunction

endclass
