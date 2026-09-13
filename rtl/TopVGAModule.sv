`include "rtl/Synchronizer.sv"
`include "rtl/Debouncer.sv"
`include "rtl/GraphicsManager.sv"
`include "rtl/VGATiming.sv"

module topVGAModule
(
    input logic clk,
    input logic rst,

    output logic [1:0] outR,
    output logic [1:0] outG,
    output logic [1:0] outB,

    output logic hsync,
    output logic vsync,

    input logic input1,
    input logic input2
);

//Synchronisation wires
logic synchronizedReset;
logic synchronizedInput1;
logic synchronizedInput2;

//Debouncing wires
logic debouncedInput1;
logic debouncedInput2;

//Screen logic
logic signed [10:0] screenXReg = 0;
logic signed [10:0] screenYReg = 0;
logic screenDone;

//Output wires (feed into register)
logic [1:0] graphicsR;
logic [1:0] graphicsG;
logic [1:0] graphicsB;

logic timingHSync;
logic timingVSync;

//Output Registers
logic [1:0] rReg = 0;
logic [1:0] gReg = 0;
logic [1:0] bReg = 0;

logic hSyncReg = 0;
logic vSyncReg = 0;

synchronizer #(.DEFAULT(1)) resetSynchronizer (
    .clk(clk),
    .rst(rst),
    .in(rst),
    .out(synchronizedReset)
);

//----------------------Use Synchronized Reset----------------------

//Synchronizers
synchronizer #(.DEFAULT(0)) input1Synchronizer(
    .clk(clk),
    .rst(synchronizedReset),
    .in(input1),
    .out(synchronizedInput1)
);

synchronizer #(.DEFAULT(0)) input2Synchronizer (
    .clk(clk),
    .rst(synchronizedReset),
    .in(input2),
    .out(synchronizedInput2)
);

//Debouncers
debouncer #(.SIZE(19)) input1Debouncer (
    .clk(clk),
    .rst(synchronizedReset),

    .in(synchronizedInput1),
    .out(debouncedInput1)
);

debouncer #(.SIZE(19)) input2Debouncer (
    .clk(clk),
    .rst(synchronizedReset),

    .in(synchronizedInput2),
    .out(debouncedInput2)
);

//Graphics
graphicsManager gpu (
    .clk(clk),
    .rst(synchronizedReset),

    .outR(graphicsR),
    .outG(graphicsG),
    .outB(graphicsB),

    .screenX(screenXReg),
    .screenY(screenYReg),

    .screenDone(screenDone),

    .input1(synchronizedInput1),
    .input2(synchronizedInput2)
);

//Timing
VGATiming timingModule (
    .screenX(screenXReg),
    .screenY(screenYReg),

    .hsync(timingHSync),
    .vsync(timingVSync)
);

//Counter logic
always_comb begin
    screenDone = (screenYReg == 524);

    //Output
    outR = rReg;
    outG = gReg;
    outB = bReg;
    
    hsync = hSyncReg;
    vsync = vSyncReg;
end

always_ff @(posedge clk or negedge synchronizedReset) begin
    if (synchronizedReset) begin
        screenXReg <= 0;
        screenYReg <= 0;
    end else begin
        //Default assignment
        screenXReg <= screenXReg + 1;
        //Loop back to zero and then increment screenY
        if (screenXReg == 799) begin
            screenXReg <= 0;
            screenYReg <= screenYReg + 1;
            if (screenYReg == 524) begin
                screenYReg <= 0;
            end 
        end

        //Registered output
        rReg <= graphicsR;
        gReg <= graphicsG;
        bReg <= graphicsB;
        
        hSyncReg <= timingHSync;
        vSyncReg <= timingVSync;
    end
end

endmodule