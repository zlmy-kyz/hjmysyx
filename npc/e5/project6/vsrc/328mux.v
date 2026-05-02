module 328mux(
    input [8:0] in,
    input [2:0] sel,
    output out
);
    always@(*) begin
        out = in[sel];
    end
endmodule