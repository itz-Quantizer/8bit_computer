`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.01.2026 19:44:41
// Design Name: 
// Module Name: data_register
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

module data_register(
    input [7:0] Bus_8,
    input CLK,
    input ENABLE,
    input RESET,
    output reg [7:0] DATA_8
);

always @(posedge CLK) begin
    if (RESET)
        DATA_8 <= 8'b00000000;
    else if (ENABLE)
        DATA_8 <= Bus_8;
end

endmodule
