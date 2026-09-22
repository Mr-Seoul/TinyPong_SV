class timing_transaction extends uvm_sequence_item;

  `uvm_object_utils(timing_transaction)

  bit hsync;
  bit vsync;

  function new(string name = "timing_transaction");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    timing_transaction ext_transaction;
    super.do_copy(rhs);
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COPY", "rhs is not a timing_transaction")
    this.hsync = ext_transaction.hsync;
    this.vsync = ext_transaction.vsync;
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    timing_transaction ext_transaction;
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COMP", "rhs is not a timing_transaction")
    return super.do_compare(rhs, comparer) && this.hsync === ext_transaction.hsync && this.vsync === ext_transaction.vsync; 
  endfunction

  virtual function string convert2string();
    string s = $sformatf("hsync=0x%0d, vsync=0x%0d", this.hsync, this.vsync);
    return s;
  endfunction

endclass
