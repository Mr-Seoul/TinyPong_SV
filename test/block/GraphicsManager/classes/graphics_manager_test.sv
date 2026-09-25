class graphics_manager_test extends game_manager_test;
  `uvm_component_utils(graphics_manager_test)

  function new(string name = "graphics_manager_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    game_manager_predictor::type_id::set_type_override(graphics_manager_predictor::get_type());
    super.build_phase(phase);
  endfunction

endclass
