class bit_transaction extends uvm_sequence_item;

  rand bit in;
  bit out;

  constraint c1 { in dist {0:/80, 1:/20}; }

  `uvm_object_utils(bit_transaction)

  function new(string name = "bit_transaction");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    bit_transaction ext_transaction;
    super.do_copy(rhs);
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COPY", "rhs is not a bit_transaction")
    this.out = ext_transaction.out;
    this.in = ext_transaction.in;
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  bit_transaction ext_transaction;
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COMP", "rhs is not a bit_transaction")
    return super.do_compare(rhs, comparer) && this.out === ext_transaction.out && this.in === ext_transaction.in; 
  endfunction

  virtual function string convert2string();
    string s = $sformatf("in=0x%0d, out=0x%0d", this.in, this.out);
    return s;
  endfunction

endclass
