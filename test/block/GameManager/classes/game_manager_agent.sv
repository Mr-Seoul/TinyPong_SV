class game_manager_agent extends uvm_agent;
  `uvm_component_utils(game_manager_agent)

  screen_sequencer sc_sequencer;
  reset_sequencer rst_sequencer;
  bit_sequencer bt1_sequencer, bt2_sequencer;
  screen_driver sc_driver;
  reset_driver #(1, 10) rst_driver;
  single_bit_driver bt1_driver, bt2_driver;
  game_manager_monitor monitor;
  game_manager_coverage coverage_reporter;

  function new(string name = "game_manager_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sc_sequencer = screen_sequencer::type_id::create("screen_sequencer", this);
    sc_driver = screen_driver::type_id::create("screen_driver", this);
    rst_sequencer = reset_sequencer::type_id::create("reset_sequencer", this);
    rst_driver = reset_driver #(1, 10)::type_id::create("reset_driver", this);
    bt1_sequencer = bit_sequencer::type_id::create("bt1_sequencer", this);
    bt1_driver = single_bit_driver::type_id::create("bt1_driver", this);
    bt2_sequencer = bit_sequencer::type_id::create("bt2_sequencer", this);
    bt2_driver = single_bit_driver::type_id::create("bt2_driver", this);
    monitor = game_manager_monitor::type_id::create("game_manager_monitor", this);
    coverage_reporter = game_manager_coverage::type_id::create("game_manager_coverage", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sc_driver.seq_item_port.connect(sc_sequencer.seq_item_export);
    rst_driver.seq_item_port.connect(rst_sequencer.seq_item_export);
    bt1_driver.seq_item_port.connect(bt1_sequencer.seq_item_export);
    bt2_driver.seq_item_port.connect(bt2_sequencer.seq_item_export);
    monitor.out_ap.connect(coverage_reporter.output_export);
  endfunction

endclass
