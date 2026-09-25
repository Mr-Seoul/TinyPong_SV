class ball_transaction extends uvm_sequence_item;

  bit inbound;
  bit outLeftBound;
  bit outRightBound;
  bit goingRight;
  bit goingDown;

  `uvm_object_utils(ball_transaction)

  function new(string name = "ball_transaction");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    ball_transaction ext_transaction;
    super.do_copy(rhs);
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COPY", "rhs is not a ball_transaction")
    this.inbound = ext_transaction.inbound;
    this.outLeftBound = ext_transaction.outLeftBound;
    this.outRightBound = ext_transaction.outRightBound;
    this.goingRight = ext_transaction.goingRight;
    this.goingDown = ext_transaction.goingDown;
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  ball_transaction ext_transaction;
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COMP", "rhs is not a ball_transaction")
    return super.do_compare(rhs, comparer) && this.inbound === ext_transaction.inbound && this.outLeftBound === ext_transaction.outLeftBound && this.outRightBound === ext_transaction.outRightBound;
  endfunction

  virtual function string convert2string();
    string s = $sformatf("inbound=%0b, outLeftBound=%0b, outRightBound=%0b", this.inbound, this.outLeftBound, this.outRightBound);
    return s;
  endfunction

endclass
