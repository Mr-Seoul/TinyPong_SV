`include "rtl/GameManager.sv"

module graphicsManager
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
logic valid;

logic [1:0] gameR;
logic [1:0] gameG;
logic [1:0] gameB;

//Game Instantiation
gameManager game (
    .clk(clk),
    .rst(rst),
    .outR(gameR),
    .outG(gameG),
    .outB(gameB),
    .screenX(screenX),
    .screenY(screenY),
    .screenDone(screenDone),
    .input1(input1),
    .input2(input2)
);

always_comb begin
    //Check if on screen
    valid = (screenX < 640) && (screenY < 480);
    
    //If on screen, display game. Otherwise output 0 (VGA protocol)
    outR = (valid) ? gameR : 0; 
    outG = (valid) ? gameG : 0; 
    outB = (valid) ? gameB : 0; 
end

endmodule