`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 14:37:37
// Design Name: 
// Module Name: decoder_4_to_16
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



// Active HIGH decoder (replace your active-low version)
module decoder_4_to_16(IN_4, OUT_16);
    input [3:0] IN_4;
    output [15:0] OUT_16;
    
       
assign OUT_16[15] = (IN_4[3] &  IN_4[2] &  IN_4[1] &  IN_4[0]);
assign OUT_16[14] = (IN_4[3] &  IN_4[2] &  IN_4[1] & ~IN_4[0]);
assign OUT_16[13] = (IN_4[3] &  IN_4[2] & ~IN_4[1] &  IN_4[0]);
assign OUT_16[12] = (IN_4[3] &  IN_4[2] & ~IN_4[1] & ~IN_4[0]);
assign OUT_16[11] = (IN_4[3] & ~IN_4[2] &  IN_4[1] &  IN_4[0]);
assign OUT_16[10] = (IN_4[3] & ~IN_4[2] &  IN_4[1] & ~IN_4[0]);
assign OUT_16[9]  = (IN_4[3] & ~IN_4[2] & ~IN_4[1] &  IN_4[0]);
assign OUT_16[8]  = (IN_4[3] & ~IN_4[2] & ~IN_4[1] & ~IN_4[0]);
assign OUT_16[7]  = (~IN_4[3] &  IN_4[2] &  IN_4[1] &  IN_4[0]);
assign OUT_16[6]  = (~IN_4[3] &  IN_4[2] &  IN_4[1] & ~IN_4[0]);
assign OUT_16[5]  = (~IN_4[3] &  IN_4[2] & ~IN_4[1] &  IN_4[0]);
assign OUT_16[4]  = (~IN_4[3] &  IN_4[2] & ~IN_4[1] & ~IN_4[0]);
assign OUT_16[3]  = (~IN_4[3] & ~IN_4[2] &  IN_4[1] &  IN_4[0]);
assign OUT_16[2]  = (~IN_4[3] & ~IN_4[2] &  IN_4[1] & ~IN_4[0]);
assign OUT_16[1]  = (~IN_4[3] & ~IN_4[2] & ~IN_4[1] &  IN_4[0]);
assign OUT_16[0]  = (~IN_4[3] & ~IN_4[2] & ~IN_4[1] & ~IN_4[0]);

endmodule
