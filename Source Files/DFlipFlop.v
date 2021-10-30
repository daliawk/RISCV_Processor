`timescale 1ns / 1ps
`include "C:\Users\Kirolos Mikhail\Github\RISCV_Processor\Source Files\defines.v"
/*******************************************************************
*
* Module: DFlipFlop.v
* Project: RISCV_Processor
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed Talaat - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
* Description: This is a module of a D-Flipflop
*
* Change history: 10/29/21 – Applied coding guidelines
*
**********************************************************************/


module DFlipFlop (
    input clk, 
    input rst, 
    input D, 
    output reg Q
    ); 
    
    always @ (posedge clk or posedge rst) 
        if (rst) begin // Reseting the flipflop
            Q <= `ZERO; 
        end 
        else begin 
            Q <= D; 
        end 
endmodule 