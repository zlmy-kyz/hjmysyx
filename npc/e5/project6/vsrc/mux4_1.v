module mux4_1 (
    input  i0,
    input  i1,
    input  i2,
    input  i3,
    input  sel0,  // shamt[x]
    input  sel1,  // L/R
    output reg out
);
    always @(*) begin
        case ({sel1, sel0})
            2'b00: out = i0;
            2'b01: out = i1;
            2'b10: out = i2;
            2'b11: out = i3;
        endcase
    end
endmodule