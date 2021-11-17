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
wire [1:0] branch_decision;
wire [31:0] mem_out;
wire [31:0] b_add_out;
wire [31:0] jalr_add_out;
wire discard1, discard2;
wire [31:0] PC_4;
wire [7:0] mem_in;

// Pipelining wires
wire [31:0] IF_ID_PC_4;
wire [31:0] IF_ID_PC_out;
wire [31:0] IF_ID_inst;

wire ID_EX_mem_read, ID_EX_mem_to_reg, ID_EX_mem_write, ID_EX_ALU_Src, ID_EX_reg_write, ID_EX_signed_inst;
wire [1:0] ID_EX_AU_inst_sel;
wire [1:0] ID_EX_ALU_Op;
wire [1:0] ID_EX_RF_MUX_sel;
wire [31:0] ID_EX_read_data1;
wire [31:0] ID_EX_read_data2;
wire [31:0] ID_EX_gen_out;
wire [31:0] ID_EX_inst;
wire [31:0] ID_EX_PC_4;
wire [31:0] ID_EX_PC_out;

wire EX_MEM_mem_read, EX_MEM_mem_to_reg, EX_MEM_mem_write, EX_MEM_reg_write, EX_MEM_signed_inst;
wire [1:0] EX_MEM_AU_inst_sel;
wire [1:0] EX_MEM_RF_MUX_sel;
wire [31:0] EX_MEM_PC_4;
wire [31:0] EX_MEM_ALU_out;
wire [4:0] EX_MEM_write_reg;
wire [31:0] EX_MEM_read_data2;
wire [31:0] EX_MEM_b_add_out;

wire MEM_WB_reg_write;
wire [1:0] MEM_WB_RF_MUX_sel;
wire [31:0] MEM_WB_PC_4;
wire [31:0] MEM_WB_b_add_out;
wire [31:0] MEM_WB_mem_MUX_out;
wire [4:0] MEM_WB_write_reg;
reg sclk;
wire forwardA_ALU;
wire forwardB_ALU;
wire forwardA_branch;
wire forwardB_branch;
wire [31:0] forwarded_A_ALU;
wire [31:0] forwarded_B_ALU;
wire [31:0] forwarded_A_branch;
wire [31:0] forwarded_B_branch;
wire terminate;
wire comp;
wire [31:0] uncomp_inst;
always@(posedge clk, posedge rst)
begin 
    if(rst)
        sclk = 0;
    else
        sclk = ~sclk;
end

///////////////////////// IR  begins /////////////////////////////////////////////////////////////////////////////////////
register_nbit #(32) PC (.rst(rst), .load(PC_en | terminate), .clk(sclk), .D(PC_input),.Q(PC_out));
// (comp == 1)? 2:4
Ripple_Carry_Adder_nbit #(32) PC_adder(.A((comp == 1)? 2:4), .B(PC_out), .Cin(`ZERO), .S(PC_4) , .Cout(discard2));

MUX_2x1_nbit  #(8) MUX_memory(.a(EX_MEM_ALU_out[7:0]), .b(PC_out[7:0]), .sel(sclk), .out(mem_in));

Memory Mem(.sclk(sclk), .mem_read(EX_MEM_mem_read), .mem_write(EX_MEM_mem_write), .AU_inst_sel(EX_MEM_AU_inst_sel), 
            .signed_inst(EX_MEM_signed_inst),.addr(mem_in), .data_in(EX_MEM_read_data2), .data_out(mem_out)); 
            
Decompression_Unit DU (.rst(rst),.clk(sclk), .instruction(mem_out), .new_inst(uncomp_inst),.terminate(terminate),.comp(comp));
 
////////////////////////// IR ends ////////////////////////////////////////////////////////////////////////////////////////

register_nbit #(96) IF_ID (~sclk, rst,~terminate,
    {PC_4, PC_out, uncomp_inst},
    {IF_ID_PC_4, IF_ID_PC_out, IF_ID_inst}
    );

////////////////////////////////// ID  begins /////////////////////////////////////////////////////////////////////////////
Control_Unit CU(.rst(rst), .inst(IF_ID_inst), .PC_en(PC_en), .branch(branch), .jump(jump), .mem_read(mem_read), 
                .mem_to_reg(mem_to_reg), .mem_write(mem_write), .ALU_Src(ALU_src), .reg_write(reg_write), 
                .signed_inst(signed_inst), .AU_inst_sel(AU_inst_sel), .ALU_Op(ALU_Op), .RF_MUX_sel(RF_MUX_sel));


register_file_nbit #(32) RF( .rst(rst),  .clk(~sclk), .read_reg1(IF_ID_inst[19:15]), .read_reg2(IF_ID_inst[24:20]), 
                            .write_reg(MEM_WB_write_reg), .write_data(write_data), .write(MEM_WB_reg_write), 
                            .read_data1(read_data1), .read_data2(read_data2));

ImmGen IG(.IR(IF_ID_inst), .Imm(gen_out));

// Branching
MUX_2x1_nbit  #(32) MUX_branch_A(.a(read_data1), .b(mem_MUX_out), .sel(forwardA_branch), .out(forwarded_A_branch));
MUX_2x1_nbit  #(32) MUX_branch_B(.a(read_data2), .b(mem_MUX_out), .sel(forwardB_branch), .out(forwarded_B_branch));


branching_unit BU(.B(branch), .jump(jump), .funct3(IF_ID_inst[14:12]), .data1(forwarded_A_branch), 
                    .data2(forwarded_B_branch), .decision(branch_decision));
                    
