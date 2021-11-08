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
);

wire [31:0] PC_out;
wire [31:0] PC_input;
wire [31:0] inst;
wire jump, branch, mem_read, mem_to_reg, mem_write, ALU_src, reg_write, signed_inst,  PC_en; 
wire [1:0] RF_MUX_sel;
wire [31:0] mem_MUX_out;
wire [1:0] AU_inst_sel;
wire [1:0] ALU_Op;
wire [31:0] write_data;
wire [31:0] read_data1, read_data2;
wire [31:0] gen_out;
wire [31:0] ALU_second_input;
wire [3:0] ALU_selection; 
wire [31:0] ALU_out;
wire Z, V, C, S;
wire branch_decision;
wire [31:0] mem_out;
wire [31:0] b_add_out;
wire discard1, discard2;
wire [31:0] PC_4;
wire [31:0] branch_mux_output;

// Pipelining wires
wire [31:0] IF_ID_PC_4;
wire [31:0] IF_ID_PC_out;
wire [31:0] IF_ID_inst;

wire ID_EX_branch, ID_EX_jump, ID_EX_mem_read, ID_EX_mem_to_reg, ID_EX_mem_write, ID_EX_ALU_Src, ID_EX_reg_write, ID_EX_signed_inst;
wire [1:0] ID_EX_AU_inst_sel;
wire [1:0] ID_EX_ALU_Op;
wire [1:0] ID_EX_RF_MUX_sel;
wire [31:0] ID_EX_read_data1;
wire [31:0] ID_EX_read_data2;
wire [31:0] ID_EX_gen_out;
wire [31:0] ID_EX_inst;
wire [31:0] ID_EX_PC_4;
wire [31:0] ID_EX_PC_out;

wire EX_MEM_branch, EX_MEM_jump, EX_MEM_mem_read, EX_MEM_mem_to_reg, EX_MEM_mem_write, EX_MEM_reg_write, EX_MEM_signed_inst;
wire [1:0] EX_MEM_AU_inst_sel;
wire [1:0] EX_MEM_RF_MUX_sel;
wire [31:0] EX_MEM_PC_4;
wire [31:0] EX_MEM_ALU_out;
wire EX_MEM_Z, EX_MEM_V, EX_MEM_C, EX_MEM_S;
wire [4:0] EX_MEM_write_reg;
wire [31:0] EX_MEM_read_data2;
wire [2:0] EX_MEM_funct3;
wire [31:0] EX_MEM_b_add_out;

wire MEM_WB_mem_to_reg, MEM_WB_reg_write;
wire [1:0] MEM_WB_RF_MUX_sel;
wire [31:0] MEM_WB_PC_4;
wire [31:0] MEM_WB_ALU_out;
wire [31:0] MEM_WB_b_add_out;
wire [31:0] MEM_WB_mem_out;
wire [4:0] MEM_WB_write_reg;

///////////////////////// IR  begins /////////////////////////////////////////////////////////////////////////////////////
register_nbit #(32) PC (.rst(rst), .load(PC_en), .clk(clk), .D(PC_input),.Q(PC_out));

InstMem IM(PC_out[7:2], inst); 

Ripple_Carry_Adder_nbit #(32) PC_adder(.A(4), .B(PC_out), .Cin(`ZERO), .S(PC_4) , .Cout(discard2));
////////////////////////// IR ends ////////////////////////////////////////////////////////////////////////////////////////

register_nbit #(96) IF_ID (clk, rst,`ONE,
    {PC_4, PC_out, inst},
    {IF_ID_PC_4, IF_ID_PC_out, IF_ID_inst}
    );

///////////////////////// ID  begins /////////////////////////////////////////////////////////////////////////////////////
Control_Unit CU(.rst(rst), .inst(IF_ID_inst), .PC_en(PC_en), .branch(branch), .jump(jump), .mem_read(mem_read), 
                .mem_to_reg(mem_to_reg), .mem_write(mem_write), .ALU_Src(ALU_src), .reg_write(reg_write), 
                .signed_inst(signed_inst), .AU_inst_sel(AU_inst_sel), .ALU_Op(ALU_Op), .RF_MUX_sel(RF_MUX_sel));


register_file_nbit #(32) RF( .rst(rst),  .clk(clk), .read_reg1(IF_ID_inst[19:15]), .read_reg2(IF_ID_inst[24:20]), 
                            .write_reg(MEM_WB_write_reg), .write_data(write_data), .write(MEM_WB_reg_write), 
                            .read_data1(read_data1), .read_data2(read_data2));

ImmGen IG(.IR(IF_ID_inst), .Imm(gen_out));
///////////////////////// ID ends ////////////////////////////////////////////////////////////////////////////////////////

