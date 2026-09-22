`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_out)

class ball_coverage extends uvm_component;
  `uvm_component_utils(ball_coverage)

  uvm_analysis_imp_in #(screen_button_paddle_transaction, ball_coverage) in_export;
  uvm_analysis_imp_out #(ball_transaction, ball_coverage) output_export;

  real in_sc_coverage;
  real in_paddle_coverage;
  real out_coverage;

  covergroup in_sc_cg with function sample(bit screenDone);
    option.per_instance = 1;

    cp_screenDone: coverpoint screenDone {
      bins zero = { 0 };
      bins one = { 1 };
      bins zero_to_zero = ( 0 => 0 );
      bins zero_to_one = ( 0 => 1 );
      bins one_to_zero = ( 1 => 0 );
      bins one_to_one = ( 1 => 1 );
    }

  endgroup

  covergroup out_cg with function sample(bit inbound, bit outLeftBound, bit outRightBound);
    option.per_instance = 1;

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

  function new(string name = "ball_coverage", uvm_component parent);
    super.new(name, parent);
    in_sc_cg = new();
    out_cg = new();
    in_export = new("in_export", this);
    output_export = new("output_export", this);
  endfunction

  virtual function void write_in(screen_button_paddle_transaction trans);
    in_sc_cg.sample(trans.sc_trans.screenDone);
  endfunction

  virtual function void write_out(ball_transaction trans);
    out_cg.sample(trans.inbound, trans.outLeftBound, trans.outRightBound);
  endfunction

  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    in_sc_coverage = in_sc_cg.get_inst_coverage();
    out_coverage = out_cg.get_inst_coverage();
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COV_REPORT", $sformatf("screen index and update coverage: %0f", in_sc_coverage), UVM_LOW)
    `uvm_info("COV_REPORT", $sformatf("out coverage: %0f", out_coverage), UVM_LOW)
  endfunction
endclass
