class graphics_manager_coverage extends game_manager_coverage;
  `uvm_component_utils(graphics_manager_coverage)

  real screen_coverage;

  covergroup in_sc_cg with function sample(bit [10:0] screenX, bit [10:0] screenY);
    cp_screenX: coverpoint screenX {
      bins visible  = { [0:639] };
      bins out_of_bounds  = { [640:799] };
    }

    cp_screenY: coverpoint screenY {
      bins visible  = { [0:479] };
      bins out_of_bounds  = { [480:524] };
    }

    cross_screen: cross cp_screenX, cp_screenY;
  endgroup

  function new(string name = "graphics_manager_coverage", uvm_component parent);
    super.new(name, parent);
    in_sc_cg = new();
  endfunction

  virtual function void write_in(game_transaction trans);
    super.write_in(trans);
    in_sc_cg.sample(trans.sb_trans.sc_trans.screenX, trans.sb_trans.sc_trans.screenY);
  endfunction

  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    screen_coverage = in_sc_cg.get_inst_coverage();
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COV_REPORT", $sformatf("screen coverage: %0f", screen_coverage), UVM_LOW)
  endfunction

endclass
