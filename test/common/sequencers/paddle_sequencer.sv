class paddle_sequencer extends uvm_sequencer #(paddle_transaction);

  `uvm_component_utils(paddle_sequencer)

  function new(string name = "paddle_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass
