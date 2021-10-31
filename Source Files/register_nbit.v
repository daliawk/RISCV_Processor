`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: register_nbit.v
* Project: RISCV_Processor
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed Talaat - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
* Description: This is a module of an n-bit register
*
* Change history: 10/29/21 – Applied coding guidelines
*
**********************************************************************/


module register_nbit #(parameter n = 32) (
    input clk,
    input rst,
    input load,
    input [n-1:0] D,
    output [n-1:0] Q
    );
    
    wire [n-1:0] ff_in;
    
    genvar i;
    for(i=0; i<n; i=i+1) begin: loop
        MUX_2x1_1bit mux (.a(Q[i]), .b(D[i]), .sel(load), .out(ff_in[i]));
        DFlipFlop dff (.clk(clk), .rst(rst), .D(ff_in[i]), .Q(Q[i])); 
    end
    
endmodule
