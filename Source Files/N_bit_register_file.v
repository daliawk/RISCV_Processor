`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2021 08:59:53 AM
// Design Name: 
// Module Name: register_file
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


module  N_bit_register_file #(parameter n=32)(
    input rst,
    input clk,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [n-1:0] write_data,
    input write,
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
            load = 0;
            load = 32'b1 << write_reg;
        end
        else
            load = 32'b0;
            
    end
        assign Q[0] = 32'b0;
    genvar i;
    for(i=1; i<32; i=i+1) begin:loop1
        N_Bit_Register #(n) reg0 (.rst(rst), .load(load[i]), .clk(clk), .D(write_data), .Q(Q[i]));
    end
    
endmodule
