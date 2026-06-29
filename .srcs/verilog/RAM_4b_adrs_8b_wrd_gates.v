`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 14:27:06
// Design Name: 
// Module Name: RAM_4b_adrs_8b_wrd_gates
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

module RAM_4b_adrs_8b_wrd_gates(
    input [3:0] ADDRS_4,
    input [7:0] DATA_8,
    input RAM_IN, clk, MEM_REG_IN, Reset,
    output reg [7:0] OUT
);


wire [3:0] bus_4;
wire [15:0] dec_out;  // Active HIGH decoder outputs
wire [15:0] write_en; // Write enables for each location
// Existing address register
mem_register_4_bit MEMORY_REG(
    .Bus_4(ADDRS_4),
    .CLK(clk),
    .ENABLE(MEM_REG_IN),
    .RESET(Reset),
    .DATA_4(bus_4));


decoder_4_to_16 Decode (
    .IN_4(bus_4),
    .OUT_16(dec_out)
);

// Write enables: decoder AND write signal
genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : write_gates
        assign write_en[i] = dec_out[i] & RAM_IN;
    end
endgenerate

// 16 locations × 8-bit registers (raw DFFs, no array)
reg [7:0] mem_0, mem_1, mem_2, mem_3, mem_4, mem_5, mem_6, mem_7;
reg [7:0] mem_8, mem_9, mem_10, mem_11, mem_12, mem_13, mem_14, mem_15;



// Write to each register (gated clock equivalent via enable)
always @(posedge clk) begin
    if (Reset) begin
        mem_0 <= 8'h00; 
        mem_1 <= 8'h00;
        mem_2 <= 8'h00;
        mem_3 <= 8'h00;
        mem_4 <= 8'h00;
        mem_5 <= 8'h00;
        mem_6 <= 8'h00;
        mem_7 <= 8'h00;
        mem_8 <= 8'h00;
        mem_9 <= 8'h00;
        mem_10 <= 8'h00;
        mem_11 <= 8'h00;
        mem_12 <= 8'h00;
        mem_13 <= 8'h00;
        mem_14 <= 8'h00;
        mem_15 <= 8'h00;
    end else begin
        if (write_en[0]) mem_0 <= DATA_8;
        if (write_en[1]) mem_1 <= DATA_8;
        if (write_en[2]) mem_2 <= DATA_8;
        if (write_en[3]) mem_3 <= DATA_8;
        if (write_en[4]) mem_4 <= DATA_8;
        if (write_en[5]) mem_5 <= DATA_8;
        if (write_en[6]) mem_6 <= DATA_8;
        if (write_en[7]) mem_7 <= DATA_8;
        if (write_en[8]) mem_8 <= DATA_8;
        if (write_en[9]) mem_9 <= DATA_8;
        if (write_en[10]) mem_10 <= DATA_8;
        if (write_en[11]) mem_11 <= DATA_8;
        if (write_en[12]) mem_12 <= DATA_8;
        if (write_en[13]) mem_13 <= DATA_8;
        if (write_en[14]) mem_14 <= DATA_8;
        if (write_en[15]) mem_15 <= DATA_8;
    end
end

// Read: 16-to-1 MUX using gates/case (synthesis to mux, no ROM)
always @(*) begin
    
    case (dec_out)
        16'b0000000000000001:  OUT = mem_0;
        16'b0000000000000010:  OUT = mem_1;
        16'b0000000000000100:  OUT = mem_2;
        16'b0000000000001000:  OUT = mem_3;
        16'b0000000000010000:  OUT = mem_4;
        16'b0000000000100000:  OUT = mem_5;
        16'b0000000001000000: OUT = mem_6;
        16'b0000000010000000: OUT = mem_7;
        16'b0000000100000000:  OUT = mem_8;
        16'b0000001000000000:  OUT = mem_9;
        16'b0000010000000000:  OUT = mem_10;
        16'b0000100000000000:  OUT = mem_11;
        16'b0001000000000000:  OUT = mem_12;
        16'b0010000000000000:  OUT = mem_13;
        16'b0100000000000000:  OUT = mem_14;
        16'b1000000000000000:  OUT = mem_15;
        
        default: OUT = 8'h00;
    endcase
end



always @(posedge clk) begin
    $display(
        "ADDRS_4=%h bus_4=%h dec_out=%b RAM_IN=%b",
        ADDRS_4,
        bus_4,
        dec_out,
        RAM_IN
    );
  
end



reg [7:0] init_mem [0:15];
//integer j;

//always @(posedge clk) begin
//    for (j=0; j<16; j=j+1)
//        $display("init_mem[%0d] = %h", j, init_mem[j]);
//end

initial begin
//    $readmemh("lookup_table.mem", init_mem);
//    $readmemh("lookup_table_extra_instrc.mem", init_mem);
    $readmemh("ram_1.mem", init_mem);

//    $display(init_mem);
    #40 
    mem_0  = init_mem[0];
    mem_1  = init_mem[1];
    mem_2  = init_mem[2];
    mem_3  = init_mem[3];
    mem_4  = init_mem[4];
    mem_5  = init_mem[5];
    mem_6  = init_mem[6];
    mem_7  = init_mem[7];

    mem_8  = init_mem[8];
    mem_9  = init_mem[9];
    mem_10 = init_mem[10];
    mem_11 = init_mem[11];
    mem_12 = init_mem[12];
    mem_13 = init_mem[13];
    mem_14 = init_mem[14];
    mem_15 = init_mem[15];
end
endmodule

