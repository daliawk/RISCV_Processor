`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2021 09:40:21 AM
// Design Name: 
// Module Name: CPU_TB
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


module CPU_TB;
reg clk;
reg rst;
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
    CPU cpu(clk,rst, inst_read_address, PC_input, inst,
 jump, branch, mem_read, mem_to_reg, mem_write, ALU_src, reg_write, signed_inst,  PC_e,
 RF_MUX_sel,
mem_MUX_out,
AU_inst_sel,
ALUOp,
 write_data,
 read_data1, read_data2,
 gen_out,
 shifted_gen_out,
 ALU_second_input,
ALU_selection,
 ALU_out,
 Z, V, C, S,
 branch_decision,
  mem_out,
  b_add_out,
 discard1, discard2,
  PC_4,
  mem_write_data,
  mem_mux_input,
  branch_mux_output);
    
    
    always begin
    clk = 0;
    forever #100 clk = ~clk;
    end
    
    initial begin
    rst = 1;
    #100
    rst = 0;
    #1000;
    
    end
    
    
    
endmodule
