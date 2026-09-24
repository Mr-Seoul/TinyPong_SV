class game_transaction extends uvm_sequence_item;
  `uvm_object_utils(game_transaction)

  screen_buttons_transaction sb_trans;
  paddle_transaction pd_l_trans;
  paddle_transaction pd_r_trans;
  ball_transaction bl_trans;
  bit game_over;

  function new(string name = "game transaction");
    super.new(name);
    sb_trans = screen_buttons_transaction::type_id::create("screen buttons transaction");
    pd_l_trans = paddle_transaction::type_id::create("left paddle transaction");
    pd_r_trans = paddle_transaction::type_id::create("right paddle transaction");
    bl_trans = ball_transaction::type_id::create("ball transaction");
  endfunction

  virtual function void do_copy(uvm_object rhs);
    game_transaction ext_transaction;
    super.do_copy(rhs);
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COPY", "rhs is not a game_transaction")
    this.sb_trans.copy(ext_transaction.sb_trans);
    this.pd_l_trans.copy(ext_transaction.pd_l_trans);
    this.pd_r_trans.copy(ext_transaction.pd_r_trans);
    this.bl_trans.copy(ext_transaction.bl_trans);
    this.game_over = ext_transaction.game_over;
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    game_transaction ext_transaction;
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COMP", "rhs is not a game_transaction")
    return super.do_compare(rhs, comparer) && this.sb_trans.compare(ext_transaction.sb_trans, comparer) && this.pd_l_trans.compare(ext_transaction.pd_l_trans, comparer)
                                           && this.pd_r_trans.compare(ext_transaction.pd_r_trans, comparer) && this.bl_trans.compare(ext_transaction.bl_trans, comparer)
                                           && this.game_over === ext_transaction.game_over;
  endfunction

  virtual function string convert2string();
    string s;
    s = $sformatf("%s %s", s, this.sb_trans.convert2string());
    s = $sformatf("%s %s", s, this.pd_l_trans.convert2string());
    s = $sformatf("%s %s", s, this.pd_r_trans.convert2string());
    s = $sformatf("%s %s", s, this.bl_trans.convert2string());
    s = $sformatf("%s game_over=%0b", s, this.game_over);
    return s;
  endfunction

endclass