register_nbit #(206) ID_EX (clk, rst,`ONE,
    {branch, jump, mem_read, mem_to_reg, mem_write, ALU_src, reg_write, signed_inst, AU_inst_sel, ALU_Op, RF_MUX_sel,
    IF_ID_PC_4, IF_ID_PC_out, read_data1, read_data2, gen_out, IF_ID_inst},
    {ID_EX_branch, ID_EX_jump, ID_EX_mem_read, ID_EX_mem_to_reg, ID_EX_mem_write, ID_EX_ALU_Src, ID_EX_reg_write, 
    ID_EX_signed_inst, ID_EX_AU_inst_sel, ID_EX_ALU_Op, ID_EX_RF_MUX_sel, ID_EX_PC_4, ID_EX_PC_out, ID_EX_read_data1, 
    ID_EX_read_data2, ID_EX_gen_out, ID_EX_inst}
    );

///////////////////////// EX begins ////////////////////////////////////////////////////////////////////////////////////////
MUX_2x1_nbit  #(32) MUX_RF(.a(ID_EX_read_data2), .b(ID_EX_gen_out), .sel(ID_EX_ALU_Src), .out(ALU_second_input));

Ripple_Carry_Adder_nbit #(32) B_adder(.A(ID_EX_gen_out), .B(ID_EX_PC_out), .Cin(`ZERO), .S(b_add_out), .Cout(discard1));

ALU_Control_Unit ALU_CU(.ALUOp(ID_EX_ALU_Op), .inst(ID_EX_inst), .ALU_selection(ALU_selection));

ALU_nbit #(32)ALU(.A(ID_EX_read_data1), .B(ALU_second_input), .alu_control(ALU_selection), .ALUout(ALU_out), 
                    .Z(Z), .V(V), .C(C), .S(S));
//////////////////////// EX ends //////////////////////////////////////////////////////////////////////////////////////////// 


register_nbit #(151) EX_MEM (clk, rst,`ONE,
    {ID_EX_branch, ID_EX_jump, ID_EX_mem_read, ID_EX_mem_to_reg, ID_EX_mem_write, ID_EX_reg_write, ID_EX_signed_inst, 
    ID_EX_AU_inst_sel, ID_EX_RF_MUX_sel, ID_EX_PC_4, ALU_out, Z, V, C, S, ID_EX_inst[11:7], ID_EX_read_data2, ID_EX_inst[14:12],
    b_add_out},
    {EX_MEM_branch, EX_MEM_jump, EX_MEM_mem_read, EX_MEM_mem_to_reg, EX_MEM_mem_write, EX_MEM_reg_write, 
     EX_MEM_signed_inst, EX_MEM_AU_inst_sel, EX_MEM_RF_MUX_sel, EX_MEM_PC_4, EX_MEM_ALU_out, EX_MEM_Z, EX_MEM_V, 
     EX_MEM_C, EX_MEM_S, EX_MEM_write_reg, EX_MEM_read_data2, EX_MEM_funct3, EX_MEM_b_add_out}
    );


//////////////////////// MEM begins ///////////////////////////////////////////////////////////////////////////////////////////
branching_unit BU(.B(EX_MEM_branch), .jump(EX_MEM_jump), .funct3(EX_MEM_funct3), .Z(EX_MEM_Z), .S(EX_MEM_S), .V(EX_MEM_V), 
                    .C(EX_MEM_C), .branch(branch_decision));


MUX_2x1_nbit  #(32) MUX_branch(.a(PC_4), .b(EX_MEM_b_add_out), .sel(branch_decision), .out(branch_mux_output));
MUX_2x1_nbit  #(32) MUX_PC(.a(branch_mux_output), .b(EX_MEM_ALU_out), .sel(EX_MEM_jump & ~EX_MEM_branch), .out(PC_input));

Data_Mem DM( .clk(clk), .mem_read(EX_MEM_mem_read), .mem_write(EX_MEM_mem_write), .AU_inst_sel(EX_MEM_AU_inst_sel),
            .signed_inst(signed_inst), .addr(EX_MEM_ALU_out[7:0]) ,.data_in(EX_MEM_read_data2), .data_out(mem_out));
//////////////////////// MEM ends //////////////////////////////////////////////////////////////////////////////////////////

register_nbit #(137) MEM_WB (clk, rst,`ONE,
    {EX_MEM_mem_to_reg, EX_MEM_reg_write, EX_MEM_RF_MUX_sel, EX_MEM_PC_4, EX_MEM_ALU_out, EX_MEM_b_add_out, mem_out, EX_MEM_write_reg},
    {MEM_WB_mem_to_reg, MEM_WB_reg_write, MEM_WB_RF_MUX_sel, MEM_WB_PC_4, MEM_WB_ALU_out, MEM_WB_b_add_out, MEM_WB_mem_out,
    MEM_WB_write_reg}
    );

////////////////////// WB begins //////////////////////////////////////////////////////////
MUX_2x1_nbit  #(32) MUX_Mem(.a(MEM_WB_ALU_out), .b(MEM_WB_mem_out), .sel(MEM_WB_mem_to_reg), .out(mem_MUX_out));

three_input_Mux_nbit RF_MUX(.a(mem_MUX_out), .b(MEM_WB_b_add_out), .c(MEM_WB_PC_4), .out(write_data), .sel(MEM_WB_RF_MUX_sel));
///////////////////// WB ends //////////////////////////////////////////////////////////////////


endmodule
