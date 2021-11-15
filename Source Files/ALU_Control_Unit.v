`timescale 1ns / 1ps
`include "defines.v"
/********************************************************************* 
* Module: ALU_Control_Unit.v 
* Project: RISV_Processor 
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed Talaat - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
* 
* Description: The control of the ALU (gives out ALU controls)
*
* Change history: 10/25/21 – Modified file to follow code guidelines 
*                 10/29/21 - Modified to add the rest of the RV32I Instructions
*                 11/15/21 - Modified to add Multiplication and Division Instructions (M)
**********************************************************************/ 


module ALU_Control_Unit(
input [2:0] ALUOp,
input [31:0] inst, 
output reg [4:0] ALU_selection
);

    always @(*)
    begin
    case(ALUOp)

    3'b000: // ALL I and S format istructions
        begin
            case(inst[14:12])
                3'b000:
                    ALU_selection = `ALU_ADD;
                3'b001:
                if(inst[5:4]==2'b01)
                    ALU_selection = `ALU_SLL;
                else
                    ALU_selection = `ALU_ADD;
                   
                3'b010:
                begin
                    if(inst[5:4]==2'b01)
                        ALU_selection = `ALU_SLT;
                    else
                        ALU_selection = `ALU_ADD;
                end
                3'b011:
                    ALU_selection = `ALU_SLTU;
                3'b100:
                begin
                    if(inst[5:4]==2'b00)
                        ALU_selection = `ALU_ADD;
                    else
                        ALU_selection = `ALU_XOR;
                end
                3'b101:
                if(inst[5:4]==2'b00)
                    ALU_selection = `ALU_ADD;
                else if(inst[30]==0)
                    ALU_selection = `ALU_SRL;
                else
                    ALU_selection = `ALU_SRAI;

                3'b110:
                    ALU_selection = `ALU_OR;
                3'b111:
                    ALU_selection = `ALU_AND;
                default:
                    ALU_selection = 4'b0000;
        endcase
        end
    
    3'b001: // all branch and jal statements
        begin
            ALU_selection = `ALU_SUB;
        end   
    
    3'b010: // R-format functions
        begin
        case(inst[14:12])

            3'b000:
            begin
                if(inst[30] == 1)
                    ALU_selection = `ALU_SUB;
                else if(inst[30] == 0)
                    ALU_selection = `ALU_ADD;
            end

            3'b001:
                ALU_selection = `ALU_SLL;

            3'b010:
                ALU_selection = `ALU_SLT;

            3'b011:
                ALU_selection = `ALU_SLTU;

            3'b100:
                ALU_selection = `ALU_XOR;

            3'b101:
            begin
                if (inst[30])
                    ALU_selection = `ALU_SRA;
                else
                    ALU_selection = `ALU_SRL;
            end

            3'b110:
                ALU_selection = `ALU_OR;

            3'b111: 
                ALU_selection = `ALU_AND;
            default:
                    ALU_selection = 4'b0000;    
        endcase     
        end

    3'b011: // LUI and AUIPC
    ////////////////////////////////// add to defines file
        ALU_selection = `ALU_PASS;
    3'b100: //M-type instructions (Division and Multiplication)
        begin
            case (inst[14:12])
                `F3_MUL: 
                    ALU_selection = `ALU_MUL;
                `F3_MULH: 
                    ALU_selection = `ALU_MULH;
                `F3_MULHSU: 
                    ALU_selection = `ALU_MULHSU;
                `F3_MULHU: 
                    ALU_selection = `ALU_MULHU;
                `F3_DIV: 
                    ALU_selection = `ALU_DIV;
                `F3_DIVU: 
                    ALU_selection = `ALU_DIVU;
                `F3_REM: 
                    ALU_selection = `ALU_REM;
                `F3_REMU: 
                    ALU_selection = `ALU_REMU;
                default:
                    ALU_selection = 4'b0000;
            endcase
        end
    default: ALU_selection = `ALU_ADD;
    endcase          
    end

endmodule
