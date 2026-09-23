class reset_transaction extends uvm_sequence_item;

  rand bit rst;

  constraint c1 { rst dist {0:/98, 1:/2}; }

  `uvm_object_utils(reset_transaction)

  function new(string name = "reset_transaction");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    reset_transaction ext_transaction;
    super.do_copy(rhs);
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COPY", "rhs is not a reset_transaction")
    this.rst = ext_transaction.rst;
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    reset_transaction ext_transaction;
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COMP", "rhs is not a reset_transaction")
    return super.do_compare(rhs, comparer) && this.rst === ext_transaction.rst;
  endfunction

  virtual function string convert2string();
    string s = $sformatf("rst=%0b", this.rst);
    return s;
  endfunction

endclass
