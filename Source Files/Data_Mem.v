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
    input [1:0] AU_inst_sel,
    input signed_inst,
    input [5:0] addr, 
    input [31:0] data_in, 
    output reg [31:0] data_out
    );
    reg [31:0] mem [0:63]; //Memory that has 64 slots, each slot 32 bits in width.

    initial //Initial values for testbench testing.
        begin
             mem[0]=4'd1;
             mem[1]=4'd5; 
//            mem[0]=4'd17; 
//            mem[1]=4'd9;
//            mem[2]=4'd25; 
        end
    
    always @(posedge clk) //On the positive edge of the clock, if mem_write coming from the control unit is 1, then write into the memory the specified input data                     
    begin //in the specified address, else do not update the memory.
        if (mem_write == 1)
            case(AU_inst_sel) 
                // SW case
                2'b00 : {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]} = data_in;
                // SH case
                2'b01 : {mem[addr], mem[addr+1]} = data_in[15:0];
                // SB case
                2'b10 : mem[addr] = data_in[7:0];
                // Default case if there is an error
                default : mem[addr] = mem[addr];
             endcase
        else
            begin
                mem[addr] = mem[addr];
            end 
    end
    
    always@(*)begin
        if (mem_read == 1)
                case(AU_inst_sel) 
                    // LW case
                    2'b00 : data_out = {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]};
                    // LH, LHU cases
                    2'b01 : 
                    begin
                        case(signed_inst)
                            // LHU case (unsigned)
                            1'b0 : data_out = {16'b0, mem[addr], mem[addr+1]};
                            // LH case (signed)
                            1'b1 : data_out = {{16{data_in[15]}},mem[addr], mem[addr+1]};
                            // Default case if there is an error
                            default : data_out = 32'b0;
                        endcase
                    end
                    // LB, LBU, SB cases
                    2'b10 : 
                    begin
                        case(signed_inst)
                            // LBU case (unsigned)
                            1'b0 : data_out = {24'b0, data_in[7:0]};
                            // LB, SB cases (signed)
                            1'b1 : data_out = {{24{data_in[7]}},data_in[7:0]};
                            // Default case if there is an error
                            default : data_out = 32'b0;
                        endcase
                    end
                    // Default case if there is an error
                    default : data_out = 32'b0;
                endcase
            else
                begin
                    mem[addr] = mem[addr];
                end 
        assign data_out = (mem_read)? mem[addr]:32'd0; //If memory read coming from the control unit is 1, then read the memory in the specified address, else output data = 0.
    end
endmodule
