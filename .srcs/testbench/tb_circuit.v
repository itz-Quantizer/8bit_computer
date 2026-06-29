`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 20:42:29
// Design Name: 
// Module Name: tb_circuit
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


module tb_circuit();   
    // Clock and control signals
    reg clock;
    wire clock_not;
    reg halt;
    wire internal_reset;
    
    // Data bus and display
    wire [7:0] BUS, Display_out;
    wire DISPLAY_OUTPUT;
    
    // Memory signals
    wire [7:0] ram_output, DATA_A, DATA_B, SUM_WR;
    
    // Control and sequencing
    wire [2:0] step;
    wire [7:0] code_l, code_h;
    wire [3:0] Prog_counter, Operation_code;
    
    // Control signals
    wire LOAD_OUT_D_A, RAM_IN;
    wire PC_LOAD_OUT, MEM_REG_IN, RAM_OUT, INSTRUCT_LOAD_IN;
    wire PC_EN, INSTRUCT_LOAD_OUT;
    wire LOAD_IN_D_A, LOAD_IN_D_B, SUBTRACT;
    wire SUM_OUT;  // Added missing SUM_OUT declaration
    wire Flag_reg_carry,Flag_reg_zero;
    
    // Instantiate the circuit under test
    circuit byte_computer(
        .CLK(clock),.Flag_reg_carry(Flag_reg_carry),
        .DISP_OUT(Display_out),
        .DISPLAY_OUTPUT(DISPLAY_OUTPUT),
        .RESET(halt),
        .internal_reset(internal_reset),
        .BUS_PORT(BUS),
        .OP_CODE(Operation_code),
        .control_l(code_l),
        .control_h(code_h),
        .RAM_OUT(RAM_OUT),
//        .temp_ram_out(temp_ram_out),
        .step(step),
        .RAM_WR(ram_output),
        .PC_WR(Prog_counter),
        .INSTRUCT_LOAD_IN(INSTRUCT_LOAD_IN),
        .MEM_REG_IN(MEM_REG_IN),
        .PC_LOAD_OUT(PC_LOAD_OUT),
        .clock_not(clock_not),
        .PC_EN(PC_EN),
        .INSTRUCT_LOAD_OUT(INSTRUCT_LOAD_OUT),
        .LOAD_IN_D_A(LOAD_IN_D_A),
        .SUBTRACT(SUBTRACT),
        .SUM_OUT(SUM_OUT),
        .LOAD_IN_D_B(LOAD_IN_D_B),
        .LOAD_OUT_D_A(LOAD_OUT_D_A),
        .RAM_IN(RAM_IN),
        .SUM_WR(SUM_WR),
        .DATA_A(DATA_A),
        .DATA_B(DATA_B),.Flag_reg_zero(Flag_reg_zero)
    );

    // Cycle counter
    integer cycle_count = 0;
    
    // Time format setup
    initial begin
        $timeformat(-9, 1, " ns", 10);
    end
    
    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
    
    // Reset sequence
    initial begin
        halt = 1;
        #40;
        halt = 0;
//        #700;
//            #72500
            #1
        wait (internal_reset==1'b1);
       #5
        $finish;
    end
    
    // Cycle counter
    always @(posedge clock or posedge halt) begin
        if (halt) begin
            cycle_count <= 0;
        end else begin
            cycle_count <= cycle_count + 1;
        end
    end
    
    
    // Monitor control signal changes
    always @(PC_LOAD_OUT) begin
        $display("→ CONTROL CHANGE at %t: PC_LOAD_OUT = %b", $time, PC_LOAD_OUT);
    end
    
    always @(MEM_REG_IN) begin
        $display("→ CONTROL CHANGE at %t: MEM_REG_IN = %b", $time, MEM_REG_IN);
    end
    
    always @(INSTRUCT_LOAD_IN) begin
        $display("→ CONTROL CHANGE at %t: INSTRUCT_LOAD_IN = %b", $time, INSTRUCT_LOAD_IN);
    end
    
    always @(LOAD_IN_D_A) begin
        $display("→ CONTROL CHANGE at %t: LOAD_IN_D_A = %b", $time, LOAD_IN_D_A);
    end
    
    always @(LOAD_OUT_D_A) begin
        $display("→ CONTROL CHANGE at %t: LOAD_OUT_D_A = %b", $time, LOAD_OUT_D_A);
    end
    
    always @(LOAD_IN_D_B) begin
        $display("→ CONTROL CHANGE at %t: LOAD_IN_D_B = %b", $time, LOAD_IN_D_B);
    end
    
    always @(RAM_IN) begin
        $display("→ CONTROL CHANGE at %t: RAM_IN = %b", $time, RAM_IN);
    end
    
    always @(RAM_OUT) begin
        $display("→ CONTROL CHANGE at %t: RAM_OUT = %b", $time, RAM_OUT);
    end
    
    always @(SUM_OUT or SUBTRACT) begin
        $display("→ ALU CHANGE at %t: SUM_OUT = %b, SUBTRACT = %b", $time, SUM_OUT, SUBTRACT);
    end
    
    // Monitor instruction changes
    always @(Operation_code) begin
        case(Operation_code)
            4'b0000: $display("★ INSTRUCTION: NOP at %t ★", $time);
            4'b0001: $display("★ INSTRUCTION: LOAD at %t ★", $time);
            4'b0010: $display("★ INSTRUCTION: ADD at %t ★", $time);
            4'b0011: $display("★ INSTRUCTION: SUBTRACT at %t ★", $time);
            4'b1110: $display("★ INSTRUCTION: DISPLAY at %t ★", $time);
            4'b1111: $display("★ INSTRUCTION: HALT at %t ★", $time);
            default: $display("★ INSTRUCTION: UNKNOWN (0x%0h) at %t ★", Operation_code, $time);
        endcase
    end
    
    // Monitor step changes
    always @(step) begin
        $display("◆ MICRO-INSTRUCTION STEP: %0d at %t ◆", step, $time);
    end
    
    // Monitor data register changes
    always @(DATA_A) begin
        $display("◆ DATA_A CHANGED: %b (%0d) at %t ◆", DATA_A, DATA_A, $time);
    end
    
    always @(DATA_B) begin
        $display("◆ DATA_B CHANGED: %b (%0d) at %t ◆", DATA_B, DATA_B, $time);
    end
    
    always @(SUM_WR) begin
        $display("◆ SUM_WR CHANGED: %b (%0d) at %t ◆", SUM_WR, SUM_WR, $time);
    end
    
    // Monitor bus changes
    always @(BUS) begin
        $display("◆ BUS CHANGED: %b (%0d, 0x%0h) at %t ◆", BUS, BUS, BUS, $time);
    end
    
    // Monitor display changes
    always @(Display_out) begin
        $display("◆ DISPLAY_OUT CHANGED: %b (%0d, 0x%0h) at %t ◆", Display_out, Display_out, Display_out, $time);
    end
    
    // Dump waveforms
    initial begin
        $dumpfile("tb_circuit.vcd");
        $dumpvars(0, tb_circuit);
    end
    
    // Final summary on halt
    always @(posedge halt) begin
        $display("");
        $display("╔══════════════════════════════════════════════════════════════════════════╗");
        $display("║                          SIMULATION HALTED                               ║");
        $display("╠══════════════════════════════════════════════════════════════════════════╣");
        $display("║  Final PC Value:     %0d (0x%0h)                                        ║", Prog_counter, Prog_counter);
        $display("║  Final Display:      %0d (0x%0h)                                        ║", Display_out, Display_out);
        $display("║  Final BUS Value:    %0d (0x%0h)                                        ║", BUS, BUS);
        $display("║  Total Cycles:       %0d                                                ║", cycle_count);
        $display("╚══════════════════════════════════════════════════════════════════════════╝");
        $display("");
    end

endmodule