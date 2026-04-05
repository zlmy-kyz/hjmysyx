module encode83 (
    input [7:0] in,
    input en,
    output reg [6:0] out_seg
);
    wire [1:0] h_out;
    wire [1:0] l_out;
    wire high_valid;
    reg [2:0] out;
    encode42 high_encode(
        .in(in[7:4]),
        .en(en),
        .out(h_out)
    );
    encode42 low_encode(
        .in(in[3:0]),
        .en(en),
        .out(l_out)
    );
    assign high_valid = (in[7:4] != 4'b0000);
    always@(*) begin
        if(en) begin
            if (high_valid) begin
                out = {1'b1, h_out};
            end
            else begin
                out = {1'b0, l_out};
            end
        end
        else out = 0;
    end

    bcd7seg seg1(
        .in({1'b0, out}),
        .out(out_seg)
    );
    
endmodule
