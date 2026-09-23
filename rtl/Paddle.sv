`ifndef PADDLE_SV
`define PADDLE_SV

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
logic signed [10:0] paddleX = (PADDLE_SIDE) ? $bits(paddleX)'(640 - settings::paddleWallDist - settings::paddleWidth) : $bits(paddleX)'(settings::paddleWallDist + settings::paddleWidth);

logic signed [5:0] velocityReg = 0;
logic signed [10:0] newYPos;

logic inXSquare;
logic inYSquare;

logic [10:0] tempDiffX;

always_comb begin
    //Paddle logic
    newYPos = $bits(newYPos)'(paddleYReg + velocityReg);

    //For dithering logic
    tempDiffX = (PADDLE_SIDE) ? $bits(tempDiffX)'(paddleX - screenX) :$bits(tempDiffX)'(screenX - paddleX);

    //Bound detection
    inXSquare = (tempDiffX <= $bits(tempDiffX)'(settings::paddleWidth)); //tempDiffX is unsigned, so negative values become very large
    inYSquare = (screenY <= $bits(screenY)'(paddleYReg)) && (screenY >= paddleYReg - $bits(screenY)'(settings::paddleHeight));
    inbound = inXSquare && inYSquare;

    //Output
    diffX = $bits(diffX)'(tempDiffX);
    paddleY = paddleYReg;
end

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        paddleYReg <= 240;
        velocityReg <= 0;
    end else begin
        if (updateLogic) begin
            //Gravity Logic
            velocityReg <= velocityReg + $bits(velocityReg)'(settings::paddleGravity);
            if (buttonUp) begin
                velocityReg <= -1*$bits(velocityReg)'(settings::paddleJumpSpeed);
            end else if (paddleYReg <= $bits(paddleYReg)'(settings::paddleHeight)) begin
                velocityReg <= $bits(velocityReg)'(settings::paddleGravity);
            end else if (paddleYReg >= 480) begin
                velocityReg <= 0;
            end

            //Paddle movement logic
            paddleYReg <= newYPos;
            if (newYPos < $bits(newYPos)'(settings::paddleHeight)) begin
                paddleYReg <= $bits(paddleYReg)'(settings::paddleHeight);
            end else if (newYPos >= 480) begin
                paddleYReg <= 480;
            end 
        end
    end
end

endmodule

`endif