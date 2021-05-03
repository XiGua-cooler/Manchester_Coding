//////////////////////////////////////////////////////////////////////////////////
// Engineer: XiGua
// 
// Create Date: 2021/04/30 09:54:23
// Module Name: top
// Target Devices: ALL Xilinx FPGA
// Tool Versions: V1.0
// Description: Test file.
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
    input           board_clk,
    input           data_clk,
    input           board_reset,
    input           org_data,
    input           en_incode,
    input           en_decode,

    output wire     coding_data,
    output wire     decoding_data, 
    output wire     decoding_data_clk
    );

    manchest_incode incode_u1(
    //input
    .data_clk(data_clk),
    .org_data(org_data),
    .data_pos_or_neg(1'b1),
    .en(en_incode), 
    //output  
    .man_incode_data(coding_data)
    );

    manchest_decode decode_u1(
    //input
    .count_clk(board_clk),  
    .data_clk(data_clk),  
    .reset(board_reset),
    .manchest_code(coding_data),
    .en(en_decode),
    .DELATY_COUNTER_TARGET(16'd35),
    //output
    .org_data(decoding_data),
    .org_data_clk(decoding_data_clk)
    );

endmodule
