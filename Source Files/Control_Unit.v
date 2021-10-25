`timescale 1ns / 1ps
/******************************************************************* * 
* Module:   Control_Unit.v 
* Project:  RISCV_PROCESSOR 
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
*
* Description: This is the control unit (the brains of the processor) 
* 
* Change history: 10/25/21 – modified naming to follow coding guidlines
* 
**********************************************************************/ 



module Control_Unit(input [31:0] inst, output reg branch, mem_read, mem_to_reg,
                         mem_write, ALUSrc, reg_write, output reg [1:0] ALUOp);

    always @(*) begin
        case(inst[6:2])

            5'b01100 : 
                begin 
                    branch = 0; mem_read = 0; mem_to_reg = 0; ALUOp = 2'b10;
                    mem_write = 0; ALUSrc = 0; reg_write = 1;
                end

            5'b00000 :
                begin 
                    branch = 0; mem_read = 1; mem_to_reg = 1; ALUOp = 2'b00;
                    mem_write = 0; ALUSrc = 1; reg_write = 1;
                end

            5'b01000 : 
                begin 
                    branch = 0; mem_read = 0; mem_to_reg = 0; ALUOp = 2'b00;
                    mem_write = 1; ALUSrc = 1; reg_write = 0;
                end

            5'b11000 : 
                begin 
                    branch = 1; mem_read = 0; mem_to_reg = 0; ALUOp = 2'b01;
                    mem_write = 0; ALUSrc = 0; reg_write = 0;
                end

            default:
                begin 
                    branch = 0; mem_read = 0; mem_to_reg = 0; ALUOp = 2'b00;
                    mem_write = 0; ALUSrc = 0; reg_write = 0;
                end
                
        endcase
    end

endmodule
