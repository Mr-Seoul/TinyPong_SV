class screen_transaction extends uvm_sequence_item;

  `uvm_object_utils(screen_transaction)

  rand bit [10:0] screenX;
  rand bit [10:0] screenY;
  rand bit screenDone;

  constraint c1 { screenX dist {[0:655]:/80,[656:751]:/15,[752:799]:/5};}
  constraint c2 { screenY dist {[0:489]:/80,[490:491]:/15,[492:524]:/5};}
  constraint c3 { screenDone dist {0:/90,1:/10};}

  function new(string name = "screen_transaction");
    super.new(name);
  endfunction

  function do_copy(screen_transaction ext_transaction);
    this.screenX = ext_transaction.screenX;
    this.screenY = ext_transaction.screenY;
    this.screenDone = ext_transaction.screenDone;
  endfunction

  function do_compare(screen_transaction ext_transaction);
    screen_transaction ext_transaction;
    if (!$cast(ext_transaction, rhs)) return 0;
    return super.do_compare(rhs, comparer) && this.screenX === ext_transaction.screenX && this.screenY === ext_transaction.screenY && this.screenDone === ext_transaction.screenDone; 
  endfunction

  function string convert2string();
    string s = $sformatf("screenX=0x%0d, screenY=0x%0d, screenDone=%0b", this.screenX, this.screenY, this.screenDone);
    return s;
  endfunction

endclass
