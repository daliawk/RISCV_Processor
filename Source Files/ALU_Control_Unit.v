`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2021 09:15:38 AM
// Design Name: 
// Module Name: ALU_Control_Unit
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


module ALU_Control_Unit(input [1:0] ALUOp, input [31:0] Inst, output reg [3:0] ALU_Selection);

always @(*)
begin
case(ALUOp)
2'b00:
    begin
    ALU_Selection = 4'b0010;
    end
2'b01:
    begin
    ALU_Selection = 4'b0110;
    end   
2'b10:
    begin
    case(Inst[14:12])
    3'b000:
    begin
    if(Inst[30] == 1)
    ALU_Selection = 4'b0110;
    else 
    if(Inst[30] == 0)
    ALU_Selection = 4'b0010;
    end
    3'b111: 
    begin
    if(Inst[30] == 0)
    ALU_Selection = 4'b0000;
    else ALU_Selection = 4'b1111;
    end
    3'b110: 
    begin 
    if(Inst[30] == 0)
    ALU_Selection = 4'b0001;
    else ALU_Selection = 4'b1111;
    end
    default: ALU_Selection = 4'b1111;
    endcase     
    end
default: ALU_Selection = 4'b1111;
endcase          
end



endmodule
