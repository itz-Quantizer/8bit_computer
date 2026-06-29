
module circuit(
    input CLK,
    input RESET,
    output wire [7:0] BUS_PORT,//temp_check,
    output [2:0]step ,
    output [3:0]OP_CODE,
    output [3:0]PC_WR,
    output [7:0]control_l,control_h,
    output [7:0] RAM_WR ,//temp_ram_out,
    output wire RAM_OUT, INSTRUCT_LOAD_IN,MEM_REG_IN,PC_LOAD_OUT,
    output SUM_OUT,LOAD_IN_D_B,LOAD_OUT_D_A,
    output internal_reset,DISPLAY_OUTPUT, 
    output reg [7:0]DISP_OUT,
    output  clock_not  ,PC_EN,INSTRUCT_LOAD_OUT,LOAD_IN_D_A,SUBTRACT,RAM_IN,
    output [7:0] SUM_WR ,DATA_A,DATA_B,
    output reg Flag_reg_carry ,Flag_reg_zero

);
wire internal_reset;

//assign #6 BUS_PORT = RESET ? 8'b0 : 8'bz;

    wire LOAD_IN_D_B,LOAD_IN_D_A;
    wire  [7:0] DATA_IN;
    wire  LOAD_OUT_D_B,LOAD_OUT_D_A;
    wire SUBTRACT ,ALU_CARRY_OUT,SUM_OUT,MEM_REG_IN;
    wire RAM_IN,RAM_OUT;
    wire INSTRUCT_LOAD_IN,INSTRUCT_LOAD_OUT;
    wire PC_EN ,PC_LOAD_OUT ,JUMP_PC;
    wire [3:0]OP_CODE;



wire [7:0]  SUM_WR ,RAM_WR;
wire [7:0] DATA_B;
wire [7:0] DATA_A;
wire carry_flag_en;
 wire feedback_rst;
    
////load the EEPROMS ----------------------
  
// -------------------- EEPROM microcode ROMs --------------------
wire [7:0] control_l;
wire [7:0] control_h;

microcode_control u_microcode (
    .OP_CODE(OP_CODE),
    .step(step),
    .Flag_reg_carry(Flag_reg_carry),
    .Flag_reg_zero(Flag_reg_zero),
    .control_l(control_l),
    .control_h(control_h)
);
// -------------------- Split low control byte --------------------

assign feedback_rst      = control_l[7];
assign MEM_REG_IN        = control_l[6];
assign RAM_IN            = control_l[5];
assign RAM_OUT           = control_l[4];
assign INSTRUCT_LOAD_OUT = control_l[3];
assign INSTRUCT_LOAD_IN  = control_l[2];
assign LOAD_IN_D_A       = control_l[1];
assign LOAD_OUT_D_A      = control_l[0];

// -------------------- Split high control byte --------------------

assign SUM_OUT        = control_h[7];
assign SUBTRACT       = control_h[6];
assign LOAD_IN_D_B    = control_h[5];
assign flag_en  = control_h[4];
assign PC_EN          = control_h[3];
assign PC_LOAD_OUT    = control_h[2];
assign JUMP_PC        = control_h[1];
assign DISPLAY_OUTPUT = control_h[0];   

//------------------
assign BUS_PORT=DATA_IN;

assign internal_reset=feedback_rst| RESET;

data_register reg_B (
    .Bus_8(BUS_PORT),
    .CLK(CLK),
    .ENABLE(LOAD_IN_D_B),
    .RESET(RESET),
    .DATA_8(DATA_B)
);



always @ (posedge CLK) begin 
    if (RESET)begin 
         DISP_OUT<=8'b00000000;
    end
    else if (DISPLAY_OUTPUT) begin 
        DISP_OUT<=BUS_PORT;
    end
    end

data_register reg_A (
    .Bus_8(BUS_PORT),
    .CLK(CLK),
    .ENABLE(LOAD_IN_D_A),
    .RESET(RESET),
    .DATA_8(DATA_A)
);

buffer_8bit buffer_A (
    .IN(DATA_A),
    .ENABLE(LOAD_OUT_D_A),
    .OUT(BUS_PORT)
);

ALU_SUM ALU(
    .A(DATA_A),
    .B(DATA_B),
    .SUBTRACTION(SUBTRACT),
    .SUM(SUM_WR),
    .C_OUT(ALU_CARRY_OUT));
    
buffer_8bit buffer_ALU (
    .IN(SUM_WR),
    .ENABLE(SUM_OUT),
    .OUT(BUS_PORT)
);    
wire zero_flag_en;

zero_flag u_zero_flag (
    .SUM_WR(SUM_WR),
    .zero_flag_en(zero_flag_en)
);

 RAM_4b_adrs_8b_wrd_gates RAM(
    .ADDRS_4(BUS_PORT[3:0]),
    .DATA_8(BUS_PORT),
    .RAM_IN(RAM_IN),
    .clk(CLK), 
    .MEM_REG_IN(MEM_REG_IN),
    .Reset(RESET),
    .OUT(RAM_WR)
);

//wire [7:0] temp_ram_out ; 
buffer_8bit buffer_RAM (
    .IN(RAM_WR),
    .ENABLE(RAM_OUT),
    .OUT(BUS_PORT)
); 


//assign BUS_PORT =temp_ram_out ;
wire [3:0] INSTUCT_WR,OP_CODE;
//wire [3:0] INSTUCT_WR;

wire [7:0] instruct_bus;
data_register INSTUCT_REG (
    .Bus_8(BUS_PORT),
    .CLK(CLK),
    .ENABLE(INSTRUCT_LOAD_IN),
    .RESET(RESET),
    .DATA_8(instruct_bus)
);
assign OP_CODE    = instruct_bus[7:4];  // 4 MSBs
assign INSTUCT_WR = instruct_bus[3:0];  // 4 LSBs
wire[3:0] LSB_BUS;
buffer_4bit buffer_INSTUCTION (
    .IN(INSTUCT_WR),
    .ENABLE(INSTRUCT_LOAD_OUT),
    .OUT(LSB_BUS)
); 
wire [3:0] PC_WR;
 program_counter Prog_Counter(
     .clk(CLK), .reset(RESET),
     .counter_En(PC_EN),
     .jump_pc(JUMP_PC),
     .bus_pc(LSB_BUS),//inp
     .out (PC_WR)
);


buffer_4bit buffer_PC (
    .IN(PC_WR),
    .ENABLE(PC_LOAD_OUT),
    .OUT(LSB_BUS)
);
assign BUS_PORT[3:0] =LSB_BUS;

wire clock_not;
assign clock_not =~CLK ;
wire [2:0]step ;

STEP Steps(
    .CLK_bar(clock_not),
    .step_out(step),
    .RESET(RESET)); 
  
//always @(*) begin
//    // if (DISPLAY_OUTPUT)
//        $display("BUS_PORT = %0d, RAM_WR = %0d", 
//                 BUS_PORT, RAM_WR );
//end

//reg Flag_reg_carry ;
 
always @( posedge CLK )begin 
    if (RESET) begin
    Flag_reg_carry <=1'b0;
     end 
     else if (flag_en)
        begin 
         Flag_reg_carry <=ALU_CARRY_OUT ;
        end   
   end  

always @( posedge CLK )begin 
    if (RESET) begin
    Flag_reg_zero <=1'b0;
     end 
     else if (flag_en)
        begin 
         Flag_reg_zero <= zero_flag_en ;
        end   
   end  

endmodule


