`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2026 22:10:28
// Design Name: 
// Module Name: microcode_control
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

module microcode_control (
    input  [3:0] OP_CODE,
    input  [2:0] step,
    input        Flag_reg_carry,
    input        Flag_reg_zero,
    output reg [7:0] control_l,
    output reg [7:0] control_h
);

    wire [7:0] eeprom_l_c;
    wire [7:0] eeprom_h_c;

    wire [7:0] eeprom_l_flag_carry;
    wire [7:0] eeprom_h_flag_carry;

    wire [7:0] eeprom_l_z;
    wire [7:0] eeprom_h_z;

    wire [7:0] eeprom_l_flag_zero;
    wire [7:0] eeprom_h_flag_zero;

    eeprom_8bit #(.FILE_NAME("microcode_lut0.mem")) EEPROM_LOW (
        .ADDR({1'b0, OP_CODE, step}),
        .DATA_OUT(eeprom_l_c)
    );

    eeprom_8bit #(.FILE_NAME("microcode_lut0.mem")) EEPROM_HIGH (
        .ADDR({1'b1, OP_CODE, step}),
        .DATA_OUT(eeprom_h_c)
    );

    eeprom_8bit #(.FILE_NAME("microcode_lut1.mem")) EEPROM_LOW_FLAG (
        .ADDR({1'b0, OP_CODE, step}),
        .DATA_OUT(eeprom_l_flag_carry)
    );

    eeprom_8bit #(.FILE_NAME("microcode_lut1.mem")) EEPROM_HIGH_FLAG (
        .ADDR({1'b1, OP_CODE, step}),
        .DATA_OUT(eeprom_h_flag_carry)
    );

    eeprom_8bit #(.FILE_NAME("microcode_lut2.mem")) EEPROM_LOW_ZERO (
        .ADDR({1'b0, OP_CODE, step}),
        .DATA_OUT(eeprom_l_z)
    );

    eeprom_8bit #(.FILE_NAME("microcode_lut2.mem")) EEPROM_HIGH_ZERO (
        .ADDR({1'b1, OP_CODE, step}),
        .DATA_OUT(eeprom_h_z)
    );

    eeprom_8bit #(.FILE_NAME("microcode_lut3.mem")) EEPROM_LOW_FLAG_ZERO (
        .ADDR({1'b0, OP_CODE, step}),
        .DATA_OUT(eeprom_l_flag_zero)
    );

    eeprom_8bit #(.FILE_NAME("microcode_lut3.mem")) EEPROM_HIGH_FLAG_ZERO (
        .ADDR({1'b1, OP_CODE, step}),
        .DATA_OUT(eeprom_h_flag_zero)
    );

    always @(*) begin
        case ({Flag_reg_carry, Flag_reg_zero})
            2'b00: begin
                control_l = eeprom_l_c;
                control_h = eeprom_h_c;
            end

            2'b01: begin
                control_l = eeprom_l_z;
                control_h = eeprom_h_z;
            end

            2'b10: begin
                control_l = eeprom_l_flag_carry;
                control_h = eeprom_h_flag_carry;
            end

            2'b11: begin
                control_l = eeprom_l_flag_zero;
                control_h = eeprom_h_flag_zero;
            end

            default: begin
                control_l = 8'b0;
                control_h = 8'b0;
            end
        endcase
    end

endmodule