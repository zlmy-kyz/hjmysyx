module mux2_1 (
    input  i0,
    input  i1,
    input  sel,
    output out
);
    assign out = sel ? i1 : i0;
endmodule