`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 14:37:09
// Design Name: 
// Module Name: mem_register_4_bit
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


module mem_register_4_bit(
    input [3:0] Bus_4,
    input CLK,
    input ENABLE,
    input RESET,
    output reg [3:0] DATA_4
);

always @(posedge CLK) begin
    if (RESET)
        DATA_4 <= 4'b0000;
    else if (ENABLE)
        DATA_4 <= Bus_4;
end

endmodule
