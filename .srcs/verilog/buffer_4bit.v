`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 13:32:36
// Design Name: 
// Module Name: buffer_4bit
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



module buffer_4bit(IN, ENABLE, OUT);

    input [3:0] IN;
    input ENABLE;
    output [3:0] OUT;
    
    assign  OUT = ENABLE ? IN : 4'bz;
    
endmodule

