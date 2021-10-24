`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 10:07:52 AM
// Design Name: 
// Module Name: MUX
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


module MUX(
    input A,
    input B,
    input S,
    output C
    );
    
    wire a_o, b_o;
    
    assign a_o = A & (~S);
    assign b_o = B & S;
    assign C = a_o | b_o;
    
    
endmodule
