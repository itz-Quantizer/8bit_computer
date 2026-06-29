`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 17:04:46
// Design Name: 
// Module Name: carry_look_ahead_adder
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



//module carry_look_ahead_adder( A,B,C_IN,OUT,C_OUT);
//    input [3:0] A;
//    input [3:0] B;
//    input C_IN;
//    output [3:0] OUT;
//    output C_OUT;

//wire [3:0] PROPAGATION, GENERATION;
//wire [4:0] CARRY;

//// Generate propagate and generate signals
//genvar i;
//generate
//    for (i = 0; i < 4; i = i + 1) begin : pg_loop
//        assign PROPAGATION[i] = A[i] ^ B[i];
//        assign GENERATION[i] = A[i] & B[i];
//    end
//endgenerate

//assign CARRY[0] = C_IN;

//// Parallel carry-lookahead logic (unrolled for true CLA)
//assign CARRY[1] = GENERATION[0] | (PROPAGATION[0] & CARRY[0]);
//assign CARRY[2] = GENERATION[1] | (PROPAGATION[1] & GENERATION[0]) | (PROPAGATION[1] & PROPAGATION[0] & CARRY[0]);
//assign CARRY[3] = GENERATION[2] | (PROPAGATION[2] & GENERATION[1]) | (PROPAGATION[2] & PROPAGATION[1] & GENERATION[0]) | (PROPAGATION[2] & PROPAGATION[1] & PROPAGATION[0] & CARRY[0]);
//assign CARRY[4] = GENERATION[3] | (PROPAGATION[3] & GENERATION[2]) | (PROPAGATION[3] & PROPAGATION[2] & GENERATION[1]) | (PROPAGATION[3] & PROPAGATION[2] & PROPAGATION[1] & GENERATION[0]) | (PROPAGATION[3] & PROPAGATION[2] & PROPAGATION[1] & PROPAGATION[0] & CARRY[0]);

//// Sum bits (using XOR)
//assign OUT[0] = PROPAGATION[0] ^ CARRY[0];
//assign OUT[1] = PROPAGATION[1] ^ CARRY[1];
//assign OUT[2] = PROPAGATION[2] ^ CARRY[2];
//assign OUT[3] = PROPAGATION[3] ^ CARRY[3];

//assign C_OUT = CARRY[4];

//endmodule
 module carry_look_ahead_adder(A, B, C_IN, OUT, C_OUT);
    input [3:0] A;
    input [3:0] B;
    input C_IN;
    output [3:0] OUT;
    output C_OUT;

    // Internal wires to hold the cleaned inputs
    wire [3:0] safe_A;
    wire [3:0] safe_B;
    wire safe_C_IN;

    wire [3:0] PROPAGATION, GENERATION;
    wire [4:0] CARRY;

    // 1. Scrubbing Stage: Convert any 'z' bits to '0'
    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : scrub_loop
            assign safe_A[j] = (A[j] === 1'bz) ? 1'b0 : A[j];
            assign safe_B[j] = (B[j] === 1'bz) ? 1'b0 : B[j];
        end
    endgenerate
    assign safe_C_IN = (C_IN === 1'bz) ? 1'b0 : C_IN;

    // 2. Generate propagate and generate signals (using safe inputs)
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : pg_loop
            assign PROPAGATION[i] = safe_A[i] ^ safe_B[i];
            assign GENERATION[i]  = safe_A[i] & safe_B[i];
        end
    endgenerate

    assign CARRY[0] = safe_C_IN;

    // 3. Parallel carry-lookahead logic (your original unrolled framework)
    assign CARRY[1] = GENERATION[0] | (PROPAGATION[0] & CARRY[0]);
    assign CARRY[2] = GENERATION[1] | (PROPAGATION[1] & GENERATION[0]) | (PROPAGATION[1] & PROPAGATION[0] & CARRY[0]);
    assign CARRY[3] = GENERATION[2] | (PROPAGATION[2] & GENERATION[1]) | (PROPAGATION[2] & PROPAGATION[1] & GENERATION[0]) | (PROPAGATION[2] & PROPAGATION[1] & PROPAGATION[0] & CARRY[0]);
    assign CARRY[4] = GENERATION[3] | (PROPAGATION[3] & GENERATION[2]) | (PROPAGATION[3] & PROPAGATION[2] & GENERATION[1]) | (PROPAGATION[3] & PROPAGATION[2] & PROPAGATION[1] & GENERATION[0]) | (PROPAGATION[3] & PROPAGATION[2] & PROPAGATION[1] & PROPAGATION[0] & CARRY[0]);

    // 4. Sum bits (using XOR)
    assign OUT[0] = PROPAGATION[0] ^ CARRY[0];
    assign OUT[1] = PROPAGATION[1] ^ CARRY[1];
    assign OUT[2] = PROPAGATION[2] ^ CARRY[2];
    assign OUT[3] = PROPAGATION[3] ^ CARRY[3];

    assign C_OUT = CARRY[4];

endmodule   