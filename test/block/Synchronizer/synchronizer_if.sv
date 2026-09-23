interface synchronizer_if #(
    parameter DEFAULT = 0
) (
    input logic clk
);

  logic rst;
  logic in;
  logic out;

    clocking driver_cb @(posedge clk);
        input out; 
        output in;
        inout rst;
    endclocking

    clocking monitor_cb @(posedge clk);
        input out,rst, in; 
    endclocking

endinterface
