`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 10:01:56 AM
// Design Name: 
// Module Name: n_bit_2x1_Multiplexer
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


module n_bit_2x1_Multiplexer  #(parameter n = 8)(input [n-1:0] A, input [n-1:0] B, input s, output [n-1:0] out);

genvar i;


	for(i=0; i < n; i = i+1) 
	begin: gen1
		MUX M (A[i], B[i], s, out[i]);
	end


endmodule

