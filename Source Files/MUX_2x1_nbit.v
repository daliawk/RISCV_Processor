`timescale 1ns / 1ps
/*******************************************************************
*
* Module: MUX_2x1_nbit.v
* Project: Project 1: femtoRV32
* Author: Kareem A. Mohammed Talaat - kareemamr213@aucegypt.edu
* Description: An n_bit 2x1 multiplexer. Calls the 1 bit multiplexer n times.
*
* Change history: 29/10/21 – Updated the module according the Verilog coding guidelines.
*
*
**********************************************************************/


module MUX_2x1_nbit  #(parameter N = 8)(
	input [N-1:0] a, 
	input [N-1:0] b, 
	input sel, 
	output [N-1:0] out
	);

	genvar i; //Temporary variable to loop with.

	for(i=0; i < N; i = i+1) //Creating n 1-bit MUXs to output the n bit result of the n-bit MUX in end.
	begin: loop1
		MUX_2x1_1bit M (.a(a[i]), .b(b[i]), .sel(sel), .out(out[i]));
	end

endmodule

