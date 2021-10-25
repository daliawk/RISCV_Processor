`timescale 1ns / 1ps
`include defines.v
/********************************************************************* 
* Module: ALU_.v 
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


module ALU_Control_Unit(
    input [1:0] ALUOp,
    input [31:0] inst, 
    output reg [3:0] ALU_selection
    );

    always @(*)
    begin
    case(ALUOp)
    2'b00: 
        begin
        ALU_selection = 4'b0010;
        end
    2'b01: 
        begin
        ALU_selection = 4'b0110;
        end   
    2'b10:
        begin
        case(inst[14:12])
        3'b000:
        begin
        if(inst[30] == 1)
        ALU_selection = 4'b0110;
        else 
        if(inst[30] == 0)
        ALU_selection = 4'b0010;
        end
        3'b111: 
        begin
        if(inst[30] == 0)
        ALU_selection = 4'b0000;
        else ALU_selection = 4'b1111;
        end
        3'b110: 
        begin 
        if(inst[30] == 0)
        ALU_selection = 4'b0001;
        else ALU_selection = 4'b1111;
        end
        default: ALU_selection = 4'b1111;
        endcase     
        end
    default: ALU_selection = 4'b1111;
    endcase          
    end

endmodule
