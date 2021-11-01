`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Data_Mem.v
* Project: Project 1: femtoRV32
* Author: Kareem A. Mohammed Talaat - kareemamr213@aucegypt.edu
* Description: A module that represents the data memory which does the following: reading from the memory, and writing to the memory if specified.
*
* Change history: 29/10/21 – Updated the module according the Verilog coding guidelines.
*
*
**********************************************************************/

module Data_Mem(
    input clk, 
    input mem_read, 
    input mem_write,
    input [5:0] addr, 
    input [31:0] data_in, 
    output [31:0] data_out
    );
    reg [31:0] mem [0:63]; //Memory that has 64 slots, each slot 32 bits in width.

    initial //Initial values for testbench testing.
        begin
             mem[0]=32'd1;
             mem[1]=32'd5; 
//            mem[0]=32'd17; 
//            mem[1]=32'd9;
//            mem[2]=32'd25; 
        end
    
    always @(posedge clk) //On the positive edge of the clock, if mem_write coming from the control unit is 1, then write into the memory the specified input data                     
    begin //in the specified address, else do not update the memory.
        if (mem_write == 1)
            begin
                mem[addr] = data_in;
            end
        else
            begin
                mem[addr] = mem[addr];
            end 
    end

    assign data_out = (mem_read)? mem[addr]:32'd0; //If memory read coming from the control unit is 1, then read the memory in the specified address, else output data = 0.
    
endmodule
