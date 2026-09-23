class ball_predictor extends uvm_subscriber #(screen_button_paddle_transaction);

  `uvm_component_utils(ball_predictor)
  uvm_analysis_port #(ball_transaction) ap;

  int ball_x = 320;
  int ball_y = 64;
  int ball_speed = settings::ballSpeed;
  bit going_down = 1;
  bit going_right = 1;

  function new(string name = "ball_predictor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
  endfunction

  virtual function void write(screen_button_paddle_transaction trans);
    bit in_ball_x, in_ball_y;
    int left_paddle_top, left_paddle_bottom, left_paddle_left, left_paddle_right;
    int right_paddle_top, right_paddle_bottom, right_paddle_left, right_paddle_right;
    bit in_left_paddle, in_right_paddle;
    bit new_dir;

    ball_transaction expected = ball_transaction::type_id::create("expected");

    if (trans.rst_trans.rst) begin
      ball_x = 320;
      ball_y = 64;
      ball_speed = settings::ballSpeed;
      going_down = 1;
      going_right = 1;
    end

    in_ball_x = $bits(int)'(trans.sc_trans.screenX) >= ball_x & $bits(int)'(trans.sc_trans.screenX) <= ball_x + 2*settings::ballRadius;
    in_ball_y = $bits(int)'(trans.sc_trans.screenY) >= ball_y & $bits(int)'(trans.sc_trans.screenY) <= ball_y + 2*settings::ballRadius;

    expected.inbound = in_ball_x & in_ball_y;
    expected.outLeftBound = ball_x <= 0;
    expected.outRightBound = ball_x > 640;

    if (!trans.rst_trans.rst && trans.sc_trans.screenDone) begin
      ball_x += going_right ? ball_speed : -ball_speed;
      ball_y += going_down ? ball_speed : -ball_speed;

      left_paddle_top = $bits(int)'(trans.pd_l_trans.paddleY) + settings::paddleHeight - settings::ballRadius;
      left_paddle_bottom = $bits(int)'(trans.pd_l_trans.paddleY) + settings::ballRadius;
      left_paddle_left = settings::paddleWallDist - settings::paddleWidth;
      left_paddle_right = settings::paddleWallDist + 2*settings::paddleWidth;

      right_paddle_top = $bits(int)'(trans.pd_r_trans.paddleY) + settings::paddleHeight - settings::ballRadius;
      right_paddle_bottom = $bits(int)'(trans.pd_r_trans.paddleY) + settings::ballRadius;
      right_paddle_left = 640 - settings::paddleWallDist - settings::paddleWidth - 2*settings::ballRadius;
      right_paddle_right = 640 - settings::paddleWallDist;

      in_left_paddle = ( $bits(int)'(trans.pd_l_trans.paddleY) >= left_paddle_left & $bits(int)'(trans.pd_l_trans.paddleY) <= left_paddle_right) & ( $bits(int)'(trans.pd_l_trans.paddleY) >= left_paddle_bottom & $bits(int)'(trans.pd_l_trans.paddleY) <= left_paddle_top);
      in_right_paddle = ( $bits(int)'(trans.pd_r_trans.paddleY) >= right_paddle_left & $bits(int)'(trans.pd_r_trans.paddleY) <= right_paddle_right) & ( $bits(int)'(trans.pd_r_trans.paddleY) >= right_paddle_bottom & $bits(int)'(trans.pd_r_trans.paddleY) <= right_paddle_top);
      
      new_dir = ball_speed[1]^ball_speed[0]^going_down^going_right;

      if (in_left_paddle & !going_right) begin
        going_right = 1;
        going_down = new_dir;
      end else if (in_right_paddle & going_right) begin
        going_right = 1;
        going_down = new_dir;
        ball_speed += 1;
        if (ball_speed > 31) begin
          ball_speed = 31;
        end
      end
    end

    ap.write(expected);
  endfunction

endclass
