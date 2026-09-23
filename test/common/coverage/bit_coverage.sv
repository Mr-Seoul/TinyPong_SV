class bit_coverage extends uvm_component;
  `uvm_component_utils(bit_coverage)

  uvm_analysis_imp #(bit_rst_transaction, bit_coverage) trans_export;

  real in_coverage;
  real out_coverage;

  covergroup in_cg with function sample(bit in, bit rst);
    option.per_instance = 1;

    cp_in: coverpoint in {
      bins zero_to_zero  = ( 0 => 0 );
      bins zero_to_one  = ( 0 => 1 );
      bins one_to_zero  = ( 1 => 0 );
      bins one_to_one  = ( 1 => 1 );
    }

    cp_rst: coverpoint rst {
      bins low  = { 0 };
      bins high  = { 1 };
    }

    cross_in_rst: cross cp_in, cp_rst;
  endgroup

  covergroup out_cg with function sample(bit out);
    option.per_instance = 1;

    cp_out: coverpoint out {
      bins zero_to_zero  = ( 0 => 0 );
      bins zero_to_one  = ( 0 => 1 );
      bins one_to_zero  = ( 1 => 0 );
      bins one_to_one  = ( 1 => 1 );
    }

  endgroup

  function new(string name = "coverage_reporter", uvm_component parent);
    super.new(name, parent);
    in_cg = new();
    out_cg = new();
    trans_export = new("trans_export", this);
  endfunction

  virtual function void write(bit_rst_transaction trans);
    out_cg.sample(trans.bt_trans.out);
    in_cg.sample(trans.bt_trans.in, trans.rst_trans.rst);
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
