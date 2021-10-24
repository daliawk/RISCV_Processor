`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 10:25:27 AM
// Design Name: 
// Module Name: ImmGen
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


module ImmGen(output reg [31:0] gen_out, input [31:0] inst);

always @(*) begin

   if(inst[6]==0)
   begin
        if(inst[5]==0) 
        begin
            gen_out = {{20{inst[31]}} , inst[31:20]};  //lw
        end
        else 
        begin
            gen_out = {{20{inst[31]}} , inst[31:25], inst[11:7]};
        end
   end
   else 
   begin
        gen_out = {{20{inst[31]}} , inst[31], inst[7], inst[30:25], inst[11:8]};
   end



end


endmodule
