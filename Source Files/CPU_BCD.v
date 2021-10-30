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


module CPU_SSD(input clk, input rst, input clkSSD, input [1:0] ledSel, input [3:0] ssdSel, output reg [15:0] LEDs,output  [3:0] Anode, 
output [6:0] LED_out);
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
reg [12:0] num;

register_nbit #(32) rg (rst, 1'b1, clk, PC_input,Read_Address);

InstMem IM(Read_Address[7:2], inst); 

Control_Unit CU(inst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp);

register_file_nbit #(32) RF( rst,  clk, inst[19:15], inst[24:20], inst[11:7], write_data, RegWrite, read_data1, read_data2);
 
ImmGen IG(gen_out, inst);

SLL_nbit #(32) SL(
gen_out,
Shifted_gen_out);

n_bit_2x1_Multiplexer  #(32) MUX_RF(read_data2, gen_out, ALUSrc, ALU_input);

ALU_Control_Unit ALU_CU(ALUOp, inst, ALU_Selection);

ALU_nbit #(32)ALU(read_data1,ALU_input,ALU_Selection, ALU_out, zFlag, ofFlag);

DataMem DM( clk, MemRead, MemWrite, ALU_out[7:2], read_data2, Mem_out);

n_bit_2x1_Multiplexer  #(32) MUX_Mem(ALU_out, Mem_out, MemtoReg, write_data);

assign B_MUX_Sel = Branch & zFlag;

Ripple_Carry_Adder_nbit #(32) B_adder(
Shifted_gen_out,
 Read_Address, 
1'b0,
 B_Add_Out, discard1

);

Ripple_Carry_Adder_nbit #(32) PC_adder(32'd4, Read_Address, 1'b0, PC_4 , discard2);

n_bit_2x1_Multiplexer  #(32) MUX_PC(PC_4, B_Add_Out, B_MUX_Sel, PC_input);


always@(*) begin
case(ledSel)

2'b00: LEDs = inst[15:0];

2'b01: LEDs = inst[31:16];

2'b10: LEDs = {2'b0,Branch, MemRead, MemtoReg,ALUOp, MemWrite, ALUSrc, RegWrite, ALU_Selection, zFlag, B_MUX_Sel};

default: LEDs = 0;
endcase


case(ssdSel)
4'b0000: num = Read_Address[12:0];
4'b0001: num = PC_4[12:0];
4'b0010: num = B_Add_Out[12:0];
4'b0011: num = PC_input[12:0]; 
4'b0100: num = read_data1[12:0];
4'b0101: num = read_data2[12:0];
4'b0110: num = write_data[12:0];
4'b0111: num = gen_out[12:0];
4'b1000: num = Shifted_gen_out [12:0];
4'b1001: num = ALU_input[12:0];
4'b1010: num = ALU_out[12:0];
4'b1011: num = Mem_out[12:0];

default: num = 0;
endcase
end

Seven_Segment_Display bcd1(clkSSD, num,Anode,LED_out);

endmodule
