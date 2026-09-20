class bit_sequencer extends uvm_sequencer #(bit_transaction);

  `uvm_component_utils(bit_sequencer)

  function new(string name = "bit_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass
