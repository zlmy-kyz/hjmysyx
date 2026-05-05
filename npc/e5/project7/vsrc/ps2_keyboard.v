module ps2_keyboard(
    input clk,
    input rst,
    input ps2_clk,
    input ps2_data,
    output reg [6:0] seg0,
    output reg [6:0] seg1,
    output reg [6:0] seg2,
    output reg [6:0] seg3,
    output reg [6:0] seg4,
    output reg [6:0] seg5
);

    reg [9:0] buffer;        // ps2_data bits
    reg [3:0] count;  // count ps2_data bits
    reg [2:0] ps2_clk_sync;
    reg [23:0] seg_buffer; // buffer for 6 7-seg displays

    always @(posedge clk) begin
        ps2_clk_sync <=  {ps2_clk_sync[1:0],ps2_clk};
    end

    wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

    always @(posedge clk) begin
        if (rst == 0) begin // reset
            count <= 0;
        end
        else begin
            if (sampling) begin
              if (count == 4'd10) begin
                if ((buffer[0] == 0) &&  // start bit
                    (ps2_data)       &&  // stop bit
                    (^buffer[9:1])) begin      // odd  parity
                    $display("receive %x", buffer[8:1]);
                end
                count <= 0;     // for next
              end else begin
                buffer[count] <= ps2_data;  // store ps2_data
                count <= count + 3'b1;
              end
            end
        end
    end
    always @(posedge clk) begin
        if (rst == 0) begin
            seg_buffer <= 0;
        end 
        else begin
            if (sampling) begin
                if (count == 4'd10) begin
                    if ((buffer[0] == 0) &&  // start bit
                        (ps2_data)       &&  // stop bit
                        (^buffer[9:1])) begin      // odd  parity
                        seg_buffer <= {seg_buffer[15:0], buffer[8:1]}; // shift in new data
                    end
                end
            end
        end
    end
    bcd7seg seg0_dec(.in(seg_buffer[3:0]), .out(seg0));
    bcd7seg seg1_dec(.in(seg_buffer[7:4]), .out(seg1));
    bcd7seg seg2_dec(.in(seg_buffer[11:8]), .out(seg2));
    bcd7seg seg3_dec(.in(seg_buffer[15:12]), .out(seg3));
    bcd7seg seg4_dec(.in(seg_buffer[19:16]), .out(seg4));
    bcd7seg seg5_dec(.in(seg_buffer[23:20]), .out(seg5));


endmodule