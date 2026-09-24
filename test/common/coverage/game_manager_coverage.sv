`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_out)

class game_manager_coverage extends uvm_component;
  `uvm_component_utils(game_manager_coverage)

  uvm_analysis_imp_in #(game_transaction, game_manager_coverage) in_export;
  uvm_analysis_imp_out #(vga_transaction, game_manager_coverage) output_export;

  real pd_l_coverage, pd_r_coverage, bl_coverage;
  real rst_coverage, out_coverage;

  covergroup in_pd_l_cg with function sample(bit inbound, bit [10:0] paddleY);
    cp_rst: coverpoint inbound {
      bins low  = { 0 };
      bins high  = { 1 };
    }

    cp_paddleY: coverpoint paddleY {
      bins low = { settings::paddleHeight };
      bins mid = { [settings::paddleHeight+1:479] };
      bins high = { 480 };
    }
    
  endgroup

  covergroup in_pd_r_cg with function sample(bit inbound, bit [10:0] paddleY);
    cp_rst: coverpoint inbound {
      bins low  = { 0 };
      bins high  = { 1 };
    }

    cp_paddleY: coverpoint paddleY {
      bins low = { settings::paddleHeight };
      bins mid = { [settings::paddleHeight+1:479] };
      bins high = { 480 };
    }
    
  endgroup

  covergroup in_bl_cg with function sample(bit inbound, bit outLeftBound, bit outRightBound);
    cp_inbound: coverpoint inbound {
      bins low  = { 0 };
      bins high  = { 1 };
    }

    cp_outLeftBound: coverpoint outLeftBound {
      bins low  = { 0 };
      bins high  = { 1 };
    }

    cp_outRightBound: coverpoint outRightBound {
      bins low  = { 0 };
      bins high  = { 1 };
    }

  endgroup

  covergroup in_rst with function sample(bit rst, bit game_over);
    cp_rst: coverpoint rst {
      bins low  = { 0 };
      bins high  = { 1 };
    }

    cp_game_over: coverpoint game_over {
      bins low  = { 0 };
      bins high  = { 1 };
    }

  endgroup

  covergroup out_cg with function sample(bit [1:0] r, bit [1:0] g, bit [1:0] b);
    cp_r: coverpoint r {
      bins low  = { 0 };
      bins dithered  = { [1:2] };
      bins high  = { 3 };
    }

    cp_g: coverpoint g {
      bins low  = { 0 };
      bins dithered  = { [1:2] };
      bins high  = { 3 };
    }

    cp_b: coverpoint b {
      bins low  = { 0 };
      bins dithered  = { [1:2] };
      bins high  = { 3 };
    }
    
  endgroup

  function new(string name = "game_manager_coverage", uvm_component parent);
    super.new(name, parent);
    in_export = new("in_export", this);
    output_export = new("output_export", this);
    in_pd_l_cg = new();
    in_pd_r_cg = new();
    in_bl_cg = new();
    in_rst = new();
    out_cg = new();
  endfunction

  virtual function void write_in(game_transaction trans);
    in_pd_l_cg.sample(trans.pd_l_trans.inbound,trans.pd_l_trans.paddleY);
    in_pd_r_cg.sample(trans.pd_r_trans.inbound,trans.pd_r_trans.paddleY);
    in_bl_cg.sample(trans.bl_trans.inbound,trans.bl_trans.outLeftBound,trans.bl_trans.outRightBound);
    in_rst.sample(trans.sb_trans.rst_trans.rst, trans.game_over);
  endfunction

  virtual function void write_out(vga_transaction trans);
    out_cg.sample(trans.r, trans.g, trans.b);
  endfunction

  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    pd_l_coverage = in_pd_l_cg.get_inst_coverage();
    pd_r_coverage = in_pd_r_cg.get_inst_coverage();
    bl_coverage = in_bl_cg.get_inst_coverage();
    rst_coverage = in_rst.get_inst_coverage();
    out_coverage = out_cg.get_inst_coverage();
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COV_REPORT", $sformatf("left paddle coverage: %0f", pd_l_coverage), UVM_LOW)
    `uvm_info("COV_REPORT", $sformatf("right paddle coverage: %0f", pd_r_coverage), UVM_LOW)
    `uvm_info("COV_REPORT", $sformatf("ball coverage: %0f", bl_coverage), UVM_LOW)
    `uvm_info("COV_REPORT", $sformatf("reset coverage: %0f", rst_coverage), UVM_LOW)
    `uvm_info("COV_REPORT", $sformatf("colour coverage: %0f", out_coverage), UVM_LOW)
  endfunction

endclass
