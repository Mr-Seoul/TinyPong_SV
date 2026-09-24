class screen_buttons_transaction extends uvm_sequence_item;
  `uvm_object_utils(screen_buttons_transaction)

  screen_transaction sc_trans;
  reset_transaction rst_trans;
  bit_transaction bt1_trans;
  bit_transaction bt2_trans;

  function new(string name = "screen buttons transaction");
    super.new(name);
    sc_trans = screen_transaction::type_id::create("screen transaction");
    rst_trans = reset_transaction::type_id::create("rst transaction");
    bt1_trans = bit_transaction::type_id::create("button1 transaction");
    bt2_trans = bit_transaction::type_id::create("button2 transaction");
  endfunction

  virtual function void do_copy(uvm_object rhs);
    screen_buttons_transaction ext_transaction;
    super.do_copy(rhs);
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COPY", "rhs is not a screen_buttons_transaction")
    this.sc_trans.copy(ext_transaction.sc_trans);
    this.rst_trans.copy(ext_transaction.rst_trans);
    this.bt1_trans.copy(ext_transaction.bt1_trans);
    this.bt2_trans.copy(ext_transaction.bt2_trans);
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    screen_buttons_transaction ext_transaction;
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COMP", "rhs is not a screen_buttons_transaction")
    return super.do_compare(rhs, comparer) && this.sc_trans.compare(ext_transaction.sc_trans, comparer) && this.rst_trans.compare(ext_transaction.rst_trans, comparer)
                                           && this.bt1_trans.compare(ext_transaction.bt1_trans, comparer) && this.bt2_trans.compare(ext_transaction.bt2_trans, comparer);
  endfunction

  virtual function string convert2string();
    string s;
    s = $sformatf("%s %s", s, this.sc_trans.convert2string());
    s = $sformatf("%s %s", s, this.rst_trans.convert2string());
    s = $sformatf("%s %s", s, this.bt1_trans.convert2string());
    s = $sformatf("%s %s", s, this.bt2_trans.convert2string());
    return s;
  endfunction

endclass
