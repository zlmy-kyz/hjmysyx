module mux328 #(parameter SHIFT = 1) (
    input  [7:0] din,
    input        L_R,    // 1=左 0=右
    input        A_L,    // 1=算术 0=逻辑
    input        en,     // 使能：1=移位，0=不移位
    output [7:0] dout
);

wire sign = din[7];
genvar i;
generate
    for (i = 0; i < 8; i = i+1) begin : stage_bit
        wire orig  = din[i];
        wire left  = (i >= SHIFT) ? din[i - SHIFT] : 1'b0;
        wire logic_r = (i <= 7 - SHIFT) ? din[i + SHIFT] : 1'b0;
        wire arith_r = (i <= 7 - SHIFT) ? din[i + SHIFT] : sign;

        // en=0 → 不移位
        // en=1 → 根据 L_R+A_L 选择移位方式
        mux41 u_mux (
            .in({arith_r, logic_r, left, orig}),
            .sel(en ? {L_R, A_L} : 2'b00), // 关键！
            .out(dout[i])
        );
    end
endgenerate

endmodule