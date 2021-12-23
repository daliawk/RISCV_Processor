
# RISCV_Processor

This repository contains all necessary files needed to run all of the
40 RV32IMC instructions.\
The repo implements all the 40 RISC V base Instructions, the integar multiplication, division and remainder instructions as well as some of the compressed instructions.
\
This repo has been compiled by:

|            Name           |     ID    |
|:-------------------------:|:---------:|
| Dalia Elnagar             | 900191234 |
| Kirolos M. Mikhail        | 900191250 |
| Kareem A. Mohammed Talaat | 900192903 |





## Contents
Here you will find the following folders and files:


### Verilog
This folder contains all of the necessary modules that are used to make the RISCV processor.\
The top module in this folder is the CPU.v file (and CPU_FPGA_Test.v for the FPGA testing), as it combines all the other modules together making the processor. 

### Test
This folder contains all test text files that are used to check the functionality
 of all of the implemented instructions.\
All of the results are then tabulated and the results can be rechecke with the saved simulation file added to the test cases file.\

It also contains contains the constraint file used to test the instructions on the FPGA Nexys A7 board and the test bench file that is used to run and simulate all the test cases, including, but not limited to the ones mentioned above.

### Reports 
contains both reports for the 2 milestones
#### MS_2 Report
This word document contains the schematic of our design, as well as a brief
discrption of all the main modules used and how they function. 

#### MS_3 and MS_4 Report
This word document contains the updated schematic of the new data path, as well as a description of all main modules used and a description of the milestine. 

### Bugs and Errors
All of the 40 base instructions and the multiplication, division and remainder instructions are working as expected with most corner cases covered.\
All of the compressed instructions are working as expected, except the LUI and SW instruction.\
only 16 of the compressed instructions were implemented as these were the ones that could have been mapped to existing 32-instructions. 