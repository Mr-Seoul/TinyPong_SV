class timing_transaction extends uvm_sequence_item;

  `uvm_object_utils(timing_transaction)

  bit hsync;
  bit vsync;

  function new(string name = "timing_transaction");
    super.new(name);
  endfunction

  function do_copy(timing_transaction ext_transaction);
    this.hsync = ext_transaction.hsync;
    this.vsync = ext_transaction.vsync;
  endfunction

  function do_compare(timing_transaction ext_transaction);
    timing_transaction ext_transaction;
    if (!$cast(ext_transaction, rhs)) return 0;
    return super.do_compare(rhs, comparer) && this.hsync === ext_transaction.hsync && this.vsync === ext_transaction.vsync; 
  endfunction

  function string convert2string();
    string s = $sformatf("hsync=0x%0d, vsync=0x%0d", this.hsync, this.vsync);
    return s;
  endfunction

endclass
