class graphics_manager_predictor extends game_manager_predictor;

  `uvm_component_utils(graphics_manager_predictor)

  function new(string name = "graphics_manager_predictor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void write(game_transaction trans);
    vga_transaction expected;

    if ($bits(int)'(trans.sb_trans.sc_trans.screenX) < 640 && $bits(int)'(trans.sb_trans.sc_trans.screenY) < 480) begin
      //If in bounds, get regular colour output
      super.write(trans);
    end else begin
      //If out of bounds, no colour output
      expected = vga_transaction::type_id::create("expected");
      expected.r = 2'b0;
      expected.g = 2'b0;
      expected.b = 2'b0;
      ap.write(expected);
    end
  endfunction

endclass
