`timescale 1ns / 1ps
`include defines.v
/*******************************************************************
*
* Module: Control_Unit.v
* Project: Project 1: femtoRV32
* Author: Kareem A. Mohammed Talaat - kareemamr213@aucegypt.edu
* Description: A module that controls most of the other components in the risc-v implementation (MUXs, Register file, Memory, etc) 
* which depends on the type of the instruction it takes as an input.
*
* Change history: 29/10/21 – Editing the module to support all of RISC-V instructions instead of only 7 instructions.
*
*
**********************************************************************/


module Control_Unit(
    input [31:0] inst, 
    output reg jump, 
    mem_read, 
    mem_to_reg, 
    mem_write, 
    ALU_Src, 
    reg_write,
    signed_inst,
    output reg [1:0] AU_inst_sel, 
    output reg [1:0] ALU_Op);

always @(*) begin
    case(IR_opcode) //inst[6:2]
        `OPCODE_LUI :
            begin
                jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 1; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
            end
        `OPCODE_AUIPC :
            begin
                jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 1; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
            end
        `OPCODE_JAL : 
            begin
                jump = 1; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 1; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
            end
        `OPCODE_JALR : 
            begin
                jump = 1; mem_read = 0; mem_to_reg = 0; ALU_Op /*change*/; mem_write = 0; ALU_Src = 1; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
            end
        `OPCODE_Branch : //All branching instructions
            begin
                case(`IR_funct3) //instruction[14:12]
                    `BR_BEQ : 
                        begin
                            jump = 1; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b01; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 1; AU_inst_sel = 2'b00;
                        end
                    `BR_BNE :
                        begin
                            jump = 1; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b01; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 1; AU_inst_sel = 2'b00;
                        end
                    `BR_BLT :
                        begin
                            jump = 1; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b01; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 1; AU_inst_sel = 2'b00;
                        end
                    `BR_BGE :
                        begin
                            jump = 1; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b01; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 1; AU_inst_sel = 2'b00;
                        end
                    `BR_BLTU :
                        begin
                            jump = 1; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b01; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                        end
                    `BR_BGEU : 
                        begin
                            jump = 1; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b01; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                        end
                    default : 
                        begin
                            jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                        end
                endcase
            end
        `OPCODE_Load : //All load instructions
            begin
                case(`IR_funct3) //Instruction[14:12]
                    `F3_LB :
                        begin
                            jump = 0; mem_read = 1; mem_to_reg = 1; ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b10;
                        end
                    `F3_LH : 
                        begin
                            jump = 0; mem_read = 1; mem_to_reg = 1; ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b01;                    end
                    `F3_LW :
                        begin
                            jump = 0; mem_read = 1; mem_to_reg = 1; ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                        end
                    `F3_LBU: 
                        begin
                            jump = 0; mem_read = 1; mem_to_reg = 1; ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; reg_write = 1;  signed_inst = 0; AU_inst_sel = 2'b10;
                        end
                    `F3_LHU :
                        begin
                            jump = 0; mem_read = 1; mem_to_reg = 1; ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; reg_write = 1;  signed_inst = 0; AU_inst_sel = 2'b01;
                        end
                    default : 
                        begin
                            jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                        end
                endcase
            end
        `OPCODE_Store : //All storing instructions
            begin
                case(`IR_funct3) //Instruction[14:12]
                    `F3_SB : 
                        begin
                            jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b00; mem_write = 1; ALU_Src = 1; reg_write = 0;  signed_inst = 1; AU_inst_sel = 2'b10;
                        end
                    `F3_SH : 
                        begin
                            jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b00; mem_write = 1; ALU_Src = 1; reg_write = 0;  signed_inst = 1; AU_inst_sel = 2'b01;
                        end
                    `F3_SW :
                        begin
                            jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b00; mem_write = 1; ALU_Src = 1; reg_write = 0;  signed_inst = 1; AU_inst_sel = 2'b00;
                        end
                    default : 
                        begin
                            jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                        end
                endcase
            end
        `OPCODE_Arith_I : //All I-type instructions
            begin
                case(`IR_funct3) //Instruction[14:12]
                    `F3_ADDI :
                        begin
                            jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 1; reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                        end
                    `F3_SLTI :
                        begin
                            jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 1; reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                        end
                    `F3_SLTIU : 
                        begin
                            jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 1; reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                        end
                    `F3_XORI : 
                        begin
                            jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 1; reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                        end
                    `F3_ORI :
                        begin
                            jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 1; reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                        end
                    `F3_ANDI : 
                        begin
                            jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 1; reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                        end
                    `F3_SLLI :
                        begin
                            jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 1; reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                        end
                    `F3_SRAI_SRLI : //Function 3 for SRAI and SRLI is the same
                        begin
                            case (`IR_funct7)) //Instruction [31:25]
                                `F7_SRAI :
                                    begin
                                        jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 1; reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                                    end 
                                `F7_SRLI :
                                    begin
                                        jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 1; reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                                    end
                                default : 
                                    begin
                                    jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                                    end
                            endcase
                        end
                    default : 
                        begin
                            jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                        end    
                endcase
            end
        `OPCODE_Arith_R : //All R-Type instructions
            begin
                case(`IR_funct3) //Instruction [14:12]
                `F3_ADD_SUB : //Function 3 of add and sub instructions is the same
                    begin
                        case (`IR_funct7) //Instruction [31:25]
                            `F7_ADD :
                                begin
                                    jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 0; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                                end 
                            `F7_SUB :
                                begin
                                    jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 0; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                                end
                            default : 
                                begin
                                    jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                                end      
                        endcase
                    end
                `F3_SLL :
                    begin
                        jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 0; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                    end 
                `F3_SLT :
                    begin
                        jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 0; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                    end
                `F3_SLTU :
                    begin
                        jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 0; reg_write = 1; signed_inst = 0; AU_inst_sel = 2'b00;
                    end
                `F3_XOR :
                    begin
                        jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 0; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                    end
                `F3_SRL_SRA : //Function 3 of SRL and SRA instructions is the same
                    begin
                        case (`IR_funct7) //Instuction[31:25]
                            F7_SRL : 
                                begin
                                    jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 0; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                                end
                            F7_SRA : 
                                begin
                                    jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 0; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                                end
                            default : 
                                begin
                                    jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                                end
                        endcase
                    end
                `F3_OR :
                    begin
                        jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 0; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                    end
                `F3_AND :
                    begin
                        jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = /*change*/; mem_write = 0; ALU_Src = 0; reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                    end
                default : 
                    begin
                        jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                    end
                endcase
            end
        default : 
            begin
                jump = 0; mem_read = 0; mem_to_reg = 0; ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
            end
    endcase
end

endmodule
