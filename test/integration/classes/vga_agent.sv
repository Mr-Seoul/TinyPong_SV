class vga_agent extends uvm_agent;
  `uvm_component_utils(vga_agent)

  reset_sequencer rst_sequencer;
  bit_sequencer bt1_sequencer, bt2_sequencer;
  reset_driver #(200000, 1000000) rst_driver;
  vga_frame_driver bt1_driver, bt2_driver;
  vga_monitor monitor;
  vga_coverage coverage_reporter;

  function new(string name = "vga_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //create drivers / sequencers
    rst_sequencer = reset_sequencer::type_id::create("reset_sequencer", this);
    rst_driver = reset_driver #(200000, 1000000)::type_id::create("reset_driver", this);
    bt1_sequencer = bit_sequencer::type_id::create("bt1_sequencer", this);
    bt1_driver = vga_frame_driver::type_id::create("bt1_driver", this);
    bt2_sequencer = bit_sequencer::type_id::create("bt2_sequencer", this);
    bt2_driver = vga_frame_driver::type_id::create("bt2_driver", this);

    //Create monitor and reporter
    monitor = vga_monitor::type_id::create("vga_monitor", this);
    coverage_reporter = vga_coverage::type_id::create("vga_coverage", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //Connect drivers
    rst_driver.seq_item_port.connect(rst_sequencer.seq_item_export);
    bt1_driver.seq_item_port.connect(bt1_sequencer.seq_item_export);
    bt2_driver.seq_item_port.connect(bt2_sequencer.seq_item_export);

    //Connect monitor
    monitor.colour_ap.connect(coverage_reporter.colour_export);
    monitor.timing_ap.connect(coverage_reporter.timing_export);
  endfunction

endclass
