module alu(
    input signed [3:0] a,
    input signed [3:0] b,
    input [2:0] sel,//0加法，1减法，2按位取反，3按位与，4按位或，5按位异或，6比较大小，7是否相等
    output reg signed [3:0] result
);
    wire [3:0] addsub_result;
    addsub addsub1(
        .a(a),
        .b(b),
        .cin(sel[0]),
        .result(addsub_result),
        .carry(),
        .overflow(),
        .zero()
    );
    always@(*)begin
        case(sel)
            3'b000: result = addsub_result; // add
            3'b001: result = addsub_result; // sub
            3'b010: result = ~a; // not
            3'b011: result = a & b; // and  
            3'b100: result = a | b; // or
            3'b101: result = a ^ b; // xor
            3'b110: if (a<b) result = 4'b0001; 
                    else result = 4'b0000;
            3'b111: if (a==b) result = 4'b0001; 
                    else result = 4'b0000;
            default: result = 4'b0000;
        endcase

    end
    
endmodule