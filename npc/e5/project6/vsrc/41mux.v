module 41mux(
    input [3:0] in,
    input [1:0] sel,
    output out
);
    always@(*) begin
        out = in[sel];
    end
endmodule