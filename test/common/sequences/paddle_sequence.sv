class paddle_sequence extends uvm_sequence #(paddle_transaction);

  `uvm_object_utils(paddle_sequence)

  rand int num;

  constraint c1 { num inside {[200:500]}; }

  function new(string name = "paddle_sequence");
    super.new(name);
  endfunction

  virtual task body();
  `uvm_info("Seq",$sformatf("runs: 0x%0d",num), UVM_NONE)
    for (int i = 0; i< num; i++) begin
      paddle_transaction trans = paddle_transaction::type_id::create("paddle in");
      start_item(trans);
      trans.randomize();
      finish_item(trans);
    end
  endtask

endclass
