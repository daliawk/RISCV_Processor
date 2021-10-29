
`timescale 1ns / 1ps
/******************************************************************* * 
* Module:   Seven_Segment_Display.v 
* Project:  RISCV_PROCESSOR 
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
*
* Description: this module adds to nbit numbers together giving out the
*              sum and the carry out
* 
* Change history: 10/29/21 – modified to follow coding guidlines
*
**********************************************************************/ 

module Ripple_Carry_Adder_nbit #(parameter n=32)(
input  [n-1:0] A,
input  [n-1:0] B,
input   Cin,
output [n-1:0] S,
output Cout);

    wire c[n:0] ;

    // assignment of first carry bit to carry in
    assign c[0] = Cin;

    // adding all bits sequentially in a for loop
    // by calling the one-bit adder function
    genvar i;
    for (i=0; i<n; i=i+1) begin: loop
        adder u1 (c[i],A[i],B[i],c[i+1],S[i]);
    end

    // assignment of last carry bit to the carry out
    assign Cout = c[n];

endmodule