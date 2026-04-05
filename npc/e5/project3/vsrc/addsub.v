module addsub (
    input signed [3:0] a,
    input signed [3:0] b,
    input cin, // 0 for add, 1 for sub
    output signed [3:0] result,
    output carry,// cin=0,1为加法进位或cin=1,0为减法借位
    output overflow,//是否溢出
    output zero//结果是否为0
);
    wire [3:0] xor_b;
    assign xor_b = {4{cin}} ^ b;
    assign {carry, result[3:0]} = a + xor_b + cin;
    assign overflow = (a[3] == xor_b[3]) && (result[3] != a[3]);//加法情况，若两个正数相加为负数或两个负数相加为正数，则发生溢出。减法情况，正数减正数，负数减负数不会发生溢出。正数减负数相当于正数加正数，负数减正数相当于负数加负数，跟前面的情况相同。
    assign zero = (result == 4'b0000);

endmodule