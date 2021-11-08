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
    input [7:0] addr, 
    input [31:0] data_in, 
    output reg [31:0] data_out
    );
    reg [7:0] mem [0:63]; //Memory that has 64 slots, each slot 8 bits in width.

    initial //Initial values for testbench testing.
        begin
             mem[0]=8'd17;
             mem[1]=8'd0; 
             mem[2]=8'd0;
             mem[3]=8'd0;
             mem[4]=8'd9;
             mem[5]=8'd0; 
             mem[6]=8'd0;
             mem[7]=8'd0;
             mem[8]=8'd25;
             mem[9]=8'd0;
             mem[10]=8'd0;
             mem[11]=8'd0;
             mem[12]=8'd0;
             mem[13]=8'd0;
             mem[14]=8'd0;
             mem[15]=8'd0;  
             
//            mem[0]=4'd17; 
//            mem[1]=4'd9;
//            mem[2]=4'd25; 
        end
    
    always @(posedge clk) //On the positive edge of the clock, if mem_write coming from the control unit is 1, then write into the memory the specified input data                     
    begin //in the specified address, else do not update the memory.
        if (mem_write == 1)
            case(AU_inst_sel) 
                // SW case
                2'b00 : {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]} = data_in;
                // SH case
                2'b01 : { mem[addr+1], mem[addr] } = data_in[15:0];
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
                    2'b00 : data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
                    // LH, LHU cases
                    2'b01 : 
                    begin
                        case(signed_inst)
                            // LHU case (unsigned)
                            1'b0 : data_out = {16'b0, mem[addr+1], mem[addr]};
                            // LH case (signed)
                            1'b1 : data_out = {{16{mem[addr+1][3]}}, mem[addr+1], mem[addr]};
                            // Default case if there is an error
                            default : data_out = 32'b0;
                        endcase
                    end
                    // LB, LBU cases
                    2'b10 : 
                    begin
                        case(signed_inst)
                            // LBU case (unsigned)
                            1'b0 : data_out = {24'b0, mem[addr]};
                            // LB case (signed)
                            1'b1 : data_out = {{24{mem[addr][3]}}, mem[addr]};
                            // Default case if there is an error
                            default : data_out = 32'b0;
                        endcase
                    end
                    // Default case if there is an error
                    default : data_out = 32'b0;
                endcase
            else
                begin
                    data_out = 32'b0;
                end 
        end
endmodule
