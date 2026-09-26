class vga_transaction extends uvm_sequence_item;

  `uvm_object_utils(vga_transaction)

  bit [1:0] r;
  bit [1:0] g;
  bit [1:0] b;

  function new(string name = "vga_transaction");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    vga_transaction ext_transaction;
    super.do_copy(rhs);
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COPY", "rhs is not a vga_transaction")
    this.r = ext_transaction.r;
    this.g = ext_transaction.g;
    this.b = ext_transaction.b;
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    vga_transaction ext_transaction;
    if (!$cast(ext_transaction, rhs))
      `uvm_fatal("COMP", "rhs is not a vga_transaction")
    return super.do_compare(rhs, comparer) && this.r === ext_transaction.r && this.g === ext_transaction.g && this.b === ext_transaction.b;
  endfunction

  virtual function string convert2string();
    string s = $sformatf("r=0x%0d, g=0x%0d, b=0x%0d", this.r, this.g, this.b);
    return s;
  endfunction

endclass
