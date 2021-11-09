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
input  MEM_WB_RegWrite,
input [4:0] MEM_WB_RegisterRd,
output reg forwardA,
output reg  forwardB
    );
    always@(*) 
        begin
           if ((MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0))
               &&(MEM_WB_RegisterRd == ID_EX_RegisterRs1))
                    forwardA = 1'b1; 
           else forwardA = 1'b0;
       
          begin
              if ( MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0)
                &&(MEM_WB_RegisterRd == ID_EX_RegisterRs2))
                     forwardB = 1'b1;               
           else forwardB = 1'b0;
        end
       end
endmodule
