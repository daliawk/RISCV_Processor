`timescale 1ns / 1ps
/******************************************************************* * 
* Module:   Seven_Segment_Display.v 
* Project:  RISCV_PROCESSOR 
* Author:   Dalia Elnagar - daliawk@aucegypt.edu
*           Kareem A. Mohammed - kareemamr213@aucegypt.edu
*           Kirolos M. Mikhail - kirolosmorcos237@aucegypt.edu
*
* Description: This module takes a 13 bit value and converts it to its BCD
*              equivalent then gives out the led layout and anodes 
* 
* Change history: 10/29/21 – modified to follow coding guidlines
*
**********************************************************************/ 

module Seven_Segment_Display( 
input clk, 
input [12:0] num, 
output reg [3:0] anode, 
output reg [6:0] led_out 
 ); 
    reg  [3:0]  thousands;
    reg  [3:0]  hundreds;
    reg  [3:0]  tens;
    reg  [3:0]  ones;
    reg  [3:0]  led_bcd; 
    reg  [19:0] refresh_counter = 0; // 20-bit counter 
    wire [1:0]  led_activating_counter; 

    always @(posedge clk) 
    begin 
        refresh_counter <= refresh_counter + 1; 
    end 
    
    assign led_activating_counter = refresh_counter[19:18]; 
    
    always @(*) 
    begin 
        case(led_activating_counter) 
            2'b00: 
            begin
                anode = 4'b0111; 
                led_bcd = thousands; 
            end 
            2'b01: 
            begin
                anode = 4'b1011; 
                led_bcd = hundreds; 
            end 
            2'b10: 
            begin
                anode = 4'b1101; 
                led_bcd = tens; 
            end 
            2'b11: 
            begin
                anode = 4'b1110; 
                led_bcd = ones; 
            end 
        endcase 
    end 
    always @(*) 
    begin 
        case(led_bcd) 
            4'b0000:
                led_out = 7'b0000001; // "0" 
            4'b0001:
                led_out = 7'b1001111; // "1" 
            4'b0010: 
                led_out = 7'b0010010; // "2" 
            4'b0011: 
                led_out = 7'b0000110; // "3" 
            4'b0100: 
                led_out = 7'b1001100; // "4" 
            4'b0101: 
                led_out = 7'b0100100; // "5" 
            4'b0110: 
                led_out = 7'b0100000; // "6" 
            4'b0111: 
                led_out = 7'b0001111; // "7" 
            4'b1000: 
                led_out = 7'b0000000; // "8" 
            4'b1001: 
                led_out = 7'b0000100; // "9" 
            default: 
                led_out = 7'b0000001; // "0" 
        endcase 
    end 
    
    genvar i; 
    always @(num) 
    begin 
        //initialization 
        thousands = 4'd0;
        hundreds = 4'd0; 
        tens = 4'd0; 
        ones = 4'd0; 
        for (i = 12; i >= 0 ; i = i-1 ) 
            begin: loop1
            if(thousands >= 5 ) 
                thousands = thousands + 3; 
            if(hundreds >= 5 ) 
                hundreds = hundreds + 3; 
            if (tens >= 5 ) 
                tens = tens + 3; 
            if (ones >= 5) 
                ones = ones +3; 

            //shift left one 
            thousands = thousands <<1;                        
            thousands[0] = hundreds [3];

            hundreds = hundreds << 1; 
            hundreds [0] = tens [3]; 

            tens = tens << 1; 
            tens [0] = ones[3]; 

            ones = ones << 1; 
            ones[0] = num[i]; 
        end 
    end 


endmodule 