Ripple_Carry_Adder_nbit #(32) B_adder(.A(gen_out), .B(IF_ID_PC_out), .Cin(`ZERO), .S(b_add_out), .Cout(discard1));

Ripple_Carry_Adder_nbit #(32) jalr_adder(.A(gen_out), .B(forwarded_A_branch), .Cin(`ZERO), .S(jalr_add_out), .Cout(discard1));

three_input_Mux_nbit branch_mux(.a(PC_4), .b(b_add_out), .c(jalr_add_out), .out(PC_input), .sel(branch_decision));

///////////////////////// ID ends ////////////////////////////////////////////////////////////////////////////////////////

register_nbit #(206) ID_EX (sclk, rst,`ONE,
    {mem_read, mem_to_reg, mem_write, ALU_src, reg_write, signed_inst, AU_inst_sel, ALU_Op, RF_MUX_sel,
    IF_ID_PC_4, IF_ID_PC_out, read_data1, read_data2, gen_out, IF_ID_inst},
    {ID_EX_mem_read, ID_EX_mem_to_reg, ID_EX_mem_write, ID_EX_ALU_Src, ID_EX_reg_write, 
    ID_EX_signed_inst, ID_EX_AU_inst_sel, ID_EX_ALU_Op, ID_EX_RF_MUX_sel, ID_EX_PC_4, ID_EX_PC_out, ID_EX_read_data1, 
    ID_EX_read_data2, ID_EX_gen_out, ID_EX_inst}
    );

///////////////////////// EX begins ////////////////////////////////////////////////////////////////////////////////////////
Forwarding_Unit forward_unit(.ID_EX_RegisterRs1(ID_EX_inst[19:15]), .ID_EX_RegisterRs2(ID_EX_inst[24:20]), .IF_ID_RegisterRs1(IF_ID_inst[19:15]),
                             .IF_ID_RegisterRs2(IF_ID_inst[24:20]), .MEM_WB_RegWrite(MEM_WB_reg_write), .EX_MEM_RegWrite(EX_MEM_reg_write),
                             .MEM_WB_RegisterRd(MEM_WB_write_reg), .EX_MEM_RegisterRd(EX_MEM_write_reg),
                             .forwardA_ALU(forwardA_ALU), .forwardB_ALU(forwardB_ALU), .forwardA_branch(forwardA_branch), .forwardB_branch(forwardB_branch));

MUX_2x1_nbit  #(32) MUX_ForwardA(.a(ID_EX_read_data1), .b(write_data), .sel(forwardA_ALU), .out(forwarded_A_ALU));
MUX_2x1_nbit  #(32) MUX_ForwardB(.a(ID_EX_read_data2), .b(write_data), .sel(forwardB_ALU), .out(forwarded_B_ALU));

MUX_2x1_nbit  #(32) MUX_RF(.a(forwarded_B_ALU), .b(ID_EX_gen_out), .sel(ID_EX_ALU_Src), .out(ALU_second_input));

ALU_Control_Unit ALU_CU(.ALUOp(ID_EX_ALU_Op), .inst(ID_EX_inst), .ALU_selection(ALU_selection));

                            
ALU_nbit #(32)ALU(.A(forwarded_A_ALU), .B(ALU_second_input), .alu_control(ALU_selection), .ALUout(ALU_out), 
                    .Z(Z), .V(V), .C(C), .S(S));
//////////////////////// EX ends //////////////////////////////////////////////////////////////////////////////////////////// 


register_nbit #(200) EX_MEM (~sclk, rst,`ONE,
    {ID_EX_mem_read, ID_EX_mem_to_reg, ID_EX_mem_write, ID_EX_reg_write, ID_EX_signed_inst, 
    ID_EX_AU_inst_sel, ID_EX_RF_MUX_sel, ID_EX_PC_4, ALU_out, ID_EX_inst[11:7], forwarded_B_ALU, b_add_out},
    {EX_MEM_mem_read, EX_MEM_mem_to_reg, EX_MEM_mem_write, EX_MEM_reg_write, 
     EX_MEM_signed_inst, EX_MEM_AU_inst_sel, EX_MEM_RF_MUX_sel, EX_MEM_PC_4, EX_MEM_ALU_out, EX_MEM_write_reg, EX_MEM_read_data2, EX_MEM_b_add_out}
    );


//////////////////////// MEM begins ///////////////////////////////////////////////////////////////////////////////////////////

MUX_2x1_nbit  #(32) MUX_Mem(.a(EX_MEM_ALU_out), .b(mem_out), .sel(EX_MEM_mem_to_reg), .out(mem_MUX_out));

//////////////////////// MEM ends //////////////////////////////////////////////////////////////////////////////////////////

register_nbit #(200) MEM_WB (sclk, rst,`ONE,
    {EX_MEM_reg_write, EX_MEM_RF_MUX_sel, EX_MEM_PC_4, EX_MEM_b_add_out, mem_MUX_out, EX_MEM_write_reg},
    {MEM_WB_reg_write, MEM_WB_RF_MUX_sel, MEM_WB_PC_4, MEM_WB_b_add_out, MEM_WB_mem_MUX_out,
    MEM_WB_write_reg}
    );

////////////////////// WB begins //////////////////////////////////////////////////////////

three_input_Mux_nbit RF_MUX(.a(MEM_WB_mem_MUX_out), .b(MEM_WB_b_add_out), .c(MEM_WB_PC_4), .out(write_data), .sel(MEM_WB_RF_MUX_sel));
///////////////////// WB ends //////////////////////////////////////////////////////////////////



endmodule
