module encode42(  
    input [3:0] in,
    input en,
    output reg [1:0] out);
    integer  i;
    always @(in or en) begin
        if (en) begin
            out = 0;
            for( i = 0; i <= 3; i = i+1)
                if(in[i] == 1)  out = i[1:0];
        end
        else  out = 0;
    end
endmodule
