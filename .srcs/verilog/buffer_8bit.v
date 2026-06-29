`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 14:28:01
// Design Name: 
// Module Name: buffer_8bit
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



module buffer_8bit(IN, ENABLE, OUT);
    input [7:0] IN;
    input ENABLE;
    output [7:0] OUT;
    
    assign  OUT = ENABLE ? IN : 8'bz;
    
endmodule