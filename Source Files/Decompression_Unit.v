`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2021 07:07:58 PM
// Design Name: 
// Module Name: Decompression_Unit
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


module Decompression_Unit(
input rst,
input clk,
input  [31:0] instruction,
output reg [31:0] new_inst,
output reg terminate,
output reg comp
);
    always@(*)
    begin
    if(rst)
        begin
        new_inst = 32'd0;
        terminate = 1'b0;
        comp = 1'b0;
        end 
            
    else if(~clk)
    begin
        new_inst = instruction;
        terminate =0;
    end
    else if(instruction[1:0] == 2'b11)
            begin
            comp =1'b0;
            new_inst = instruction;
            terminate = 1'b0;
            end
    else
    begin
        comp = 1'b1;
        if({instruction[15:13],instruction[1:0]} == 5'b01000)
            begin
            new_inst = {{5{instruction[5]}}, instruction[5], instruction[12:10], instruction[6], 2'b00, 2'b00, instruction[9:7],3'b010, 2'b00, instruction[4:2],7'b0000011};
            terminate = 1'b0;
                comp = 1'b1;
            end
            
        else if({instruction[15:13],instruction[1:0]} == 5'b11000)
            begin
            new_inst = {{5{instruction[5]}},instruction[5], instruction[12],2'b00, instruction[4:2],2'b00, instruction[9:7],3'b010, instruction[11:10],instruction[6],2'b00, 7'b0100011};
            terminate = 1'b0;
                comp = 1'b1;
            end
            
        else if({instruction[15:13],instruction[1:0]} == 5'b00001)
            begin
            new_inst = {{6{instruction[12]}},instruction[12],instruction[6:2],instruction[11:7],3'b000,instruction[11:7],7'b0010011};
                comp = 1'b1;
    
            if((instruction[11:7] == 0) || ({instruction[12],instruction[6:2]}==0))
                terminate = 1'b1;
            else
                terminate = 1'b0;
            end
            
        else if({instruction[15:13],instruction[1:0]} == 5'b00101)
            begin
            new_inst = {instruction[8],instruction[8], instruction[10:9], instruction[6], instruction[7], instruction[2], instruction[11], instruction[5:3], instruction[12],{8{instruction[8]}}, 5'b00001, 7'b1101111};
            terminate = 1'b0;
                comp = 1'b1;
            end
        
        else if({instruction[15:13],instruction[1:0]} == 5'b01101)
            begin
            new_inst = {{15{instruction[12]}}, instruction[12], instruction[6:2], instruction[11:7], 7'b0110111};
                comp = 1'b1;
    
            if((instruction[11:7] == 0) || (instruction[11:7] == 2) || ({instruction[12],instruction[6:2]}==0))
                terminate = 1'b1;
            else
                terminate = 1'b0;
            end
        else if({instruction[15:13],instruction[1:0]} == 5'b10001)
        begin
        case(instruction[11:10])
            2'b00:
                begin
                new_inst = {7'b0000000,instruction[6:2], 2'b00, instruction[9:7], 3'b101, 2'b00, instruction[9:7], 7'b0010011 };
                    comp = 1'b1;
    
                if(instruction[6:2]==0)
                    terminate = 1'b1;
                else
                    terminate = 1'b0;
                end
            2'b01:
                begin
                new_inst = {7'b0100000,instruction[6:2], 2'b00, instruction[9:7], 3'b101, 2'b00, instruction[9:7], 7'b0010011 };
                    comp = 1'b1;
    
                if(instruction[6:2]==0)
                   terminate = 1'b1;
                else
                   terminate = 1'b0;
               end
            2'b10:
               begin
                new_inst = {{6{instruction[12]}},instruction[12],instruction[6:2], 2'b00, instruction[9:7], 3'b111, 2'b00, instruction[9:7], 7'b0010011 };
                terminate = 1'b0;
                    comp = 1'b1;
    
                end
            2'b11:
                case(instruction[6:5])
                    2'b00:
                        begin
                        new_inst = {7'b0100000,2'b00, instruction[4:2], 2'b00, instruction[9:7], 3'b000, 2'b00, instruction[9:7], 7'b0110011};
                        terminate = 1'b0;
                            comp = 1'b1;
    
                        end
                    2'b01:
                        begin
                        new_inst = {7'b0000000,2'b00, instruction[4:2], 2'b00, instruction[9:7], 3'b100, 2'b00, instruction[9:7], 7'b0110011};
                        terminate = 1'b0;
                            comp = 1'b1;
    
                        end
                    2'b10:
                        begin
                        new_inst = {7'b0000000,2'b00, instruction[4:2], 2'b00, instruction[9:7], 3'b110, 2'b00, instruction[9:7], 7'b0110011};
                        terminate = 1'b0;
                            comp = 1'b1;
    
                        end     
                    2'b11:
                        begin
                        new_inst = {7'b0000000,2'b00, instruction[4:2], 2'b00, instruction[9:7], 3'b111, 2'b00, instruction[9:7], 7'b0110011};
                        terminate = 1'b0;
                            comp = 1'b1;
    
                        end  
                    default:
                        begin
                        new_inst = 32'b00000000000000000000000000000000;
                        terminate = 1'b0;
                        end 
                endcase
                
                default:
                    begin
                    new_inst = 32'b00000000000000000000000000000000;
                    terminate = 1'b0;
                    end 
            endcase
    end
    else if({instruction[15:13],instruction[1:0]} == 5'b00010)
    begin
    new_inst = {7'b0000000, instruction[12], instruction[6:2], instruction[11:7], 3'b001, instruction[11:7], 7'b0010011};
        comp = 1'b1;

    if(instruction[11:7] == 0)
        terminate = 1'b1;
    else
        terminate = 1'b0;
    end
   
    else if({instruction[15:13],instruction[1:0]} == 5'b10010)
    begin
    if(instruction[11:2] == 0)
        begin
        new_inst = 32'b00000000000100000000000001110011;
        comp = 1'b1;
        terminate = 1'b1;
        end
    else if (instruction[6:2] == 0)
        begin
        new_inst = {12'b000000000000, instruction[11:7], 3'b000, 5'b00001, 7'b1100111};
        comp = 1'b1;
        terminate = 1'b0;
        end
    else
        begin
        new_inst = {7'b0000000, instruction[6:2], instruction[11:7], 3'b111,instruction[11:7], 7'b0110011};
        comp = 1'b1;
        terminate = 1'b0;
        end
    end
    else
        begin
        new_inst = 32'b00000000000000000000000000000000;
        terminate = 1'b0;
        end 
    end
    end

endmodule
