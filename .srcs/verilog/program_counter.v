`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.01.2026 21:51:06
// Design Name: 
// Module Name: program_counter
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


module program_counter (
    input        clk,
    input        reset,        // active-high: reset=1 -> clear
    input        counter_En,
    input        jump_pc,
    input  [3:0] bus_pc,
    output [3:0] out
);
    reg  [3:0] D_flipflop;
    assign out = D_flipflop;

    // count/toggle logic (unchanged)
    wire and_0 = out[0];
    wire and_1 = out[1] & and_0;
    wire and_2 = out[2] & and_1;

    wire [3:0] count_val = { out[3] ^ and_2,
                             out[2] ^ and_1,
                             out[1] ^ and_0,
                             ~out[0] };

    // ---- THE MUX: picks what the register loads next ----
    wire [3:0] next_val = reset      ? 4'b0000   :   // reset high -> 0
                          jump_pc    ? bus_pc    :   // jump  -> load bus_pc
                          counter_En ? count_val :   // en    -> count up
                                       out;          // else  -> hold

    // single register -> single driver -> no MDRV
    always @(posedge clk) begin
        D_flipflop <= next_val;
    end
endmodule