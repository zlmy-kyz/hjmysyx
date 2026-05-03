module stage1 (
    input  [7:0] din,
    input        L_R,
    input        A_L,
    input        shamt0,
    output [7:0] dout
);

wire fill;
mux2_1 u_fill (.i0(1'b0), .i1(din[7]), .sel(A_L), .out(fill));

genvar i;
generate
    for (i = 0; i < 8; i = i+1) begin : s1
        wire i0 = din[i];
        wire i2 = din[i];

        wire i3;
        if (i >= 1) assign i3 = din[i-1];
        else assign i3 = 1'b0;

        wire i1;
        if (i == 7) assign i1 = fill;
        else assign i1 = din[i+1];

        mux4_1 u_mux (
            .i0(i0), .i1(i1), .i2(i2), .i3(i3),
            .sel0(shamt0), .sel1(L_R),
            .out(dout[i])
        );
    end
endgenerate
endmodule