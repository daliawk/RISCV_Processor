`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2021 09:05:14 AM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(input [31:0] Inst, output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, output reg [1:0] ALUOp);

always @(*) begin
case(Inst[6:2])
5'b01100 : 
    begin 
    Branch = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b10; MemWrite = 0; ALUSrc = 0; RegWrite = 1;
    end
5'b00000 :
    begin 
    Branch = 0; MemRead = 1; MemtoReg = 1; ALUOp = 2'b00; MemWrite = 0; ALUSrc = 1; RegWrite = 1;
    end
5'b01000 : 
    begin 
    Branch = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b00; MemWrite = 1; ALUSrc = 1; RegWrite = 0;
    end
5'b11000 : 
    begin 
    Branch = 1; MemRead = 0; MemtoReg = 0; ALUOp = 2'b01; MemWrite = 0; ALUSrc = 0; RegWrite = 0;
    end
default: begin 
        Branch = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b00; MemWrite = 0; ALUSrc = 0; RegWrite = 0;
        end
endcase
end

endmodule
