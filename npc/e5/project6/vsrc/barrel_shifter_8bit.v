module barrel_shifter_8bit (
    input  [7:0] din,
    input  [2:0] shamt,
    input        L_R,    // 1=左移 0=右移
    input        A_L,    // 1=算术 0=逻辑
    output [7:0] dout
);

wire [7:0] s1_out, s2_out;

stage1 u1 (.din(din),   .L_R(L_R), .A_L(A_L), .shamt0(shamt[0]), .dout(s1_out));
stage2 u2 (.din(s1_out),.L_R(L_R), .A_L(A_L), .shamt1(shamt[1]), .dout(s2_out));
stage3 u3 (.din(s2_out),.L_R(L_R), .A_L(A_L), .shamt2(shamt[2]), .dout(dout));

endmodule