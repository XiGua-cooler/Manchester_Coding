//////////////////////////////////////////////////////////////////////////////////
// Engineer: XiGua
// 
// Create Date: 2021/04/28 18:55:02
// Module Name: manchest_decode
// Target Devices: ALL Xilinx FPGA
// Tool Versions: V1.0
// Description: 1.Decoding the manchest code.
//              2.T("A") is the period of "A"
// 
//////////////////////////////////////////////////////////////////////////////////

module manchest_decode(
    input           count_clk,              //Indicating the counter clock rate. 
                                            //Default is 50MHz --> T=20ns
    input           data_clk,               //Indicating the data rate. 
                                            //Default is 1_000_000(Bit/S) --> T=1us
    input           reset,
    input           manchest_code,          //This is the manchest code.
    input           en,                     //When this pin is high, the module will active.
    input[15:0]     DELATY_COUNTER_TARGET,  //T("data_clk")/(T("count_clk")*2) < "DELATY_COUNTER_TARGET" < T("data_clk")/T("count_clk").
                                            //Maximum limit is 65535.

    output reg      org_data,               //This is the orginal data.
    output reg      org_data_clk            //Indicating the sampling clock of the orginal data.
                                            //"org_data" is available when the "org_data_clk" in the state of rising edge.
    );


    reg[1 :0]           state;
    reg[15:0]           counter;
    reg                 edge_clk_0;
    reg                 edge_clk_1;
    reg                 org_clk_tempclk;

    wire                manchest_code_posedge;
    wire                manchest_code_negedge;

    assign              manchest_code_posedge = edge_clk_0 & ~edge_clk_1;
    assign              manchest_code_negedge = edge_clk_1 & ~edge_clk_0;

    //Detecting the posedge and negedge of "manchest_code".
    always @(posedge count_clk or negedge reset) begin
        if(reset == 1'b0)begin
            edge_clk_0 <= 1'b0;
            edge_clk_1 <= 1'b0;
        end
        else begin
            if(en == 1'b1)begin
                edge_clk_1 <= edge_clk_0;
                edge_clk_0 <= manchest_code;
            end
            else begin
                edge_clk_0 <= 1'b0;
                edge_clk_1 <= 1'b0;
            end
        end
    end
    //State machine
    /////////////////////////////////////////////
    //state: 00 ---> Detecting the edge of "manchest_code".
    //state: 01 ---> Counting the delay counter.
    //state: 10,11 ---> Reserved.
    ////////////////////////////////////////////
    always @(posedge count_clk or negedge reset) begin
        if(reset == 1'b0)begin
            state <= 2'b00;
        end
        else begin
            if(en == 1'b1)begin
                case(state)
                    2'b00: begin
                        if(org_clk_tempclk == 1'b1)begin
                            state <= 2'b01;
                            org_data_clk <= 1'b0;
                        end
                        else begin
                            state <= 2'b00;
                            org_data_clk <= 1'b0;
                        end
                    end
                    2'b01: begin
                        if(counter == DELATY_COUNTER_TARGET)begin
                            state <= 2'b00;
                            org_data_clk <= 1'b1;
                        end
                        else begin
                            state <= 2'b01;
                            org_data_clk <= 1'b1;
                        end
                    end
                    default: begin
                        state <= state;
                        org_data_clk <= 1'b0;
                    end
                endcase
            end
            else begin
                state <= 2'b00;
                org_data_clk <= 1'b0;
            end
        end
    end
    //Delay counter
    always @(posedge count_clk or negedge reset) begin
        if(reset == 1'b0)begin
            counter <= 16'd0;
        end
        else begin
            if(en == 1'b1)begin
                if(state == 2'b01)begin
                    if(counter <= DELATY_COUNTER_TARGET)begin
                        counter <= counter + 1'd1;
                    end
                    else begin
                        counter <= 16'd0;
                    end
                end
                else begin
                    counter <= 16'd0;
                end
            end
            else begin
                counter <= 16'd0;
            end
        end
    end
    //Decoding the manchest code.
    always @(posedge count_clk or negedge reset) begin
        if(reset == 1'b0)begin
            org_data <= 1'b0;
            org_clk_tempclk <= 1'b0;
        end
        else begin
            if(en == 1'b1)begin
                if(state == 2'b00)begin
                    if(manchest_code_posedge == 1'b1)begin
                        org_data <= 1'b1;
                        org_clk_tempclk <= 1'b1;
                    end
                    else if(manchest_code_negedge == 1'b1)begin
                        org_data <= 1'b0;
                        org_clk_tempclk <= 1'b1;
                    end
                    else begin
                        org_data <= org_data;
                        org_clk_tempclk <= 1'b0;
                    end
                end
                else begin
                    org_data <= org_data;
                    org_clk_tempclk <= 1'b0;
                end
            end
        end
    end
endmodule
