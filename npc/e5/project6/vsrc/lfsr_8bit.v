module lfsr_8bit(
    input clk,
    input rst,
    input en,
    output reg [6:0] seg0,
    output reg [6:0] seg1
);
reg [7:0] reg_out;
// 异或反馈标志：x4 ^ x3 ^ x2 ^ x0
wire xor_flag;
assign xor_flag = reg_out[4] ^ reg_out[3] ^ reg_out[2] ^ reg_out[0];

always @(posedge clk or posedge rst) begin
    if(rst)
        reg_out <= 8'b00000001; // 禁止全0初始态
    else
        if(en)
            reg_out <= {xor_flag, reg_out[7:1]}; // 右移，最高位补异或标志
end
bcd7seg u_seg0 (.in(reg_out[3:0]), .out(seg0));
bcd7seg u_seg1 (.in(reg_out[7:4]), .out(seg1));

endmodule