module clock (
    input rst,
    input en,
    input clk,
    output reg [6:0] seg_one,
    output reg [6:0] seg_ten
);

    reg [25:0] count_clk;
    reg clk_1s;
    reg [3:0] count_one;
    reg [3:0] count_ten;

    always @(posedge clk or posedge rst)begin
        if(rst)begin
            count_clk <= 0;
            clk_1s <= 0;
        end
        else begin
            if(count_clk==20000000)begin
                count_clk <=0;
                clk_1s <= ~clk_1s;
            end
            else begin
                count_clk <= count_clk+1;
            end
        end
    end

    reg clk_1s_d;
    wire clk_1s_posedge = (clk_1s == 1'b1) && (clk_1s_d == 1'b0);

    always @(posedge clk or posedge rst) begin 
        if (rst) begin
            clk_1s_d <= 1'b0; 
        end
        else begin
            clk_1s_d <= clk_1s; 
        end
    end

    always @(posedge clk or posedge rst)begin
        if(rst)begin
            count_one <= 0;
            count_ten <= 0;
        end
        else if(en)begin
            if(clk_1s_posedge)begin
                if(count_one == 9)begin
                    count_one <= 0;
                    if(count_ten == 9)begin
                        count_ten <= 0;
                    end
                    else begin
                        count_ten <= count_ten + 1;
                    end
                end
                else begin
                    count_one <= count_one + 1;
                end
            end
        end
    end

    bcd7seg seg_low(
        .in(count_one),
        .out(seg_one)
    );  

    bcd7seg seg_high(
        .in(count_ten),
        .out(seg_ten)
    );
endmodule