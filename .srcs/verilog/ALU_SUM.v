`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 17:02:32
// Design Name: 
// Module Name: ALU_SUM
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

module ALU_SUM(A, B, SUBTRACTION, SUM, C_OUT);
    input [7:0] A, B;
    input SUBTRACTION;
    output [7:0] SUM;
    output C_OUT;
    
    // 1. Scrubbing Function: Converts any 'z' to '0'
    function [7:0] clean_z;
        input [7:0] val;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                clean_z[i] = (val[i] === 1'bz) ? 1'b0 : val[i];
            end
        end
    endfunction

    wire Carry_intermediate;
    
    // 2. Intercept and clean B BEFORE the XOR operation
    wire [7:0] safe_B = clean_z(B);
    wire [7:0] XOR_B = safe_B ^ {8{SUBTRACTION}};
    
    // (Optional but recommended): You can also pass clean_z(A) here 
    // just to be completely safe, even though your adder scrubs it internally.
    
    carry_look_ahead_adder low_adder (
        .A(A[3:0]), 
        .B(XOR_B[3:0]),
        .C_IN(SUBTRACTION),
        .OUT(SUM[3:0]),
        .C_OUT(Carry_intermediate)
    );
    
    carry_look_ahead_adder high_adder (
        .A(A[7:4]),
        .B(XOR_B[7:4]),
        .C_IN(Carry_intermediate),
        .OUT(SUM[7:4]),
        .C_OUT(C_OUT)
    );
    
endmodule
