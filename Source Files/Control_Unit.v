`timescale 1ns / 1ps
/********************************************************************* 
* Module:   Control_Unit.v 
* Project:  RISCV_PROCESSOR 
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
* Change history: 29/10/21 – Editing the module to support all of RISC-V instructions instead of only 7 instructions.
*
*
**********************************************************************/
`include "C:\Users\Kirolos Mikhail\Github\RISCV_Processor\Source Files\defines.v"




module Control_Unit(
    input [31:0] inst, 
    output reg branch,
    output reg jump, 
    output reg mem_read, 
    output reg mem_to_reg, 
    output reg mem_write, 
    output reg ALU_Src, 
    output reg reg_write,
    output reg signed_inst,
    output reg [1:0] RF_MUX_sel,
    output reg [1:0] AU_inst_sel, 
    output reg [1:0] ALU_Op);

always @(*) begin
    case(inst[6:2]) //inst[6:2]
        `OPCODE_LUI :
            begin
                branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0;
                ALU_Op = 2'b11; mem_write = 0; ALU_Src = 1; 
                reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                RF_MUX_sel = 2'b00;
            end
        `OPCODE_AUIPC :
            begin
                branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                ALU_Op = 2'b11; mem_write = 0; ALU_Src = 1;
                reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                RF_MUX_sel = 2'b01;
            end
        `OPCODE_JAL : 
            begin
                branch = 0; jump = 1; mem_read = 0; mem_to_reg = 0; 
                ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                RF_MUX_sel = 2'b10;
            end
        `OPCODE_JALR : 
            begin
                branch = 0; jump = 1; mem_read = 0; mem_to_reg = 0;
                ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1;
                reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                RF_MUX_sel = 2'b10;
            end
        `OPCODE_Branch : //All branching instructions
            begin
                case(inst[14:12]) //funct3
                    `BR_BEQ : 
                        begin
                            branch = 1; jump = 0; mem_read = 0; mem_to_reg = 0;
                            ALU_Op = 2'b01; mem_write = 0; ALU_Src = 0;
                            reg_write = 0; signed_inst = 1; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    `BR_BNE :
                        begin
                            branch = 1; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b01; mem_write = 0; ALU_Src = 0; 
                            reg_write = 0; signed_inst = 1; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    `BR_BLT :
                        begin
                            branch = 1; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b01; mem_write = 0; ALU_Src = 0; 
                            reg_write = 0; signed_inst = 1; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    `BR_BGE :
                        begin
                            branch = 1; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b01; mem_write = 0; ALU_Src = 0; 
                            reg_write = 0; signed_inst = 1; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    `BR_BLTU :
                        begin
                            branch = 1; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b01; mem_write = 0; ALU_Src = 0; 
                            reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    `BR_BGEU : 
                        begin
                            branch = 1; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b01; mem_write = 0; ALU_Src = 0; 
                            reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    default : 
                        begin
                            branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; 
                            reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                endcase
            end
        `OPCODE_Load : //All load instructions
            begin
                case(inst[14:12]) //Instruction[14:12]
                    `F3_LB :
                        begin
                            branch = 0; jump = 0; mem_read = 1; mem_to_reg = 1; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                            reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b10;
                            RF_MUX_sel = 2'b00;
                        end
                    `F3_LH : 
                        begin
                            branch = 0; jump = 0; mem_read = 1; mem_to_reg = 1; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                            reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b01;     
                            RF_MUX_sel = 2'b00;               
                        end
                    `F3_LW :
                        begin
                            branch = 0; jump = 0; mem_read = 1; mem_to_reg = 1; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                            reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    `F3_LBU: 
                        begin
                            branch = 0; jump = 0; mem_read = 1; mem_to_reg = 1; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                            reg_write = 1;  signed_inst = 0; AU_inst_sel = 2'b10;
                            RF_MUX_sel = 2'b00;
                        end
                    `F3_LHU :
                        begin
                            branch = 0; jump = 0; mem_read = 1; mem_to_reg = 1; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                            reg_write = 1;  signed_inst = 0; AU_inst_sel = 2'b01;
                            RF_MUX_sel = 2'b00;
                        end
                    default : 
                        begin
                            branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; 
                            reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                endcase
            end
        `OPCODE_Store : //All storing instructions
            begin
                case(inst[14:12]) //Instruction[14:12]
                    `F3_SB : 
                        begin
                            branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b00; mem_write = 1; ALU_Src = 1; 
                            reg_write = 0;  signed_inst = 1; AU_inst_sel = 2'b10;
                            RF_MUX_sel = 2'b00;
                        end
                    `F3_SH : 
                        begin
                            branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b00; mem_write = 1; ALU_Src = 1; 
                            reg_write = 0;  signed_inst = 1; AU_inst_sel = 2'b01;
                            RF_MUX_sel = 2'b00;
                        end
                    `F3_SW :
                        begin
                            branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b00; mem_write = 1; ALU_Src = 1; 
                            reg_write = 0;  signed_inst = 1; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    default : 
                        begin
                            branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; 
                            reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                endcase
            end
        `OPCODE_Arith_I : //All I-type instructions
            begin
                case(inst[14:12]) //Instruction[14:12]
                    `F3_ADDI :
                        begin
                            branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                            reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    `F3_SLTI :
                        begin
                            branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                            reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    `F3_SLTIU : 
                        begin
                            branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                            reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    `F3_XORI : 
                        begin
                            branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                            reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    `F3_ORI :
                        begin
                            branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                            reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    `F3_ANDI : 
                        begin
                            branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                            reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    `F3_SLLI :
                        begin
                            branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                            reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end
                    `F3_SRAI_SRLI : //Function 3 for SRAI and SRLI is the same
                        begin
                            case (inst[31:25]) //Instruction [31:25]
                                `F7_SRAI :
                                    begin
                                        branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                                        ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                                        reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                                        RF_MUX_sel = 2'b00;
                                    end 
                                `F7_SRLI :
                                    begin
                                        branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                                        ALU_Op = 2'b00; mem_write = 0; ALU_Src = 1; 
                                        reg_write = 1;  signed_inst = 1; AU_inst_sel = 2'b00;
                                        RF_MUX_sel = 2'b00;
                                    end
                                default : 
                                    begin
                                    branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                                    ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; 
                                    reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                                    RF_MUX_sel = 2'b00;
                                    end
                            endcase
                        end
                    default : 
                        begin
                            branch = 0;jump = 0; mem_read = 0; mem_to_reg = 0; 
                            ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0;
                            reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                            RF_MUX_sel = 2'b00;
                        end    
                endcase
            end
        `OPCODE_Arith_R : //All R-Type instructions
            begin
                case(inst[14:12]) //Instruction [14:12]
                `F3_ADD_SUB : //Function 3 of add and sub instructions is the same
                    begin
                        case (inst[31:25]) //Instruction [31:25]
                            `F7_ADD :
                                begin
                                    branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                                    ALU_Op = 2'b10; mem_write = 0; ALU_Src = 0; 
                                    reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                                    RF_MUX_sel = 2'b00;
                                end 
                            `F7_SUB :
                                begin
                                    branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                                    ALU_Op = 2'b10; mem_write = 0; ALU_Src = 0; 
                                    reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                                    RF_MUX_sel = 2'b00;
                                end
                            default : 
                                begin
                                    branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                                    ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; 
                                    reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                                    RF_MUX_sel = 2'b00;
                                end      
                        endcase
                    end
                `F3_SLL :
                    begin
                        branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                        ALU_Op = 2'b10; mem_write = 0; ALU_Src = 0; 
                        reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                        RF_MUX_sel = 2'b00;
                    end 
                `F3_SLT :
                    begin
                        branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                        ALU_Op = 2'b10; mem_write = 0; ALU_Src = 0; 
                        reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                        RF_MUX_sel = 2'b00;
                    end
                `F3_SLTU :
                    begin
                        branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                        ALU_Op = 2'b10; mem_write = 0; ALU_Src = 0; 
                        reg_write = 1; signed_inst = 0; AU_inst_sel = 2'b00;
                        RF_MUX_sel = 2'b00;
                    end
                `F3_XOR :
                    begin
                        branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                        ALU_Op = 2'b10; mem_write = 0; ALU_Src = 0; 
                        reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                        RF_MUX_sel = 2'b00;
                    end
                `F3_SRL_SRA : //Function 3 of SRL and SRA instructions is the same
                    begin
                        case (inst[31:25]) //Instuction[31:25]
                            `F7_SRL : 
                                begin
                                    branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                                    ALU_Op = 2'b10; mem_write = 0; ALU_Src = 0; 
                                    reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                                    RF_MUX_sel = 2'b00;
                                end
                            `F7_SRA : 
                                begin
                                    branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                                    ALU_Op = 2'b10; mem_write = 0; ALU_Src = 0; 
                                    reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                                    RF_MUX_sel = 2'b00;
                                end
                            default : 
                                begin
                                    branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                                    ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; 
                                    reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                                    RF_MUX_sel = 2'b00;
                                end
                        endcase
                    end
                `F3_OR :
                    begin
                        branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                        ALU_Op = 2'b10; mem_write = 0; ALU_Src = 0; 
                        reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                        RF_MUX_sel = 2'b00;
                    end
                `F3_AND :
                    begin
                        branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                        ALU_Op = 2'b10; mem_write = 0; ALU_Src = 0; 
                        reg_write = 1; signed_inst = 1; AU_inst_sel = 2'b00;
                        RF_MUX_sel = 2'b00;
                    end
                default : 
                    begin
                        branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                        ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; 
                        reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                        RF_MUX_sel = 2'b00;
                    end
                endcase
            end
        default : 
            begin
                branch = 0; jump = 0; mem_read = 0; mem_to_reg = 0; 
                ALU_Op = 2'b00; mem_write = 0; ALU_Src = 0; 
                reg_write = 0; signed_inst = 0; AU_inst_sel = 2'b00;
                RF_MUX_sel = 2'b00;
            end
    endcase
end

endmodule
