`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_out)

class paddle_coverage extends uvm_component;
  `uvm_component_utils(paddle_coverage)

  uvm_analysis_imp_in #(screen_button_transaction, paddle_coverage) in_export;
  uvm_analysis_imp_out #(paddle_transaction, paddle_coverage) output_export;

  real in_bt_coverage;
  real in_sc_coverage;
  real out_coverage;

  covergroup in_bt_cg with function sample(bit in, bit rst);
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

  covergroup in_sc_cg with function sample(bit [10:0] screenX, bit screenDone);
    option.per_instance = 1;

    cp_screenX: coverpoint screenX {
      bins left = { [0:settings::paddleWallDist-1] };
      bins left_paddle = { [settings::paddleWallDist:settings::paddleWallDist+settings::paddleWidth] };
      bins middle = { [settings::paddleWallDist+settings::paddleWidth+1:640-settings::paddleWallDist-settings::paddleWidth-1] };
      bins right_paddle = { [640-settings::paddleWallDist-settings::paddleWidth:640-settings::paddleWallDist] };
      bins right = { [640-settings::paddleWallDist+1:639] };
      bins out_of_bounds = { [640:799] };
    }

    cp_screenDone: coverpoint screenDone {
      bins zero_to_zero = ( 0 => 0 );
      bins zero_to_one = ( 0 => 1 );
      bins one_to_zero = ( 1 => 0 );
      bins one_to_one = ( 1 => 1 );
    }

  endgroup

  covergroup out_cg with function sample(bit [10:0] paddleY, bit inbound, bit [4:0] diffX);
    option.per_instance = 1;

    cp_paddleY: coverpoint paddleY {
      bins low = { settings::paddleHeight };
      bins mid = { [settings::paddleHeight+1:479] };
      bins high = { 480 };
    }

    cp_inbound: coverpoint inbound {
      bins low = { 0 };
      bins high = { 1 };
    }

    cp_diffX: coverpoint diffX {
      bins in_bound = { [0:15] };
      bins out_bound = { [16:31] };
    }

  endgroup

  function new(string name = "coverage_reporter", uvm_component parent);
    super.new(name, parent);
    in_bt_cg = new();
    in_sc_cg = new();
    out_cg = new();
    in_export = new("in_export", this);
    output_export = new("output_export", this);
  endfunction

  virtual function void write_in(screen_button_transaction trans);
    in_bt_cg.sample(trans.bt_trans.in, trans.rst_trans.rst);
    in_sc_cg.sample(trans.sc_trans.screenX, trans.sc_trans.screenDone);
  endfunction

  virtual function void write_out(paddle_transaction trans);
    out_cg.sample(trans.paddleY, trans.inbound, trans.diffX);
  endfunction

  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    in_sc_coverage = in_sc_cg.get_inst_coverage();
    in_bt_coverage = in_bt_cg.get_inst_coverage();
    out_coverage = out_cg.get_inst_coverage();
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COV_REPORT", $sformatf("input and reset coverage: %0f", in_bt_coverage), UVM_LOW)
    `uvm_info("COV_REPORT", $sformatf("screen index and update coverage: %0f", in_sc_coverage), UVM_LOW)
    `uvm_info("COV_REPORT", $sformatf("out coverage: %0f", out_coverage), UVM_LOW)
  endfunction
endclass
