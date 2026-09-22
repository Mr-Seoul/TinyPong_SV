class paddle_transaction extends uvm_sequence_item;

  rand bit signed [10:0] paddleY;
  bit inbound;
  bit [4:0] diffX;

  constraint c1 { paddleY inside {[settings::paddleHeight:479]}; }

  `uvm_object_utils(paddle_transaction)

  function new(string name = "paddle_transaction");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    paddle_transaction ext_transaction;
    super.do_copy(rhs);
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COPY", "rhs is not a paddle_transaction")
    this.paddleY = ext_transaction.paddleY;
    this.inbound = ext_transaction.inbound;
    this.diffX = ext_transaction.diffX;
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    paddle_transaction ext_transaction;
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COMP", "rhs is not a paddle_transaction")
    return super.do_compare(rhs, comparer) && this.paddleY === ext_transaction.paddleY && this.inbound === ext_transaction.inbound 
                                           && this.diffX === ext_transaction.diffX;
  endfunction

  virtual function string convert2string();
    string s = $sformatf("paddleY=%0d, inbound=%0b, diffX=%0d", this.paddleY, this.inbound, this.diffX);
    return s;
  endfunction

endclass
