class paddle_predictor extends uvm_subscriber #(screen_button_transaction);

  `uvm_component_utils(paddle_predictor)
  uvm_analysis_port #(paddle_transaction) ap;

  bit SIDE = 0;
  int paddle_y = 240;
  int paddle_x;
  int paddle_velocity = 0;
  

  function new(string name = "paddle_predictor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(bit)::get(this, "", "SIDE", SIDE))
      `uvm_fatal("PRD", "Could not get SIDE")
    paddle_x = 1'(SIDE) ? 640 - settings::paddleWallDist - settings::paddleWidth : settings::paddleWallDist + settings::paddleWidth;
    ap = new("ap", this);
  endfunction

  virtual function void write(screen_button_transaction trans);
    int y_min;
    int y_max;
    int diff_x;
    paddle_transaction expected = paddle_transaction::type_id::create("expected");

    if (trans.rst_trans.rst) begin
      paddle_y = 240;
      paddle_velocity = 0;
    end

    y_min = paddle_y - settings::paddleHeight;
    y_max = paddle_y;
    diff_x = SIDE ? paddle_x - $bits(int)'(trans.sc_trans.screenX) : $bits(int)'(trans.sc_trans.screenX) - paddle_x;

    expected.paddleY = $bits(expected.paddleY)'(paddle_y);
    expected.inbound = ($bits(int)'(trans.sc_trans.screenY) >= y_min) & ($bits(int)'(trans.sc_trans.screenY) <= y_max ) & & (diff_x >= 0) & (diff_x <= settings::paddleWidth);
    expected.diffX = $bits(expected.diffX)'(diff_x);
    
    if (!trans.rst_trans.rst && trans.sc_trans.screenDone) begin
      paddle_y += paddle_velocity;
      if (paddle_y < settings::paddleHeight) begin
        paddle_y = settings::paddleHeight;
      end else if (paddle_y >= 480) begin
        paddle_y = 480;
      end
      paddle_velocity += settings::paddleGravity;
      if (trans.bt_trans.in) begin
        paddle_velocity = -settings::paddleJumpSpeed;
      end else if (paddle_y <= settings::paddleHeight) begin
        paddle_velocity = settings::paddleGravity;
      end else if (paddle_y >= 480) begin
        paddle_velocity = 0;
      end
    end

    ap.write(expected);
  endfunction

endclass
