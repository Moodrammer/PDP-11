MOV #1800,R6 ;address 0 to initialize stack pointer
JSR serviceRoutine ;address 2
mov #15, R4 ;address 4
HLT ; address 6
serviceRoutine 
mov #2, R1 ;address 7
loopa:
ADD #20,R0 ;address 9
dec R1 ; address 11
bne loopa ;address 12
RTS ; address 13
