`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2026 16:45:09
// Design Name: 
// Module Name: zero_flag
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module zero_flag (
    input  [7:0] SUM_WR,
    output       zero_flag_en
);
    assign zero_flag_en = ~(SUM_WR[7] |
                            SUM_WR[6] |
                            SUM_WR[5] |
                            SUM_WR[4] |
                            SUM_WR[3] |
                            SUM_WR[2] |
                            SUM_WR[1] |
                            SUM_WR[0]);
endmodule
