class paddle_agent extends uvm_agent;
  `uvm_component_utils(paddle_agent)

  screen_sequencer sc_sequencer;
  bit_sequencer bt_sequencer;
  screen_driver sc_driver;
  single_bit_driver bt_driver;
  reset_sequencer rst_sequencer;
  reset_driver #(1, 10) rst_driver;
  paddle_monitor monitor;
  paddle_coverage coverage_reporter;

  function new(string name = "paddle_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sc_sequencer = screen_sequencer::type_id::create("screen_sequencer", this);
    sc_driver = screen_driver::type_id::create("screen_driver", this);
    bt_sequencer = bit_sequencer::type_id::create("bit_sequencer", this);
    bt_driver = single_bit_driver::type_id::create("bit_driver", this);
    rst_sequencer = reset_sequencer::type_id::create("reset_sequencer", this);
    rst_driver = reset_driver #(1, 10)::type_id::create("reset_driver", this);
    monitor = paddle_monitor::type_id::create("paddle_monitor", this);
    coverage_reporter = paddle_coverage::type_id::create("paddle_coverage", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sc_driver.seq_item_port.connect(sc_sequencer.seq_item_export);
    bt_driver.seq_item_port.connect(bt_sequencer.seq_item_export);
    rst_driver.seq_item_port.connect(rst_sequencer.seq_item_export);
    monitor.in_ap.connect(coverage_reporter.in_export);
    monitor.out_ap.connect(coverage_reporter.output_export);
  endfunction

endclass
