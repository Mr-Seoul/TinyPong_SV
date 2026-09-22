interface paddle_if #(
    parameter PADDLE_SIDE = 0
) (
    input logic clk
);

  logic rst;

  logic screenDone; //Not the same as the paddle interface, renamed to be consistant with screen driver
  logic in; //Not the same as the paddle interface, renamed to be consistant with bit driver

  logic signed [10:0] screenX;
  logic signed [10:0] screenY;

  logic signed [10:0] paddleY;
  logic inbound;
  logic [4:0] diffX;

    clocking driver_cb @(posedge clk);
        input paddleY, inbound, diffX;
        output in, screenX, screenY, screenDone;
        inout rst;
    endclocking

    clocking monitor_cb @(posedge clk);
        input rst, in, screenX, screenY, screenDone, paddleY, inbound, diffX;
    endclocking

endinterface
