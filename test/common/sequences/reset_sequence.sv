class reset_sequence extends uvm_sequence #(reset_transaction);

  `uvm_object_utils(reset_sequence)

  rand int num;

  constraint c1 { num inside {[30:50]}; }

  function new(string name = "reset_sequence");
    super.new(name);
  endfunction

  virtual task body();
  `uvm_info("Seq",$sformatf("runs: 0x%0d",num), UVM_NONE)
    for (int i = 0; i < num; i++) begin
      reset_transaction trans = reset_transaction::type_id::create("rst in");
      start_item(trans);
      trans.randomize();
      finish_item(trans);
    end
  endtask

endclass
