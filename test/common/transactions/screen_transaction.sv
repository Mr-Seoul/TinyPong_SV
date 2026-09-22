class screen_transaction extends uvm_sequence_item;

  `uvm_object_utils(screen_transaction)

  rand bit [10:0] screenX;
  rand bit [10:0] screenY;
  rand bit screenDone;

  constraint c1 { screenX dist {[0:655]:/80,[656:751]:/15,[752:799]:/5};}
  constraint c2 { screenY dist {[0:489]:/80,[490:491]:/15,[492:524]:/5};}
  constraint c3 { screenDone dist {0:/99,1:/1};}

  function new(string name = "screen_transaction");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    screen_transaction ext_transaction;
    super.do_copy(rhs);
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COPY", "rhs is not a screen_transaction")
    this.screenX = ext_transaction.screenX;
    this.screenY = ext_transaction.screenY;
    this.screenDone = ext_transaction.screenDone;
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    screen_transaction ext_transaction;
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COMP", "rhs is not a screen_transaction")
    return super.do_compare(rhs, comparer) && this.screenX === ext_transaction.screenX && this.screenY === ext_transaction.screenY 
                                           && this.screenDone === ext_transaction.screenDone;
  endfunction

  virtual function string convert2string();
    string s = $sformatf("screenX=0x%0d, screenY=0x%0d, screenDone=%0b", this.screenX, this.screenY, this.screenDone);
    return s;
  endfunction

endclass
