`timescale 1ns / 1ps
`include "defines.v"
/********************************************************************* 
* Module: CPU.v 
* Project: RISV_Processor 
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed Talaat - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
* 
* Description: The top module for the RISC-V processor
*
* Change history: 10/25/21 - “ Modified file to follow code guidelines 
* 
**********************************************************************/ 



module CPU(
    input clk, 
    input rst
//  output    [31:0] inst_read_address,
//  output    [31:0] PC_input,
//  output    [31:0] inst,
//  output    jump, branch, mem_read, mem_to_reg, mem_write, ALU_src, reg_write, signed_inst,  PC_en, 
//  output    [1:0] RF_MUX_sel,
//  output    [31:0] mem_MUX_out,
//  output    [1:0] AU_inst_sel,
//  output    [1:0] ALUOp,
//  output    [31:0] write_data,
//  output    [31:0] read_data1, read_data2,
//  output    [31:0] gen_out,
//  output    [31:0] shifted_gen_out,
//  output    [31:0] ALU_second_input,
//  output    [3:0] ALU_selection, 
//  output    [31:0] ALU_out,
//  output    Z, V, C, S,
//  output    branch_decision,
//  output    [31:0] mem_out,
//  output    [31:0] b_add_out,
//  output    discard1, discard2,
//  output    [31:0] PC_4,
//  output    [31:0] mem_write_data,
//  output    [31:0] mem_mux_input,
//  output    [31:0] branch_mux_output
);

wire [31:0] inst_read_address;
wire [31:0] PC_input;
//wire [31:0] inst;
wire jump, branch, mem_read, mem_to_reg, mem_write, ALU_src, reg_write, signed_inst,  PC_en; 
wire [1:0] RF_MUX_sel;
wire [31:0] mem_MUX_out;
wire [1:0] AU_inst_sel;
wire [1:0] ALUOp;
wire [31:0] write_data;
wire [31:0] read_data1, read_data2;
wire [31:0] gen_out;
//wire [31:0] shifted_gen_out;
wire [31:0] ALU_second_input;
wire [3:0] ALU_selection; 
wire [31:0] ALU_out;
wire Z, V, C, S;
wire branch_decision;
wire [31:0] mem_out;
wire [31:0] b_add_out;
wire discard1, discard2;
wire [31:0] PC_4;
//wire [31:0] mem_write_data;
//wire [31:0] mem_mux_input;
wire [31:0] branch_mux_output;
//wire sclk;
wire [31:0] mem_input;


//////////////////////////////////// pipelining //////////////////////////////
wire [31:0] IF_ID_PC;
wire [31:0] IF_ID_Inst;
wire [31:0] ID_EX_PC;
wire [31:0] ID_EX_RegR1;
wire [31:0] ID_EX_RegR2;
wire [31:0] ID_EX_Imm;
wire [31:0] ID_EX_Inst;
register_nbit #(64) IF_ID (rst,1'b1,~clk,
 {inst_read_address,mem_out},
{IF_ID_PC,IF_ID_Inst} );


wire ID_EX_Jump, ID_EX_Branch, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_RegWrite,ID_EX_Signed_inst; 
wire [1:0] ID_EX_ALUOp;

wire [3:0] ID_EX_Func;
wire [4:0] ID_EX_Rs1; 
wire [4:0] ID_EX_Rs2; 
wire [4:0] ID_EX_Rd;
wire [1:0] ID_EX_RF_MUX_sel;

register_nbit #(200) ID_EX (rst,1'b1,clk,

{ jump,branch, mem_read, mem_to_reg, mem_write, ALU_src, reg_write, RF_MUX_sel, signed_inst, ALUOp,IF_ID_PC,read_data1, read_data2,gen_out,IF_ID_Inst, {IF_ID_Inst[30],IF_ID_Inst[14:12]},IF_ID_Inst[19:15], IF_ID_Inst[24:20],IF_ID_Inst[11:7]},
{ ID_EX_Jump, ID_EX_Branch, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_RegWrite, ID_EX_RF_MUX_sel,ID_EX_Signed_inst, ID_EX_ALUOp,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,
 ID_EX_Imm,ID_EX_Inst, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd} );
 
 
 wire [31:0] EX_MEM_BranchAddOut;
 wire [31:0] EX_MEM_Inst;
 wire [31:0] EX_MEM_ALU_out; 
 wire [31:0] EX_MEM_RegR2;
 wire EX_MEM_Branch, EX_MEM_Jump, EX_MEM_MemRead, EX_MEM_MemtoReg, EX_MEM_MemWrite, EX_MEM_RegWrite;
 wire [4:0] EX_MEM_Rd;
 wire EX_MEM_Z, EX_MEM_V, EX_MEM_C, EX_MEM_S;
 
 register_nbit #(200) EX_MEM (rst,1'b1,~clk,
  {b_add_out,ALU_out,ID_EX_RegR2,ID_EX_Jump,ID_EX_Branch, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_MemWrite, ID_EX_RegWrite,ID_EX_Rd,ID_EX_Inst,Z, V, C, S},
 {EX_MEM_BranchAddOut,EX_MEM_ALU_out, EX_MEM_RegR2,EX_MEM_Jump, EX_MEM_Branch, EX_MEM_MemRead, EX_MEM_MemtoReg, EX_MEM_MemWrite, EX_MEM_RegWrite,
       EX_MEM_Rd,EX_MEM_Inst, EX_MEM_Z, EX_MEM_V, EX_MEM_C, EX_MEM_S} );


