`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2021 09:40:21 AM
// Design Name: 
// Module Name: CPU_TB
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


module CPU_TB;
reg clk;
reg rst;
    CPU cpu(clk,rst);
    
    
    always begin
    clk = 1;
    forever #10 clk = ~clk;
    end
    
    initial begin
    rst = 1;
    #9
    rst = 0;
    #450;
    
    end
    
    
    
endmodule
