`timescale 1ns / 1ps
`include "C:\Users\Kirolos Mikhail\Downloads\Processor\Source Files\defines.v"
/********************************************************************* 
* Module: CPU.v 
* Project: RISV_Processor 
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed Talaat - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
* 
* Description: The top module for the RISC-V processor
*
* Change history: 10/25/21 – Modified file to follow code guidelines 
* 
**********************************************************************/ 



module CPU(
    input clk, 
    input rst
);

wire [31:0] inst_read_address;
wire [31:0] PC_input;
wire [31:0] inst;
wire jump, branch, mem_read, mem_to_reg, mem_write, ALU_src, reg_write, signed_inst; 
wire [1:0] RF_MUX_sel;
wire mem_MUX_out;
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

register_nbit #(32) rg (rst, 1'b1, clk, PC_input,inst_read_address);

InstMem IM(.addr(inst_read_address[7:2]), .data_out(inst)); 

Control_Unit CU(.inst(inst), .branch(branch), .jump(jump), .mem_read(mem_read), .mem_to_reg(mem_to_reg), .mem_write(mem_write), .ALU_Src(ALU_src), .reg_write(reg_write), .signed_inst(signed_inst), .AU_inst_sel(AU_inst_sel), .ALUOp(ALUOp), .RF_MUX_sel(RF_MUX_sel));

MUX_3x1_nbit RF_MUX(.a(mem_MUX_out), .b(b_add_out), .c(PC_4), .out(write_data), .sel(RF_MUX_sel));

branching_unit BU(.B(branch), .funct3(inst[14:12]), .Z(Z), .S(S), .V(V), .C(C), .branch(branch_decision));

register_file_nbit #(32) RF( .rst(rst),  .clk(clk), .read_reg1(inst[19:15]), .read_reg2(inst[24:20]), .write_reg(inst[11:7]), .write_data(write_data), .write(reg_write), .read_data1(read_data1), .read_data2(read_data2));
 
ImmGen IG(gen_out, inst);

SLL_nbit #(32) SL(gen_out, shifted_gen_out);

MUX_2x1_nbit  #(32) MUX_RF(read_data2, gen_out, ALU_src, ALU_second_input);

ALU_Control_Unit ALU_CU(ALUOp, inst, ALU_selection);

ALU_nbit #(32)ALU(.A(read_data1), .B(ALU_second_input), .alu_control(ALU_selection), .ALUout(ALU_out), .Z(Z), .V(V), .C(C), .S(S));

//Addressing_Unit mem_input(.());

Data_Mem DM( clk, mem_read, mem_write, ALU_out[7:2], read_data2, mem_out);

MUX_2x1_nbit  #(32) MUX_Mem(ALU_out, mem_out, mem_to_reg, mem_MUX_out);

Ripple_Carry_Adder_nbit #(32) B_adder(shifted_gen_out, inst_read_address, ZERO, b_add_out, discard1);

Ripple_Carry_Adder_nbit #(32) PC_adder(32'd4, inst_read_address, 1'b0, PC_4 , discard2);

n_bit_2x1_Multiplexer  #(32) MUX_PC(PC_4, b_add_out, branch_decision, PC_input);

endmodule
