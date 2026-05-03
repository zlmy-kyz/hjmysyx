module barrel_shifter_8 (
    input  [7:0] din,
    input  [2:0] shamt,   // 移位位数 0~7
    input        L_R,     // 1左 0右
    input        A_L,     // 1算术 0逻辑
    output [7:0] dout
);

wire [7:0] s1, s2;

// 三级移位：shamt 控制每一级是否开启
mux328 #(1) st1 (.din(din),  .L_R(L_R), .A_L(A_L), .en(shamt[0]), .dout(s1));
mux328 #(2) st2 (.din(s1),   .L_R(L_R), .A_L(A_L), .en(shamt[1]), .dout(s2));
mux328 #(4) st3 (.din(s2),   .L_R(L_R), .A_L(A_L), .en(shamt[2]), .dout(dout));

endmodule