class bit_transaction extends uvm_sequence_item;

  rand bit in;
  rand bit rst;
  bit out;

  constraint c1 { in dist {0:/80, 1:/20}; }
  constraint c2 { rst dist {0:/80, 1:/20}; }

  `uvm_object_utils(bit_transaction)

  function new(string name = "bit_transaction");
    super.new(name);
  endfunction

  function do_copy(bit_transaction ext_transaction);
    this.out = ext_transaction.out;
    this.in = ext_transaction.in;
  endfunction

  function do_compare(bit_transaction ext_transaction);
    return this.out === ext_transaction.out && this.in === ext_transaction.in; 
  endfunction

  function string convert2string();
    string s = $sformatf("in=0x%0d, out=0x%0d", this.in, this.out);
    return s;
  endfunction

endclass
