`timescale 1ns / 1ps
/*******************************************************************
*
* Module: MUX_2x1_1bit.v
* Project: Project 1: femtoRV32
* Author: Kareem A. Mohammed Talaat - kareemamr213@aucegypt.edu
* Description: A simple 1-bit multiplexer module.
*
* Change history: 29/10/21 – Updated the module according the Verilog coding guidelines.
*
*
**********************************************************************/


module MUX_2x1_1bit(
    input a,
    input b,
    input sel,
    output out
    );
    
    wire a_o; //temporary wires
    wire b_o;
    
    assign a_o = a & (~sel); //out = input1 when select is 0
    assign b_o = a & sel; //out = input2 when select is 1
    assign out = a_o | b_o; 

endmodule
