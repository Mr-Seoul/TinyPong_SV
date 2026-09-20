class debouncer_agent extends uvm_agent;

  `uvm_component_utils(debouncer_agent)

  bit_sequencer sequencer;
  frame_bit_driver driver;
  bit_monitor monitor;
  bit_coverage coverage_reporter;

  function new(string name = "debouncer_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sequencer = bit_sequencer::type_id::create("bit_sequencer", this);
    driver = frame_bit_driver::type_id::create("frame_bit_driver", this);
    monitor = bit_monitor::type_id::create("bit_monitor", this);
    coverage_reporter = bit_coverage::type_id::create("bit_coverage", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
    driver.ap.connect(coverage_reporter.input_export);
    monitor.ap.connect(coverage_reporter.output_export);
  endfunction

endclass
