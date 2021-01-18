Mov #100,R6
Mov #20,R2
Mov R6,R2
And R2,R2
Loopa:
INc R4
Inc R4
NOP
CMP R4,R4
BNE loopa
HLT
