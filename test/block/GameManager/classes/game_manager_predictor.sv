class game_manager_predictor extends uvm_subscriber #(game_transaction);

  `uvm_component_utils(game_manager_predictor)
  uvm_analysis_port #(vga_transaction) ap;

  function new(string name = "game_manager_predictor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
  endfunction

  virtual function void write(game_transaction trans);
    int screenX, screenY, dithering;
    bit dithered;
    vga_transaction expected = vga_transaction::type_id::create("expected");

    screenX = $bits(int)'(trans.sb_trans.sc_trans.screenX);
    screenY = $bits(int)'(trans.sb_trans.sc_trans.screenY);
    dithering = $bits(int)'({ 1'b0, screenX[0]^screenY[0], screenY[1], screenX[1]^screenY[1], screenY[0]});

    if (trans.pd_l_trans.inbound) begin //Left paddle colour
      dithered = trans.pd_l_trans.diffX <= 5'(dithering);
      expected.r = { dithered, 1'b1};
      expected.g = 0;
      expected.b = 0;
    end else if (trans.pd_r_trans.inbound) begin //Right paddle colour
      dithered = trans.pd_r_trans.diffX <= 5'(dithering);
      expected.r = 0;
      expected.g = { dithered, 1'b1};
      expected.b = 0;
    end else if (trans.bl_trans.inbound) begin //Ball colour
      expected.r = 0;
      expected.g = 2'b11;
      expected.b = 2'b11;
    end else begin //Background colour
      expected.r = { 1'b0 , (screenX[5] ^ screenY[5]) ^ (screenX[2] ^ screenY[2]) };
      expected.g = { 1'b0 , (screenX[4] ^ screenY[4]) ^ (screenX[1] ^ screenY[1]) };
      expected.b = { 1'b0 , (screenX[3] ^ screenY[3]) ^ (screenX[0] ^ screenY[0]) };
    end

    ap.write(expected);
  endfunction

endclass
