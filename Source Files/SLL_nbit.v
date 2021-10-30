`timescale 1ns / 1ps
/********************************************************************* 
* Module:   SLL_nbit.v 
* Project:  RISCV_PROCESSOR 
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
*
* Description: This is an nbit shift left by one module 
* 
* Change history: 10/29/21 – modified to follow coding guidlines
*
**********************************************************************/ 


module SLL_nbit #(parameter n = 8)(
input [n-1:0] a,
output [n-1:0] b);

    assign b = {a[n-2:0],`ZERO};

endmodule