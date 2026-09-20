`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_out)

class timing_coverage extends uvm_component;
  `uvm_component_utils(timing_coverage)

  uvm_analysis_imp_in #(screen_transaction, timing_coverage) input_export;
  uvm_analysis_imp_out #(timing_transaction, timing_coverage) output_export;

  real in_coverage;
  real out_coverage;

  covergroup in_cg with function sample(bit [10:0] screenX, bit [10:0] screenY);
    option.per_instance = 1;

    cp_screenX: coverpoint screenX {
      bins low  ={ [0:655] };
      bins mid  = { [656:751] };
      bins high  = { [752:799] };
    }

    cp_screenY: coverpoint screenY {
      bins low  = { [0:489] };
      bins mid  = { [490:491] };
      bins high  = { [492:524] };
    }

    cross_screen: cross cp_screenX, cp_screenY;
  endgroup

  covergroup out_cg with function sample(bit hsync, bit vsync);
    option.per_instance = 1;

    cp_hsync: coverpoint hsync {
      bins zero  = { 0 };
      bins one  =  { 1 };
    }

    cp_vsync: coverpoint vsync {
      bins zero  = { 0 };
      bins one  =  { 1 };
    }

    cross_sync: cross cp_hsync, cp_vsync;

  endgroup

  function new(string name = "coverage_reporter", uvm_component parent);
    super.new(name, parent);
    in_cg = new();
    out_cg = new();
    input_export = new("input_export", this);
    output_export = new("output_export", this);
  endfunction

  virtual function void write_in(screen_transaction trans);
    in_cg.sample(trans.screenX, trans.screenY);
  endfunction

  virtual function void write_out(timing_transaction trans);
    out_cg.sample(trans.hsync, trans.vsync);
  endfunction

  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    in_coverage = in_cg.get_inst_coverage();
    out_coverage = out_cg.get_inst_coverage();
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COV_REPORT", $sformatf("in coverage: %0f", in_coverage), UVM_LOW)
    `uvm_info("COV_REPORT", $sformatf("out coverage: %0f", out_coverage), UVM_LOW)
  endfunction
endclass
