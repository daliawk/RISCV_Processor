`timescale 1ns / 1ps
    /********************************************************************* 
* Module: FA_1bit.v 
* Project: RISV_Processor 
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed Talaat - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
* 
* Description: 1 bit full adder
*
* Change history: 10/25/21 – Modified file to follow code guidelines 
* 
**********************************************************************/ 
module adder(
    input cin,
    input a,
    input b,
    output cout,
    output s
);
    assign {cout,s} = a + b + cin;
endmodule
