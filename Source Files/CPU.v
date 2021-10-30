`timescale 1ns / 1ps
`include "C:\Users\Kirolos Mikhail\Downloads\RISCV_Processor-main\RISCV_Processor-main\Defines\defines.v"
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
wire branch, mem_read, mem_to_reg, mem_write, ALU_src, reg_write; 
wire [1:0] ALUOp;
wire [31:0] write_data;
wire [31:0] read_data1, read_data2;
wire [31:0] gen_out;
wire [31:0] shifted_gen_out;
wire [31:0] ALU_second_input;
wire [3:0] ALU_selection; 
wire [31:0] ALU_out;
wire Z, V;
wire [31:0] mem_out;
wire b_mux_sel;
wire [31:0] b_add_out;
wire discard1, discard2;
wire [31:0] PC_4;
register_nbit #(32) rg (rst, 1'b1, clk, PC_input,inst_read_address);

InstMem IM(inst_read_address[7:2], inst); 

Control_Unit CU(inst, branch, mem_read, mem_to_reg, mem_write, ALU_src, reg_write, ALUOp);

register_file_nbit #(32) RF( rst,  clk, inst[19:15], inst[24:20], inst[11:7], write_data, reg_write, read_data1, read_data2);
 
ImmGen IG(gen_out, inst);

SLL_nbit #(32) SL(gen_out, shifted_gen_out);

n_bit_2x1_Multiplexer  #(32) MUX_RF(read_data2, gen_out, ALU_src, ALU_second_input);

ALU_Control_Unit ALU_CU(ALUOp, inst, ALU_selection);

ALU_nbit #(32)ALU(read_data1,ALU_second_input,ALU_selection, ALU_out, Z, V);

DataMem DM( clk, mem_read, mem_write, ALU_out[7:2], read_data2, mem_out);

n_bit_2x1_Multiplexer  #(32) MUX_Mem(ALU_out, mem_out, mem_to_reg, write_data);

assign b_mux_sel = branch & Z;

Ripple_Carry_Adder_nbit #(32) B_adder(shifted_gen_out, inst_read_address, ZERO, b_add_out, discard1);

Ripple_Carry_Adder_nbit #(32) PC_adder(32'd4, inst_read_address, 1'b0, PC_4 , discard2);

n_bit_2x1_Multiplexer  #(32) MUX_PC(PC_4, b_add_out, b_mux_sel, PC_input);

endmodule
