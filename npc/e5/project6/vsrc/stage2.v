module stage2 (
    input  [7:0] din,
    input        L_R,
    input        A_L,
    input        shamt1,
    output [7:0] dout
);

wire fill;
mux2_1 u_fill (.i0(1'b0), .i1(din[7]), .sel(A_L), .out(fill));

genvar i;
generate
    for (i = 0; i < 8; i = i+1) begin : s2
        wire i0 = din[i];
        wire i2 = din[i];

        wire i3;
        if (i >= 2) assign i3 = din[i-2];
        else assign i3 = 1'b0;

        wire i1;
        if (i >= 6) assign i1 = fill;
        else assign i1 = din[i+2];

        mux4_1 u_mux (
            .i0(i0), .i1(i1), .i2(i2), .i3(i3),
            .sel0(shamt1), .sel1(L_R),
            .out(dout[i])
        );
    end
endgenerate
endmodule