wire [31:0] MEM_WB_Mem_out;
wire MEM_WB_branch_decision;
wire [31:0] MEM_WB_ALU_out;
wire MEM_WB_MemtoReg,MEM_WB_RegWrite;
wire [4:0] MEM_WB_Rd;

register_nbit #(100) MEM_WB (rst,1'b1,clk,
 {branch_decision,EX_MEM_MemtoReg,EX_MEM_RegWrite,mem_out,EX_MEM_ALU_out,EX_MEM_Rd},
 {MEM_WB_branch_decision, MEM_WB_MemtoReg,MEM_WB_RegWrite,MEM_WB_Mem_out, MEM_WB_ALU_out,
 MEM_WB_Rd} );


//register_nbit #(32) rg (rst, 1'b1, clk, PC_input,inst_read_address);

/////////////////////////////////////// end of pipelining ///////////////////////////////////////////


register_nbit #(32) PC (.rst(rst), .load(PC_en), .clk(clk), .D(PC_input),.Q(inst_read_address));

MUX_2x1_nbit  #(32) MUX_inst_data_mem(.a(EX_MEM_ALU_out), .b(inst_read_address), .sel(clk), .out(mem_input));

InstMem IM( 
.sclk(clk),
 .mem_read(EX_MEM_MemRead),
  .mem_write(EX_MEM_MemWrite),
   .AU_inst_sel(AU_inst_sel),
    .signed_inst(signed_inst),
     .addr(mem_input[7:0]),
      .data_in(EX_MEM_RegR2), 
       .data_out(mem_out)
      );  

Control_Unit CU(.rst(rst), .inst(IF_ID_Inst), .PC_en(PC_en), .branch(branch), .jump(jump), .mem_read(mem_read),
 .mem_to_reg(mem_to_reg), .mem_write(mem_write), .ALU_Src(ALU_src), .reg_write(reg_write), .signed_inst(signed_inst), 
 .AU_inst_sel(AU_inst_sel), .ALU_Op(ALUOp), .RF_MUX_sel(RF_MUX_sel));

three_input_Mux_nbit RF_MUX(.a(mem_MUX_out), .b(EX_MEM_BranchAddOut), .c(PC_4), .out(write_data), .sel(ID_EX_RF_MUX_sel));

branching_unit BU(.B(EX_MEM_Branch), .jump(EX_MEM_Jump), .funct3(EX_MEM_Inst[14:12]), .Z(Z), .S(S), .V(V), .C(C), .branch(branch_decision));

register_file_nbit #(32) RF( .rst(rst),  .clk(~clk), .read_reg1(IF_ID_Inst[19:15]), .read_reg2(IF_ID_Inst[24:20]),
 .write_reg(IF_ID_Inst[11:7]), .write_data(write_data), .write(MEM_WB_RegWrite), .read_data1(read_data1), .read_data2(read_data2));
 
ImmGen IG(.IR(IF_ID_Inst), .Imm(gen_out));

MUX_2x1_nbit  #(32) MUX_RF(.a(ID_EX_RegR2), .b(ID_EX_Imm), .sel(ID_EX_ALUSrc), .out(ALU_second_input));

ALU_Control_Unit ALU_CU(.ALUOp(ID_EX_ALUOp), .inst(ID_EX_Inst), .ALU_selection(ALU_selection));

ALU_nbit #(32)ALU(.A(ID_EX_RegR1), .B(ALU_second_input), .alu_control(ALU_selection), .ALUout(ALU_out), .Z(Z), .V(V), .C(C), .S(S));

//Data_Mem DM( .clk(clk), .mem_read(EX_MEM_MemRead), .mem_write(EX_MEM_MemWrite), .AU_inst_sel(AU_inst_sel),.signed_inst(signed_inst), .addr(ALU_out[7:0]) ,.data_in(read_data2), .data_out(mem_out));

MUX_2x1_nbit  #(32) MUX_Mem(.a(MEM_WB_ALU_out), .b(MEM_WB_Mem_out), .sel(EX_MEM_MemtoReg), .out(mem_MUX_out));

Ripple_Carry_Adder_nbit #(32) B_adder(.A(ID_EX_Imm), .B(ID_EX_PC), .Cin(`ZERO), .S(b_add_out), .Cout(discard1));

Ripple_Carry_Adder_nbit #(32) PC_adder(.A(4), .B(inst_read_address), .Cin(`ZERO), .S(PC_4) , .Cout(discard2));

MUX_2x1_nbit  #(32) MUX_branch(.a(PC_4), .b(EX_MEM_BranchAddOut), .sel(MEM_WB_branch_decision), .out(branch_mux_output));

// EX_MEM_Jump, EX_MEM_Branch

MUX_2x1_nbit  #(32) MUX_PC(.a(branch_mux_output), .b(EX_MEM_ALU_out), .sel(EX_MEM_Jump & ~EX_MEM_Branch), .out(PC_input));

endmodule
