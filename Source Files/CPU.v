`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2021 09:27:47 AM
// Design Name: 
// Module Name: CPU
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


module CPU(input clk, input rst);
wire [31:0] Read_Address;
wire [31:0] PC_input;
wire [31:0] inst;
wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite; wire [1:0] ALUOp;
wire [31:0] write_data;
wire [31:0] read_data1, read_data2;
wire [31:0] gen_out;
wire [31:0] Shifted_gen_out;
wire [31:0] ALU_input;
wire [3:0] ALU_Selection; 
wire [31:0] ALU_out;
wire zFlag, ofFlag;
wire [31:0] Mem_out;
wire B_MUX_Sel;
wire [31:0] B_Add_Out;
wire discard1, discard2;
wire [31:0] PC_4;
N_Bit_Register #(32) rg (rst, 1'b1, clk, PC_input,Read_Address);

InstMem IM(Read_Address[7:2], inst); 

Control_Unit CU(inst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp);

N_bit_register_file #(32) RF( rst,  clk, inst[19:15], inst[24:20], inst[11:7], write_data, RegWrite, read_data1, read_data2);
 
ImmGen IG(gen_out, inst);

nbitsll #(32) SL(
gen_out,
Shifted_gen_out);

n_bit_2x1_Multiplexer  #(32) MUX_RF(read_data2, gen_out, ALUSrc, ALU_input);

ALU_Control_Unit ALU_CU(ALUOp, inst, ALU_Selection);

n_bit_ALU #(32)ALU(read_data1,ALU_input,ALU_Selection, ALU_out, zFlag, ofFlag);

DataMem DM( clk, MemRead, MemWrite, ALU_out[7:2], read_data2, Mem_out);

n_bit_2x1_Multiplexer  #(32) MUX_Mem(ALU_out, Mem_out, MemtoReg, write_data);

assign B_MUX_Sel = Branch & zFlag;

RCA8 #(32) B_adder(
Shifted_gen_out,
 Read_Address, 
1'b0,
 B_Add_Out, discard1

);

RCA8 #(32) PC_adder(32'd4, Read_Address, 1'b0, PC_4 , discard2);

n_bit_2x1_Multiplexer  #(32) MUX_PC(PC_4, B_Add_Out, B_MUX_Sel, PC_input);

endmodule
