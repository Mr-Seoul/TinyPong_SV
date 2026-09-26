class vga_env extends uvm_env;
  `uvm_component_utils(vga_env)

  vga_agent agent;
  synchronizer_predictor bt1_synchronizer, bt2_synchronizer;
  debouncer_predictor bt1_debouncer, bt2_debouncer;
  paddle_predictor left_paddle_predictor, right_paddle_predictor;
  ball_predictor pong_predictor;
  graphics_manager_predictor graphics_predictor;
  timing_predictor sync_predictor;
  game_manager_scoreboard colour_scoreboard;
  timing_scoreboard sync_scoreboard;
  uvm_tlm_analysis_fifo #(screen_buttons_transaction) screen_fifo;
  uvm_tlm_analysis_fifo #(bit_transaction) bt1_sync_fifo, bt2_sync_fifo, bt1_debounce_fifo, bt2_debounce_fifo;
  uvm_tlm_analysis_fifo #(paddle_transaction) left_paddle_fifo, right_paddle_fifo;
  uvm_tlm_analysis_fifo #(ball_transaction) ball_fifo;
  uvm_analysis_port #(game_transaction) game_ap;
  uvm_analysis_port #(screen_buttons_transaction) cov_ap;

  function new(string name = "vga_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(bit)::set(this, "left_paddle_predictor", "SIDE", 0);
    uvm_config_db#(bit)::set(this, "right_paddle_predictor", "SIDE", 1);

    //Init everything
    agent = vga_agent::type_id::create("agent", this);
    bt1_synchronizer = synchronizer_predictor::type_id::create("bt1_synchronizer", this);
    bt2_synchronizer = synchronizer_predictor::type_id::create("bt2_synchronizer", this);
    bt1_debouncer = debouncer_predictor::type_id::create("bt1_debouncer", this);
    bt2_debouncer = debouncer_predictor::type_id::create("bt2_debouncer", this);

    //Predictor init
    left_paddle_predictor = paddle_predictor::type_id::create("left_paddle_predictor", this);
    right_paddle_predictor = paddle_predictor::type_id::create("right_paddle_predictor", this);
    pong_predictor = ball_predictor::type_id::create("pong_predictor", this);
    graphics_predictor = graphics_manager_predictor::type_id::create("graphics_predictor", this);
    sync_predictor = timing_predictor::type_id::create("sync_predictor", this);
    colour_scoreboard = game_manager_scoreboard::type_id::create("colour_scoreboard", this);
    sync_scoreboard = timing_scoreboard::type_id::create("sync_scoreboard", this);

    //init fifos
    screen_fifo = new("screen_fifo", this);
    bt1_sync_fifo = new("bt1_sync_fifo", this);
    bt2_sync_fifo = new("bt2_sync_fifo", this);
    bt1_debounce_fifo = new("bt1_debounce_fifo", this);
    bt2_debounce_fifo = new("bt2_debounce_fifo", this);
    left_paddle_fifo = new("left_paddle_fifo", this);
    right_paddle_fifo = new("right_paddle_fifo", this);
    ball_fifo = new("ball_fifo", this);

    //init analysis ports
    game_ap = new("game_ap", this);
    cov_ap = new("cov_ap", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //monitor inits
    agent.monitor.in_ap.connect(screen_fifo.analysis_export);
    agent.monitor.colour_ap.connect(colour_scoreboard.actual_fifo.analysis_export);
    agent.monitor.timing_ap.connect(sync_scoreboard.actual_fifo.analysis_export);

    //button inits
    bt1_synchronizer.ap.connect(bt1_sync_fifo.analysis_export);
    bt2_synchronizer.ap.connect(bt2_sync_fifo.analysis_export);
    bt1_debouncer.ap.connect(bt1_debounce_fifo.analysis_export);
    bt2_debouncer.ap.connect(bt2_debounce_fifo.analysis_export);

    //Predictor connections
    left_paddle_predictor.ap.connect(left_paddle_fifo.analysis_export);
    right_paddle_predictor.ap.connect(right_paddle_fifo.analysis_export);
    pong_predictor.ap.connect(ball_fifo.analysis_export);
    graphics_predictor.ap.connect(colour_scoreboard.expected_fifo.analysis_export);
    sync_predictor.ap.connect(sync_scoreboard.expected_fifo.analysis_export);

    //analysis port connection
    game_ap.connect(graphics_predictor.analysis_export);
    cov_ap.connect(agent.coverage_reporter.input_export);
  endfunction

  virtual task main_phase(uvm_phase phase);
    screen_buttons_transaction screen_trans;
    screen_button_paddle_transaction ball_in_trans;
    game_transaction game_trans;
    bit_transaction bt1_synced, bt2_synced, bt1_debounced, bt2_debounced;
    bit_transaction bt1_pixel = bit_transaction::type_id::create("bt1 pixel");
    bit_transaction bt2_pixel = bit_transaction::type_id::create("bt2 pixel");
    bit game_over = 0;
    bit rst, reset_all, frame_rst = 0;

    forever begin
      //wait for screen index
      screen_fifo.get(screen_trans);

      //get reset info
      rst = screen_trans.rst_trans.rst;
      reset_all = rst || game_over;

      //Get/Set input information
      bt1_synchronizer.write(in_bit_rst_trans(screen_trans.bt1_trans, rst));
      bt2_synchronizer.write(in_bit_rst_trans(screen_trans.bt2_trans, rst));
      bt1_sync_fifo.get(bt1_synced);
      bt2_sync_fifo.get(bt2_synced);
      bt1_debouncer.write(in_bit_rst_trans(in_bit_trans(bt1_synced), rst));
      bt2_debouncer.write(in_bit_rst_trans(in_bit_trans(bt2_synced), rst));
      bt1_debounce_fifo.get(bt1_debounced);
      bt2_debounce_fifo.get(bt2_debounced);

      //Only sample input when drivers are driving a stable signal, not noise
      frame_rst = frame_rst || rst;
      if (screen_trans.sc_trans.screenDone) begin
        cov_ap.write(in_frame_trans(bt1_debounced, bt2_debounced, frame_rst));
        frame_rst = 0;
      end

      //Start gathering game Info
      game_trans = game_transaction::type_id::create("game");
      game_trans.sb_trans = screen_trans;
      game_trans.game_over = game_over;
      
      //Get paddle Info
      left_paddle_predictor.write(in_paddle_trans(screen_trans, bt1_pixel, reset_all));
      right_paddle_predictor.write(in_paddle_trans(screen_trans, bt2_pixel, reset_all));
      left_paddle_fifo.get(game_trans.pd_l_trans);
      right_paddle_fifo.get(game_trans.pd_r_trans);

      //Update ball info
      ball_in_trans = screen_button_paddle_transaction::type_id::create("ball in");
      ball_in_trans.sc_trans = screen_trans.sc_trans;
      ball_in_trans.pd_l_trans = game_trans.pd_l_trans;
      ball_in_trans.pd_r_trans = game_trans.pd_r_trans;
      ball_in_trans.rst_trans.rst = reset_all;
      pong_predictor.write(ball_in_trans);
      ball_fifo.get(game_trans.bl_trans);

      //Update game_over and button inputs
      game_over = !rst && (game_trans.bl_trans.outLeftBound || game_trans.bl_trans.outRightBound);
      bt1_pixel = in_bit_trans(bt1_debounced);
      bt2_pixel = in_bit_trans(bt2_debounced);

      //Write to analysis ports
      game_ap.write(game_trans);
      sync_predictor.write(screen_trans.sc_trans);
    end
  endtask

  //Combines button and rst into transactions
  function bit_rst_transaction in_bit_rst_trans(bit_transaction button_trans, bit rst);
    bit_rst_transaction trans = bit_rst_transaction::type_id::create("bit rst transaction");
    trans.bt_trans = button_trans;
    trans.rst_trans.rst = rst;
    return trans;
  endfunction

  //Combines debounced buttons and rst into a frame transaction
  function screen_buttons_transaction in_frame_trans(bit_transaction bt1_trans, bit_transaction bt2_trans, bit rst);
    screen_buttons_transaction trans = screen_buttons_transaction::type_id::create("frame transaction");
    trans.bt1_trans = bt1_trans;
    trans.bt2_trans = bt2_trans;
    trans.rst_trans.rst = rst;
    return trans;
  endfunction

  //Creates bit transaction
  function bit_transaction in_bit_trans(bit_transaction in_trans);
    bit_transaction trans = bit_transaction::type_id::create("bit transaction");
    trans.in = in_trans.out;
    return trans;
  endfunction

  //Combines transactions into input for paddle 
  function screen_button_transaction in_paddle_trans(screen_buttons_transaction screen_trans, bit_transaction button_trans, bit rst);
    screen_button_transaction trans = screen_button_transaction::type_id::create("screen button transaction");
    trans.sc_trans = screen_trans.sc_trans;
    trans.bt_trans = button_trans;
    trans.rst_trans.rst = rst;
    return trans;
  endfunction

endclass
