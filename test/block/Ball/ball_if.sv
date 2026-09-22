interface ball_if (
    input logic clk
);

  logic in;//Not used, added for driver reuse
  logic rst;

  logic screenDone; //Not the same as the ball interface, renamed to be consistant with screen driver
  

  logic signed [10:0] screenX;
  logic signed [10:0] screenY;

  logic signed [10:0] paddleLeftY;
  logic signed [10:0] paddleRightY;

  logic inbound;

  logic outLeftBound;
  logic outRightBound;

    clocking driver_cb @(posedge clk);
        input inbound, outLeftBound, outRightBound;
        output screenX, screenY, screenDone, paddleLeftY, paddleRightY, in;
        inout rst;
    endclocking

    clocking monitor_cb @(posedge clk);
        input rst, screenX, screenY, screenDone, paddleLeftY, paddleRightY, inbound, outLeftBound, outRightBound,in;
    endclocking

endinterface
