//////////////////////////////////////////////////////////////////////////////////
// Engineer: XiGua
// 
// Create Date: 2021/04/28 18:55:02
// Module Name: manchest_incode
// Target Devices: ALL Xilinx FPGA
// Tool Versions: V1.0
// Description: Incoding the manchest code.
// 
//////////////////////////////////////////////////////////////////////////////////

module manchest_incode(
    input           data_clk,           //Indicating the date rate.
    input           org_data,           //Indicating the date.
    input           data_pos_or_neg,    //Select when the data will change.  
                                        //1:data will change when the "data_clk" is falling edge.
                                        //0:data will change when the "data_clk" is rising edge.
    input           en,                 //When this pin is high, the module will active.

    output wire     man_incode_data
    );
    
    wire            tempman_incode_data;

    assign man_incode_data = en & (((data_pos_or_neg) ? (~(data_clk ^ org_data)) : (data_clk ^ org_data)));
    
endmodule
