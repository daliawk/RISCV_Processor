`timescale 1ns / 1ps
`include "C:\Users\Kirolos Mikhail\Github\RISCV_Processor\Source Files\defines.v"
/*******************************************************************
*
* Module: register_file_nbit.v
* Project: RISCV_Processor
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed Talaat - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
* Description: This is a module of an n-bit register file
*
* Change history: 10/29/21 – Applied coding guidelines
*
**********************************************************************/


module  register_file_nbit #(parameter n=32)(
    input clk,
    input rst,
    input write,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [n-1:0] write_data,
    output [n-1:0] read_data1,
    output [n-1:0] read_data2
    );
    
    reg [31:0] load;
    wire [n-1:0] Q [31:0];
    
    assign read_data1 = Q[read_reg1];
    assign read_data2 = Q[read_reg2];
    
    //Writing to 32 registers
    always@(*) begin
        if(write) begin
            load = `ZERO;
            load[write_reg] = `ONE;
        end
        else
            load = {32{`ZERO}};
            
    end
        assign Q[0] = {32{`ZERO}};
    
    genvar i;
    for(i=1; i<32; i=i+1) begin: loop1
        register_nbit #(n) reg0 (.clk(clk), .rst(rst), .load(load[i]), .D(write_data), .Q(Q[i]));
    end
    
endmodule
