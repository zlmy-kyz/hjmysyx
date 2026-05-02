module shift_register (  //移位寄存器
    input clk,
    input [2:0]sel,
    input [2:0]move,//移多少位
    input en,//上升沿输入串行
    input in_shift,//串行输入
    input [7:0] in,
    output reg [7:0] out
);
    wire en_flag;
    reg en_d;
    reg [3:0] cnt;
    reg [7:0] out_shift;

    always@(posedge clk) begin
        en_d <= en;
    end

    assign en_flag = en & ~en_d;
    
    always @(posedge clk) begin
        case(sel)
            3'b000: begin
                out <= 0;
                en_d <= 0;
                cnt <= 0;
                out_shift <= 0;//清零
            end 
            3'b001: out <= in;//置数
            3'b010: out <= in >> move;//逻辑右移
            3'b011: out <= in << move;//逻辑左移
            3'b100: out <= $signed(in) >>> move;//算术右移
            3'b101: begin //串行转并行
                if(cnt == 4'b1000) begin
                    out <= out_shift;
                    cnt <= 0;
                end
                else if(en_flag) begin
                    out_shift <= {in_shift,out_shift[7:1]};
                    cnt <= cnt + 1;
                end
            end
            3'b110: out <= (in >> move) | (in << (8 - move));//循环右移
            3'b111: out <= (in << move) | (in >> (8 - move));//循环左移
            default: out <= 0;
        endcase
    end

endmodule