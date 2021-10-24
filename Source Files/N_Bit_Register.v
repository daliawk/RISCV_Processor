`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2021 09:00:33 AM
// Design Name: 
// Module Name: N_Bit_Register
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


module N_Bit_Register #(parameter n = 8) (
    input rst,
    input load,
    input clk,
    input [n-1:0] D,
    output [n-1:0] Q
    );
    
    wire [n-1:0] ff_in;
    
    genvar i;
    for(i=0; i<n; i=i+1) begin: gen1
        MUX mux (.A(Q[i]), .B(D[i]), .S(load), .C(ff_in[i]));
        DFlipFlop dff (.clk(clk), .rst(rst), .D(ff_in[i]), .Q(Q[i])); 
    end
    
endmodule
