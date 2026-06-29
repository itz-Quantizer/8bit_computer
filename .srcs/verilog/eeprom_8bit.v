`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 13:43:49
// Design Name: 
// Module Name: eeprom_8bit
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
//module eeprom_8bit (
//    input      [7:0]  ADDR,
//    output reg [7:0]  DATA_OUT
//);

//    reg [7:0] mem [0:255];
//    initial begin
////        $readmemh("microcode_SUBT.mem", mem);
////        $readmemh("microcode_extra_instrc1.mem", mem);
//        $readmemh("microcode_lut0.mem", mem);

//        $display("EEPROM: .mem  file loaded.");
//    end
//    // Pure asynchronous read
//    always @(*) begin
//        DATA_OUT = mem[ADDR];
//    end
//endmodule

module eeprom_8bit #(
    parameter FILE_NAME = "microcode_lut0.mem"
)(
    input  [7:0] ADDR,
    output reg [7:0] DATA_OUT
);

    reg [7:0] mem [0:255];

    initial begin
        $readmemh(FILE_NAME, mem);
        $display("EEPROM: loaded file = %s", FILE_NAME);
    end

    always @(*) begin
        DATA_OUT = mem[ADDR];
    end

endmodule