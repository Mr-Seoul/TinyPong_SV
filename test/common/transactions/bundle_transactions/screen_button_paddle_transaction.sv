class screen_button_paddle_transaction extends uvm_sequence_item;
  `uvm_object_utils(screen_button_paddle_transaction)

  screen_transaction sc_trans;
  paddle_transaction pd_l_trans;
  paddle_transaction pd_r_trans;
  reset_transaction rst_trans;

  function new(string name = "screen paddle transaction");
    super.new(name);
    sc_trans = screen_transaction::type_id::create("screen transaction");
    pd_l_trans = paddle_transaction::type_id::create("left paddle transaction");
    pd_r_trans = paddle_transaction::type_id::create("right paddle transaction");
    rst_trans = reset_transaction::type_id::create("rst transaction");
  endfunction

  virtual function void do_copy(uvm_object rhs);
    screen_button_paddle_transaction ext_transaction;
    super.do_copy(rhs);
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COPY", "rhs is not a screen_button_paddle_transaction")
    this.sc_trans.copy(ext_transaction.sc_trans);
    this.pd_l_trans.copy(ext_transaction.pd_l_trans);
    this.pd_r_trans.copy(ext_transaction.pd_r_trans);
    this.rst_trans.copy(ext_transaction.rst_trans);
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    screen_button_paddle_transaction ext_transaction;
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COMP", "rhs is not a screen_button_paddle_transaction")
    return super.do_compare(rhs, comparer) && this.sc_trans.compare(ext_transaction.sc_trans, comparer) && this.pd_l_trans.compare(ext_transaction.pd_l_trans, comparer)
                                           && this.pd_r_trans.compare(ext_transaction.pd_r_trans, comparer) && this.rst_trans.compare(ext_transaction.rst_trans, comparer);
  endfunction

  virtual function string convert2string();
    string s;
    s = $sformatf("%s %s", s, this.sc_trans.convert2string());
    s = $sformatf("%s %s", s, this.pd_l_trans.convert2string());
    s = $sformatf("%s %s", s, this.pd_r_trans.convert2string());
    s = $sformatf("%s %s", s, this.rst_trans.convert2string());
    return s;
  endfunction

endclass
