`include "rtl/Settings.sv"

module paddle
#(
    //Left= 0, Right=1
    parameter PADDLE_SIDE = 0
)
(
    input logic clk,
    input logic rst,

    input updateLogic,
    input logic buttonUp,

    input logic signed [10:0] screenX,
    input logic signed [10:0] screenY,

    output logic signed [10:0] paddleY,
    output logic inbound,

    output logic [4:0] diffX
);

logic signed [10:0] paddleYReg = 240;
logic signed [10:0] paddleXReg = (PADDLE_SIDE) ? $bits(paddleXReg)'(settings::paddleWallDist + settings::paddleWidth) : $bits(paddleXReg)'(640 - settings::paddleWallDist - settings::paddleWidth);

logic signed [5:0] velocityReg = 0;
logic signed [10:0] newYPos;

logic inXSquare;
logic inYSquare;

always_comb begin
    //Paddle logic
    newYPos = paddleYReg + velocityReg;

    //For dithering logic
    diffX = (PADDLE_SIDE) ? paddleXReg - screenX : screenX - paddleXReg;

    //Bound detection
    inXSquare = (diffX <= $bits(diffX)'(settings::paddleWidth));
    inYSquare = (screenY <= $bits(screenY)'(settings::paddleHeight)) && (screenY >= paddleYReg - $bits(screenY)'(settings::paddleHeight));
    inbound = inXSquare && inYSquare;

    //Output
    paddleY = paddleYReg;
end

always_ff @(posedge clk or negedge rst) begin
    if (rst) begin
        paddleYReg <= 240;
        paddleXReg <= (PADDLE_SIDE) ? $bits(paddleXReg)'(settings::paddleWallDist + settings::paddleWidth) : $bits(paddleXReg)'(640 - settings::paddleWallDist - settings::paddleWidth);
        velocityReg <= 0;
    end else begin
        //Gravity Logic
        if (buttonUp) begin
            velocityReg <= -1*$bits(velocityReg)'(settings::paddleJumpSpeed);
        end else if (paddleYReg <= $bits(paddleYReg)'(settings::paddleHeight)) begin
            velocityReg <= $bits(velocityReg)'(settings::paddleGravity);
        end else if (paddleYReg >= 480) begin
            velocityReg <= 0;
        end else begin
            velocityReg <= velocityReg + $bits(velocityReg)'(settings::paddleGravity);
        end

        //Paddle movement logic
        if (newYPos < $bits(newYPos)'(settings::paddleHeight)) begin
            paddleYReg <= $bits(paddleYReg)'(settings::paddleHeight);
        end else if (newYPos > 480) begin
            paddleYReg <= 480;
        end else begin
            paddleYReg <= newYPos;
        end
    end
end

endmodule