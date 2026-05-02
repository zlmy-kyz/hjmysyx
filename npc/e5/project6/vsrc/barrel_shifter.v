module barrel_shifter8(
    input shift,//1为算术，0为逻辑
    input dir,//1为左移，0为右移
    input [2:0]sel,
    inout [7:0] in,
    output reg [7:0] out
);
endmodule