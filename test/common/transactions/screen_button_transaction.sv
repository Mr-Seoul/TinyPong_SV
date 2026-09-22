class screen_button_transaction extends uvm_sequence_item;
  `uvm_object_utils(screen_button_transaction)

  screen_transaction sc_trans;
  bit_transaction bt_trans;

  function new(string name = "screen button transaction");
    super.new(name);
    sc_trans = screen_transaction::type_id::create("screen transaction");
    bt_trans = bit_transaction::type_id::create("bit transaction");
  endfunction

  virtual function void do_copy(uvm_object rhs);
    screen_button_transaction ext_transaction;
    super.do_copy(rhs);
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COPY", "rhs is not a screen_button_transaction")
    this.sc_trans.copy(ext_transaction.sc_trans);
    this.bt_trans.copy(ext_transaction.bt_trans);
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    screen_button_transaction ext_transaction;
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COMP", "rhs is not a screen_button_transaction")
    return super.do_compare(rhs, comparer) && this.sc_trans.compare(ext_transaction.sc_trans, comparer)
                                           && this.bt_trans.compare(ext_transaction.bt_trans, comparer);
  endfunction

  virtual function string convert2string();
    string s;
    s = $sformatf("%s %s", s, this.sc_trans.convert2string());
    s = $sformatf("%s %s", s, this.bt_trans.convert2string());
    return s;
  endfunction

endclass