class game_manager_env extends uvm_env;
  `uvm_component_utils(game_manager_env)

  game_manager_agent agent;
  game_manager_scoreboard scoreboard;
  game_manager_predictor game_predictor;
  paddle_predictor left_paddle_predictor, right_paddle_predictor;
  ball_predictor pong_predictor;
  uvm_tlm_analysis_fifo #(screen_buttons_transaction) screen_fifo;
  uvm_tlm_analysis_fifo #(paddle_transaction) left_paddle_fifo, right_paddle_fifo;
  uvm_tlm_analysis_fifo #(ball_transaction) ball_fifo;
  uvm_analysis_port #(game_transaction) game_ap;

  function new(string name = "game_manager_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(bit)::set(this, "left_paddle_predictor", "SIDE", 0);
    uvm_config_db#(bit)::set(this, "right_paddle_predictor", "SIDE", 1);

    agent = game_manager_agent::type_id::create("agent", this);
    left_paddle_predictor = paddle_predictor::type_id::create("left_paddle_predictor", this);
    right_paddle_predictor = paddle_predictor::type_id::create("right_paddle_predictor", this);
    pong_predictor = ball_predictor::type_id::create("pong_predictor", this);
    game_predictor = game_manager_predictor::type_id::create("game_predictor", this);
    scoreboard = game_manager_scoreboard::type_id::create("scoreboard", this);
    screen_fifo = new("screen_fifo", this);
    left_paddle_fifo = new("left_paddle_fifo", this);
    right_paddle_fifo = new("right_paddle_fifo", this);
    ball_fifo = new("ball_fifo", this);
    game_ap = new("game_ap", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.monitor.in_ap.connect(screen_fifo.analysis_export);
    agent.monitor.out_ap.connect(scoreboard.actual_fifo.analysis_export);
    left_paddle_predictor.ap.connect(left_paddle_fifo.analysis_export);
    right_paddle_predictor.ap.connect(right_paddle_fifo.analysis_export);
    pong_predictor.ap.connect(ball_fifo.analysis_export);
    game_ap.connect(game_predictor.analysis_export);
    game_ap.connect(agent.coverage_reporter.in_export);
    game_predictor.ap.connect(scoreboard.expected_fifo.analysis_export);
  endfunction

  virtual task main_phase(uvm_phase phase);
    screen_buttons_transaction screen_trans;
    screen_button_paddle_transaction ball_in_trans;
    game_transaction game_trans;
    bit game_over = 0;
    bit reset_all;

    forever begin
      screen_fifo.get(screen_trans);
      reset_all = screen_trans.rst_trans.rst || game_over;
      game_trans = game_transaction::type_id::create("game");
      game_trans.sb_trans = screen_trans;
      game_trans.game_over = game_over;

      left_paddle_predictor.write(paddle_in_trans(screen_trans, screen_trans.bt1_trans, reset_all));
      right_paddle_predictor.write(paddle_in_trans(screen_trans, screen_trans.bt2_trans, reset_all));
      left_paddle_fifo.get(game_trans.pd_l_trans);
      right_paddle_fifo.get(game_trans.pd_r_trans);

      ball_in_trans = screen_button_paddle_transaction::type_id::create("ball in");
      ball_in_trans.sc_trans = screen_trans.sc_trans;
      ball_in_trans.pd_l_trans = game_trans.pd_l_trans;
      ball_in_trans.pd_r_trans = game_trans.pd_r_trans;
      ball_in_trans.rst_trans.rst = reset_all;
      pong_predictor.write(ball_in_trans);
      ball_fifo.get(game_trans.bl_trans);

      game_over = !screen_trans.rst_trans.rst && (game_trans.bl_trans.outLeftBound || game_trans.bl_trans.outRightBound);
      game_ap.write(game_trans);
    end
  endtask

  function screen_button_transaction paddle_in_trans(screen_buttons_transaction screen_trans, bit_transaction button_trans, bit rst);
    paddle_in_trans = screen_button_transaction::type_id::create("paddle in");
    paddle_in_trans.sc_trans = screen_trans.sc_trans;
    paddle_in_trans.bt_trans = button_trans;
    paddle_in_trans.rst_trans.rst = rst;
  endfunction

endclass
