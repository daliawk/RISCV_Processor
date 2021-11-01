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
wire [31:0] inst;
wire jump, branch, mem_read, mem_to_reg, mem_write, ALU_src, reg_write, signed_inst,  PC_en; 
wire [1:0] RF_MUX_sel;
wire [31:0] mem_MUX_out;
wire [1:0] AU_inst_sel;
wire [1:0] ALUOp;
wire [31:0] write_data;
wire [31:0] read_data1, read_data2;
wire [31:0] gen_out;
wire [31:0] shifted_gen_out;
wire [31:0] ALU_second_input;
wire [3:0] ALU_selection; 
wire [31:0] ALU_out;
wire Z, V, C, S;
wire branch_decision;
wire [31:0] mem_out;
wire [31:0] b_add_out;
wire discard1, discard2;
wire [31:0] PC_4;
wire [31:0] mem_write_data;
wire [31:0] mem_mux_input;
wire [31:0] branch_mux_output;

register_nbit #(32) PC (.rst(rst), .load(PC_en), .clk(clk), .D(PC_input),.Q(inst_read_address));

InstMem IM(inst_read_address[7:2], inst); 

Control_Unit CU(.rst(rst), .inst(inst), .PC_en(PC_en), .branch(branch), .jump(jump), .mem_read(mem_read), .mem_to_reg(mem_to_reg), .mem_write(mem_write), .ALU_Src(ALU_src), .reg_write(reg_write), .signed_inst(signed_inst), .AU_inst_sel(AU_inst_sel), .ALU_Op(ALUOp), .RF_MUX_sel(RF_MUX_sel));

three_input_Mux_nbit RF_MUX(.a(mem_MUX_out), .b(b_add_out), .c(PC_4), .out(write_data), .sel(RF_MUX_sel));

branching_unit BU(.B(branch), .funct3(inst[14:12]), .Z(Z), .S(S), .V(V), .C(C), .branch(branch_decision));

register_file_nbit #(32) RF( .rst(rst),  .clk(clk), .read_reg1(inst[19:15]), .read_reg2(inst[24:20]), .write_reg(inst[11:7]), .write_data(write_data), .write(reg_write), .read_data1(read_data1), .read_data2(read_data2));
 
ImmGen IG(.IR(inst), .Imm(gen_out));

SLL_nbit #(32) SL(.a(gen_out), .b(shifted_gen_out));

MUX_2x1_nbit  #(32) MUX_RF(.a(read_data2), .b(gen_out), .sel(ALU_src), .out(ALU_second_input));

ALU_Control_Unit ALU_CU(.ALUOp(ALUOp), .inst(inst), .ALU_selection(ALU_selection));

ALU_nbit #(32)ALU(.A(read_data1), .B(ALU_second_input), .alu_control(ALU_selection), .ALUout(ALU_out), .Z(Z), .V(V), .C(C), .S(S));

Addressing_Unit mem_input(.data_in(read_data2),.AU_inst_sel(AU_inst_sel),.signed_inst(signed_inst),.data_out(mem_write_data));

Data_Mem DM( .clk(clk), .mem_read(mem_read), .mem_write(mem_write), .addr(ALU_out[7:2]) ,.data_in(mem_write_data), .data_out(mem_out));

Addressing_Unit mem_output(.data_in(mem_out),.AU_inst_sel(AU_inst_sel),.signed_inst(signed_inst),.data_out(mem_mux_input));

MUX_2x1_nbit  #(32) MUX_Mem(.a(ALU_out), .b(mem_mux_input), .sel(mem_to_reg), .out(mem_MUX_out));

Ripple_Carry_Adder_nbit #(32) B_adder(.A(shifted_gen_out), .B(inst_read_address), .Cin(`ZERO), .S(b_add_out), .Cout(discard1));

Ripple_Carry_Adder_nbit #(32) PC_adder(.A(4), .B(inst_read_address), .Cin(`ZERO), .S(PC_4) , .Cout(discard2));

MUX_2x1_nbit  #(32) MUX_branch(.a(PC_4), .b(b_add_out), .sel(branch_decision), .out(branch_mux_output));
MUX_2x1_nbit  #(32) MUX_PC(.a(branch_mux_output), .b(ALU_out), .sel(jump), .out(PC_input));

endmodule
