class ball_agent extends uvm_agent;
  `uvm_component_utils(ball_agent)

  screen_sequencer sc_sequencer;
  paddle_sequencer left_paddle_sequencer;
  paddle_sequencer right_paddle_sequencer;
  screen_driver sc_driver;
  paddle_driver left_paddle_driver;
  paddle_driver right_paddle_driver;
  ball_monitor monitor;
  ball_coverage coverage_reporter;
  bit_sequencer bt_sequencer;
  single_bit_driver bt_driver;
  reset_sequencer rst_sequencer;
  reset_driver #(1, 10) rst_driver;

  function new(string name = "ball_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(bit)::set(this, "left_paddle_driver", "SIDE", 0);
    uvm_config_db#(bit)::set(this, "right_paddle_driver", "SIDE", 1);
    
    sc_sequencer = screen_sequencer::type_id::create("screen_sequencer", this);
    sc_driver = screen_driver::type_id::create("screen_driver", this);
    left_paddle_sequencer = paddle_sequencer::type_id::create("left_paddle_sequencer", this);
    left_paddle_driver = paddle_driver::type_id::create("left_paddle_driver", this);
    right_paddle_sequencer = paddle_sequencer::type_id::create("right_paddle_sequencer", this);
    right_paddle_driver = paddle_driver::type_id::create("right_paddle_driver", this);
    bt_sequencer = bit_sequencer::type_id::create("bit_sequencer", this);
    bt_driver = single_bit_driver::type_id::create("single_bit_driver", this);
    rst_sequencer = reset_sequencer::type_id::create("reset_sequencer", this);
    rst_driver = reset_driver #(1, 10)::type_id::create("reset_driver", this);
    monitor = ball_monitor::type_id::create("ball_monitor", this);
    coverage_reporter = ball_coverage::type_id::create("ball_coverage", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sc_driver.seq_item_port.connect(sc_sequencer.seq_item_export);
    left_paddle_driver.seq_item_port.connect(left_paddle_sequencer.seq_item_export);
    right_paddle_driver.seq_item_port.connect(right_paddle_sequencer.seq_item_export);
    bt_driver.seq_item_port.connect(bt_sequencer.seq_item_export);
    rst_driver.seq_item_port.connect(rst_sequencer.seq_item_export);
    monitor.in_ap.connect(coverage_reporter.in_export);
    monitor.out_ap.connect(coverage_reporter.output_export);
  endfunction

endclass
