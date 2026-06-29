`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.06.2026 15:53:47
// Design Name: 
// Module Name: STEP
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
module STEP (
    input wire CLK_bar,
    input RESET,               // assuming active-high reset
    output  [2:0] step_out
);
   
 reg [2:0]D_flipflop;
initial begin 
    D_flipflop <=3'b000;
end
wire [2:0] out;
assign  out =D_flipflop;
wire reset_signal = out[2] & out[1] & ~out[0];
wire and_0 = out[0];
wire and_1 =  out[1] & and_0;
 
 always @( posedge CLK_bar or posedge RESET  )   begin 
        if (RESET) begin
            D_flipflop <= 3'b111;  // Reset condition 
            end
        else if   (reset_signal) begin 
            D_flipflop <= 3'b000;
        end  
        else begin
            D_flipflop[0]<= ~out[0];
            D_flipflop[1]<= out[1] ^(and_0);
            D_flipflop[2]<= out[2] ^(and_1);
            end
         end
      
assign step_out=out;
endmodule



