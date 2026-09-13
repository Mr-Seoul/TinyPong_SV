`include "rtl/Settings.sv"

module ball
(
    input logic clk,
    input logic rst,

    input updateLogic,

    input logic signed [10:0] screenX,
    input logic signed [10:0] screenY,

    input logic signed [10:0] paddleLeftY,
    input logic signed [10:0] paddleRightY,

    output logic inbound,

    output logic signed outLeftBound,
    output logic signed outRightBound
);

//Ball position and speed
logic signed [10:0] ballXReg = 320;
logic signed [10:0] ballYReg = 64;

logic signed [5:0] speedX;
logic signed [5:0] speedY;

logic signed [5:0] ballSpeedReg = $bits(ballSpeedReg)'(settings::ballSpeed);

//Paddle bounds
logic signed [10:0] LeftPaddleLeftBound = $bits(LeftPaddleLeftBound)'(settings::paddleWallDist - settings::paddleWidth);
logic signed [10:0] LeftPaddleRightBound = $bits(LeftPaddleRightBound)'(settings::paddleWallDist + 2*settings::paddleWidth);
logic signed [10:0] LeftPaddleTopBound;
logic signed [10:0] LeftPaddleBottomBound; 

logic signed [10:0] RightPaddleLeftBound = $bits(RightPaddleLeftBound)'(640 - settings::paddleWallDist - settings::paddleWidth - 2*settings::ballRadius);
logic signed [10:0] RightPaddleRightBound = $bits(RightPaddleRightBound)'(640 - settings::paddleWallDist);
logic signed [10:0] RightPaddleTopBound; 
logic signed [10:0] RightPaddleBottomBound; 

//Ball direction
logic goingDownReg = 1;
logic goingRightReg = 1;

logic newDir;

always_comb begin
    //Update speed based on direction
    speedX = goingRightReg ? ballSpeedReg : -ballSpeedReg;
    speedY = goingDownReg ? ballSpeedReg : -ballSpeedReg;

    //Paddle bounds
    LeftPaddleTopBound = $bits(LeftPaddleLeftBound)'(settings::paddleHeight - settings::ballRadius) + paddleLeftY;
    LeftPaddleBottomBound = $bits(LeftPaddleLeftBound)'(settings::ballRadius) + paddleLeftY;

    RightPaddleTopBound = $bits(LeftPaddleLeftBound)'(settings::paddleHeight - settings::ballRadius) + paddleRightY;
    RightPaddleBottomBound = $bits(LeftPaddleLeftBound)'(settings::ballRadius) + paddleRightY;

    //Somewhat chaotic new direction logic
    newDir = ballSpeedReg[1]^ballSpeedReg[0]^goingDownReg^goingRightReg;
end

always_ff @(posedge clk or negedge rst) begin
    if (rst) begin
        //Reset logic
        ballYReg <= 64;
        ballXReg <= 320;
        goingDownReg <= 1;
        goingRightReg <= 1;
        ballSpeedReg <= $bits(ballSpeedReg)'(settings::ballSpeed);
    end else begin
        if (updateLogic) begin
            //Update position
            ballYReg <= ballYReg + speedY;
            ballXReg <= ballXReg + speedX;

            //Bouncing off paddles
            if (!goingRightReg && ballXReg >= LeftPaddleLeftBound && ballXReg <= LeftPaddleRightBound && ballYReg >= LeftPaddleTopBound && ballYReg <= LeftPaddleBottomBound) begin
                goingRightReg <= 1;
                goingDownReg <= newDir;
            end else if (goingRightReg && ballXReg >= RightPaddleLeftBound && ballXReg <= RightPaddleRightBound && ballYReg >= RightPaddleTopBound && ballYReg <= RightPaddleBottomBound) begin
                goingRightReg <= 0;
                goingDownReg <= newDir;
                //Speed up ball (unless it overflows)
                ballSpeedReg <= (ballSpeedReg < (2<<5 -1)) ? ballSpeedReg + 1 : ballSpeedReg;
            end
        end
    end
end

//Inbound logic for screen pixel
logic inSquareX;
logic inSquareY;
logic inSquare;

always_comb begin
    //Check if screenpixel currently is inside the ball
    inSquareX = (screenX >= ballXReg && screenX <= screenX + $bits(screenX)'(2*settings::ballRadius));
    inSquareY = (screenY >= ballYReg && screenY <= screenY + $bits(screenY)'(2*settings::ballRadius));
    inSquare = inSquareX && inSquareY;

    //Output logic
    inbound = inSquare;
    outLeftBound = ballXReg <= 0;
    outRightBound = ballXReg > 640;
end

endmodule