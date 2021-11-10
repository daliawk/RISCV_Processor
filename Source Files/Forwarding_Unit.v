`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2021 09:03:04 AM
// Design Name: 
// Module Name: Forwarding_Unit
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


module Forwarding_Unit(
input [4:0] ID_EX_RegisterRs1,
input [4:0] ID_EX_RegisterRs2,
input [4:0] IF_ID_RegisterRs1,
input [4:0] IF_ID_RegisterRs2,
input  MEM_WB_RegWrite,
input  EX_MEM_RegWrite,
input [4:0] MEM_WB_RegisterRd,
input [4:0] EX_MEM_RegisterRd,
output reg forwardA_ALU,
output reg  forwardB_ALU,
output reg forwardA_branch,
output reg  forwardB_branch
    );
    always@(*) 
        // Forwarding to ALU
        begin
           if ((MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0))
               &&(MEM_WB_RegisterRd == ID_EX_RegisterRs1))
                    forwardA_ALU = 1'b1; 
           else forwardA_ALU = 1'b0;
       
           if ( MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0)
                &&(MEM_WB_RegisterRd == ID_EX_RegisterRs2))
                     forwardB_ALU = 1'b1;               
           else forwardB_ALU = 1'b0;
        
        // Forwarding for branching
           if ((EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0))
               &&(EX_MEM_RegisterRd == IF_ID_RegisterRs1))
                    forwardA_branch = 1'b1; 
           else forwardA_branch = 1'b0;
              if ( EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0)
                &&(EX_MEM_RegisterRd == IF_ID_RegisterRs2))
                     forwardB_branch = 1'b1;               
           else forwardB_branch = 1'b0;
       end
endmodule
