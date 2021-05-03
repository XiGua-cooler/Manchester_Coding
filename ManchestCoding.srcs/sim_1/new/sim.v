`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: XiGua
// 
// Create Date: 2021/04/28 20:37:21
// Module Name: testbench
// Target Devices: ALL Xilinx FPGA
// Tool Versions: V1.0
//////////////////////////////////////////////////////////////////////////////////


module sim();

reg                 clk_50MHz;
reg                 data_clk; //1MHz
reg                 org_data;
reg                 reset;
reg[15:0]           data;
reg                 en_incode;
reg                 en_decode;
reg[4:0]            cnt;

wire                coding_data;
wire                decode_data;
wire                decode_data_clk;

initial begin
    clk_50MHz = 0;
    reset = 1;
    org_data  = 0;
    data_clk = 0;
    en_incode = 0;
    en_decode = 0;
    data = 16'b0011_1010_0001_1110;
    cnt = 5'd0;
    #20
    reset = 0;
    #20
    reset = 1;
    en_incode = 1;
    #300
    en_decode = 1;
end

always #10   clk_50MHz = ~clk_50MHz;
always #500  data_clk = ~data_clk;
always @(negedge data_clk) begin
        org_data <= data[0];
        data <= data >> 1;
end

top u1(
//input
.board_clk(clk_50MHz),
.data_clk(data_clk),
.board_reset(reset),
.org_data(org_data),
.en_incode(en_incode),
.en_decode(en_decode),
//output
.coding_data(coding_data),
.decoding_data(decode_data),
.decoding_data_clk(decode_data_clk)
);


endmodule
