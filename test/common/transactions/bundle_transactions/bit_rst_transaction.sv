class bit_rst_transaction extends uvm_sequence_item;
  `uvm_object_utils(bit_rst_transaction)

  bit_transaction bt_trans;
  reset_transaction rst_trans;

  function new(string name = "bit rst transaction");
    super.new(name);
    bt_trans = bit_transaction::type_id::create("bit transaction");
    rst_trans = reset_transaction::type_id::create("rst transaction");
  endfunction

  virtual function void do_copy(uvm_object rhs);
    bit_rst_transaction ext_transaction;
    super.do_copy(rhs);
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COPY", "rhs is not a bit_rst_transaction")
    this.bt_trans.copy(ext_transaction.bt_trans);
    this.rst_trans.copy(ext_transaction.rst_trans);
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    bit_rst_transaction ext_transaction;
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COMP", "rhs is not a bit_rst_transaction")
    return super.do_compare(rhs, comparer) && this.bt_trans.compare(ext_transaction.bt_trans, comparer)
                                           && this.rst_trans.compare(ext_transaction.rst_trans, comparer);
  endfunction

  virtual function string convert2string();
    string s;
    s = $sformatf("%s %s", s, this.bt_trans.convert2string());
    s = $sformatf("%s %s", s, this.rst_trans.convert2string());
    return s;
  endfunction

endclass
