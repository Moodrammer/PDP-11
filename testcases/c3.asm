Mov #100,R6
Mov #12,R2
Mov R6,@R2
Add R2,@R2
Loopa:
INc R4
Inc R4
NOP
CMP R4,R4
BNE loopa
HLT

DEFINE M 10

