`include "rtl/Ball.sv"
`include "rtl/Paddle.sv"
`include "rtl/Settings.sv"

module gameManager
(
    input logic clk,
    input logic rst,

    output logic [1:0] outR,
    output logic [1:0] outG,
    output logic [1:0] outB,

    input logic signed [10:0] screenX,
    input logic signed [10:0] screenY,

    input logic screenDone,

    input logic input1,
    input logic input2
);

//Ball variables
logic inBall;
logic ballOutLeftBound;
logic ballOutRightBound;

//Paddle variables
logic inLeftPaddle;
logic [10:0] leftPaddleY;
logic [4:0] leftDiffX;

logic inRightPaddle;
logic [10:0] rightPaddleY;
logic [4:0] rightDiffX;

//Game Logic
logic gameOverReg = 0;
logic resetEverything;

//Mischelaneous
logic [4:0] curDiffX;
logic [4:0] baysianDither;
logic dithered;

//Left Paddle
paddle #(.PADDLE_SIDE(0)) leftPaddle (
    .clk(clk),
    .rst(resetEverything),
    .updateLogic(screenDone),
    .buttonUp(input1),
    .screenX(screenX),
    .screenY(screenY),
    .paddleY(leftPaddleY),
    .inbound(inLeftPaddle),
    .diffX(leftDiffX)
);

//Right Paddle
paddle #(.PADDLE_SIDE(1)) rightPaddle (
    .clk(clk),
    .rst(resetEverything),
    .updateLogic(screenDone),
    .buttonUp(input2),
    .screenX(screenX),
    .screenY(screenY),
    .paddleY(rightPaddleY),
    .inbound(inRightPaddle),
    .diffX(rightDiffX)
);

//Ball
ball pongBall (
    .clk(clk),
    .rst(resetEverything),
    .updateLogic(screenDone),
    .screenX(screenX),
    .screenY(screenY),
    .paddleLeftY(leftPaddleY),
    .paddleRightY(rightPaddleY),
    .inbound(inBall),
    .outLeftBound(ballOutLeftBound),
    .outRightBound(ballOutRightBound)
);

always_comb begin
    resetEverything = gameOverReg || rst;

    //Select curDiff
    if (inLeftPaddle) begin
        curDiffX = leftDiffX;
    end else if (inRightPaddle) begin
        curDiffX = rightDiffX;
    end else if (inBall) begin
        curDiffX = 0;
    end else begin
        curDiffX = 0;
    end

    //Colour Selection
    baysianDither = { 1'b0, screenX[0]^screenY[0], screenY[1], screenX[1]^screenY[1], screenY[0]};
    dithered = curDiffX <= baysianDither;
    if (inLeftPaddle) begin
        curDiffX = leftDiffX;
        outR = { dithered , 1'b1};
        outG = 0;
        outB = 0;
    end else if (inRightPaddle) begin
        curDiffX = rightDiffX;
        outR = 0;
        outG = { dithered , 1'b1};
        outB = 0;
    end else if (inBall) begin
        curDiffX = 0;
        outR = 0;
        outG = 2'b11;
        outB = 2'b11;
    end else begin
        //Background Found through experimentation
        curDiffX = 0;
        outR = { 1'b0 , (screenX[5] ^ screenY[5]) ^ (screenX[2] ^ screenY[2]) };
        outG = { 1'b0 , (screenX[4] ^ screenY[4]) ^ (screenX[1] ^ screenY[1]) };
        outB = { 1'b0 , (screenX[3] ^ screenY[3]) ^ (screenX[0] ^ screenY[0]) };
    end
end

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        gameOverReg <= 0;
    end else begin
        gameOverReg <= ballOutLeftBound || ballOutRightBound;
    end
end

endmodule