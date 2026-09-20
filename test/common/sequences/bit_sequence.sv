class bit_sequence extends uvm_sequence #(bit_transaction);

  `uvm_object_utils(bit_sequence) 

  rand int num;

  constraint c1 { num inside {[30:50]}; }

  function new(string name = "bit_sequence");
    super.new(name);
  endfunction

  virtual task body();
  `uvm_info("Seq",$sformatf("runs: 0x%0d",num), UVM_NONE)
    for (int i = 0; i< num; i++) begin
      bit_transaction trans = bit_transaction::type_id::create("bit in");
      start_item(trans);
      trans.randomize();
      finish_item(trans);
    end
  endtask

endclass
